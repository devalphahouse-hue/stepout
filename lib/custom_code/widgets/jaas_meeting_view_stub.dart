// Mobile implementation using native Jitsi Meet SDK (with screen sharing support)
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:permission_handler/permission_handler.dart';

class JaasMeetingViewPlatform extends StatefulWidget {
  const JaasMeetingViewPlatform({
    super.key,
    required this.width,
    required this.height,
    required this.appId,
    required this.roomShort,
    required this.jwt,
    this.audioMuted = true,
    this.videoMuted = false,
    this.prejoin = false,
    this.lang = 'ptBR',
    this.displayName = '',
    this.email = '',
    this.enableSpaNavigationListeners = false,
    this.endSignal = 0,
    this.onJwtRefreshNeeded,
  });

  final double width;
  final double height;
  final String appId;
  final String roomShort;
  final String jwt;
  final bool audioMuted;
  final bool videoMuted;
  final bool prejoin;
  final String lang;
  final String displayName;
  final String email;
  final bool enableSpaNavigationListeners;

  /// SINAL para encerrar a call. Sempre que esse número mudar, encerra a call.
  final int endSignal;
  final VoidCallback? onJwtRefreshNeeded;

  @override
  State<JaasMeetingViewPlatform> createState() =>
      _JaasMeetingViewPlatformState();
}

enum _PermPhase { checking, joining, blocked }

class _JaasMeetingViewPlatformState extends State<JaasMeetingViewPlatform> {
  final JitsiMeet _jitsiMeet = JitsiMeet();
  bool _joined = false;
  _PermPhase _phase = _PermPhase.checking;

  // Re-join automático após queda: o SDK mobile NÃO tem renovação de JWT em
  // sessão viva — a única recuperação é re-entrar com token fresco.
  bool _intentionalLeave = false;
  int _rejoinCount = 0;
  static const int _maxRejoinAttempts = 3;
  Timer? _rejoinTimer;

  @override
  void initState() {
    super.initState();
    if (widget.jwt.isNotEmpty) {
      _prepareAndJoin();
    }
  }

  @override
  void didUpdateWidget(covariant JaasMeetingViewPlatform oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Encerra a call quando endSignal mudar
    if (widget.endSignal != oldWidget.endSignal) {
      _intentionalLeave = true;
      _rejoinTimer?.cancel();
      _jitsiMeet.hangUp();
      return;
    }

    final jwtBecameAvailable =
        oldWidget.jwt.isEmpty && widget.jwt.isNotEmpty && !_joined;

    if (jwtBecameAvailable) {
      _prepareAndJoin();
    }
  }

  /// Solicita câmera + microfone ANTES de subir o Jitsi. No Android nativo, o
  /// prompt do Jitsi às vezes não aparece (ou só na primeira vez), deixando o
  /// usuário preso numa sala sem câmera. Pedindo aqui, o popup do sistema
  /// aparece de forma confiável e, se a permissão estiver negada de vez,
  /// mostramos uma tela com botão pra abrir as configurações.
  Future<void> _prepareAndJoin() async {
    if (_joined) return;

    // O gate de permissão (permission_handler) é SÓ pro Android, onde o prompt
    // do Jitsi às vezes não aparecia. No iOS o Jitsi já pede câmera/mic
    // nativamente (Info.plist) e funciona — não rodamos o permission_handler
    // aqui pra não alterar o fluxo que já está na loja e não depender das
    // macros de permissão no Podfile do iOS.
    if (!Platform.isAndroid) {
      if (mounted) setState(() => _phase = _PermPhase.joining);
      await _joinMeeting();
      return;
    }

    final statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    // Câmera é o requisito central deste fluxo. Se ela ficou permanentemente
    // negada, não entramos direto numa sala "cega" — orientamos o ajuste.
    final camPermanentlyDenied =
        statuses[Permission.camera]?.isPermanentlyDenied == true;

    if (camPermanentlyDenied) {
      if (mounted) setState(() => _phase = _PermPhase.blocked);
      return;
    }

    // Mesmo que o usuário negue uma vez (não permanente), seguimos entrando:
    // ele consegue ligar a câmera depois pelo botão do Jitsi, e o áudio segue.
    if (mounted) setState(() => _phase = _PermPhase.joining);
    await _joinMeeting();
  }

  Future<void> _joinMeeting() async {
    if (_joined) return;
    _joined = true;

    final options = JitsiMeetConferenceOptions(
      serverURL: "https://8x8.vc",
      room: "${widget.appId}/${widget.roomShort}",
      token: widget.jwt,
      userInfo: JitsiMeetUserInfo(
        displayName: widget.displayName.isNotEmpty ? widget.displayName : null,
        email: widget.email.isNotEmpty ? widget.email : null,
      ),
      configOverrides: {
        "startWithAudioMuted": widget.audioMuted,
        "startWithVideoMuted": widget.videoMuted,
        "prejoinPageEnabled": widget.prejoin,
        "defaultLanguage": widget.lang,
        // Áudio — sem redução involuntária de volume
        "enableNoisyMicDetection": false,
        "disableAGC": true,
        "enableNoAudioDetection": true,
        "audioQuality": {"opusMaxAverageBitrate": 32000},
        // Vídeo — degradação suave em rede ruim.
        // ATENÇÃO: NÃO reintroduzir `resolution`/`constraints` customizados aqui.
        // Constraints de vídeo customizadas fazem o WebRTC do Android (Camera2)
        // REJEITAR a negociação e DESABILITAR a câmera (botão riscado, não liga),
        // só no Android — iOS/web toleram. Confirmado no Jitsi issue #15027
        // (Samsung). Deixamos o Jitsi negociar a resolução padrão (720p).
        "enableSimulcast": true,
        "enableLayerSuspension": true,
        "channelLastN": 4,
        "startBitrate": 800,
        // Rede & resiliência
        "p2p": {"enabled": false},
        "enableIceRestart": true,
        "openBridgeChannel": "websocket",
      },
      featureFlags: {
        "unsaferoomwarning.enabled": false,
        // Compartilhamento de tela precisa ser habilitado explicitamente.
        // No iOS, o botão de screen share NÃO aparece sem este flag — mesmo
        // com a Broadcast Upload Extension corretamente configurada/assinada.
        // O plugin Flutter não expõe essas chaves como constantes, mas o SDK
        // nativo do Jitsi as reconhece via o mapa featureFlags.
        "ios.screensharing.enabled": true,
        "android.screensharing.enabled": true,
      },
    );

    final listener = JitsiMeetEventListener(
      conferenceJoined: (url) {
        // Conferência saudável — zera o contador de re-join
        _rejoinCount = 0;
      },
      conferenceTerminated: (url, error) {
        if (!mounted) {
          return;
        }
        setState(() => _joined = false);

        // Terminou com ERRO e não foi saída intencional: pede um JWT fresco
        // pro pai (o token atual pode ter expirado — no mobile não existe
        // renovação em sessão viva, só re-join com token novo) e re-entra
        // com backoff. widget.jwt já estará renovado quando o timer disparar.
        final unexpectedDrop = error != null && !_intentionalLeave;
        if (unexpectedDrop && _rejoinCount < _maxRejoinAttempts) {
          _rejoinCount++;
          widget.onJwtRefreshNeeded?.call();
          _rejoinTimer?.cancel();
          _rejoinTimer = Timer(Duration(seconds: 4 * _rejoinCount), () {
            if (!mounted || _intentionalLeave || widget.jwt.isEmpty) return;
            _joinMeeting();
          });
          return;
        }

        // Encerramento normal (ou re-join esgotado) — volta pra tela anterior
        Navigator.of(context).maybePop();
      },
    );

    await _jitsiMeet.join(options, listener);
  }

  @override
  void dispose() {
    _intentionalLeave = true;
    _rejoinTimer?.cancel();
    _jitsiMeet.hangUp();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.black,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: _phase == _PermPhase.blocked
          ? _buildBlocked()
          : _buildLoading(),
    );
  }

  Widget _buildLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(color: Colors.white),
        const SizedBox(height: 16),
        Text(
          _phase == _PermPhase.checking
              ? 'Verificando permissões...'
              : 'Entrando na reunião...',
          style: const TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBlocked() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.videocam_off, color: Colors.white, size: 48),
        const SizedBox(height: 16),
        const Text(
          'Câmera bloqueada',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'O acesso à câmera está negado para o app. Toque abaixo, '
          'permita a Câmera (e o Microfone) e volte para a aula.',
          style: TextStyle(color: Colors.white70, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => openAppSettings(),
          icon: const Icon(Icons.settings),
          label: const Text('Abrir configurações'),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            setState(() => _phase = _PermPhase.checking);
            _prepareAndJoin();
          },
          child: const Text(
            'Já permiti, tentar novamente',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
