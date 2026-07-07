// Web implementation using the OFFICIAL JaaS IFrame API (JitsiMeetExternalAPI).
//
// Antes desta versão o widget montava um <iframe> manualmente apontando pra
// https://8x8.vc/<appId>/<room>?jwt=... e escutava postMessage cru — formato
// interno NÃO documentado do Jitsi, sujeito a quebrar em qualquer release do
// JaaS. Agora seguimos o modelo documentado (developer.8x8.com/jaas →
// iframe-api-integration): carregamos o script por tenant
// https://8x8.vc/<AppID>/external_api.js e instanciamos JitsiMeetExternalAPI,
// que nos dá eventos oficiais (videoConferenceJoined/Left, readyToClose,
// errorOccurred, passwordRequired) e comandos (executeCommand('hangup'),
// dispose()).
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'dart:ui_web' as ui_web;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:js_util' as js_util;

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

  /// SINAL para encerrar a call. Sempre que esse número mudar, encerra a call
  /// graciosamente (executeCommand('hangup') → readyToClose → dispose()).
  final int endSignal;
  final VoidCallback? onJwtRefreshNeeded;

  @override
  State<JaasMeetingViewPlatform> createState() =>
      _JaasMeetingViewPlatformState();
}

class _JaasMeetingViewPlatformState extends State<JaasMeetingViewPlatform> {
  late final String _viewType;

  /// Container onde o external_api.js cria o iframe (parentNode).
  html.DivElement? _container;

  /// Instância JS de JitsiMeetExternalAPI (null enquanto não criada).
  Object? _api;

  /// Impede que rebuilds do StreamBuilder recriem a conferência.
  bool _meetingLoaded = false;

  html.EventListener? _beforeUnloadListener;
  StreamSubscription<html.PopStateEvent>? _popStateSub;
  StreamSubscription<html.Event>? _hashChangeSub;

  late String _iframeDomId;
  late String _roomKey;

  // Reconexão automática
  bool _disposed = false;
  bool _intentionalLeave = false;
  int _reconnectCount = 0;
  Timer? _reconnectTimer;
  // Backoff progressivo: 2s, 4s, 6s, ... até 20s. Máximo de 10 tentativas.
  static const int _maxReconnectAttempts = 10;

  // Delay antes de forçar reconexão (dá tempo pro Jitsi ICE restart)
  Timer? _reconnectDelayTimer;

  // Fallback caso o readyToClose não chegue depois do hangup
  Timer? _hangupFallbackTimer;

  // Renovação automática do JWT antes de expirar
  Timer? _jwtRefreshTimer;

  // Token foi rejeitado (expirado/inválido) — reconectar assim que o pai
  // entregar um JWT novo via onJwtRefreshNeeded.
  bool _reconnectAfterJwtRefresh = false;

  // Listener de visibilidade da aba
  html.EventListener? _visibilityListener;

  // Listener de reconexão automática quando internet volta
  html.EventListener? _onlineListener;

  /// Cache do carregamento do external_api.js por tenant (evita injetar o
  /// <script> duas vezes quando há mais de uma instância do widget).
  static final Map<String, Future<void>> _scriptLoads = {};

  @override
  void initState() {
    super.initState();

    _syncRoomKeys();
    _cleanupOrphansForThisRoom(skipCurrent: false);

    _viewType = 'jaas-iframe-${DateTime.now().microsecondsSinceEpoch}';
    _container = html.DivElement()
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.background = '#000'
      ..setAttribute('data-jaas-container', 'true')
      ..setAttribute('data-room', _roomKey);

    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int _) => _container!,
    );

    _beforeUnloadListener = (event) {
      (event as html.BeforeUnloadEvent).returnValue =
          'Você está em uma aula ao vivo. Deseja realmente sair?';
    };
    html.window.addEventListener('beforeunload', _beforeUnloadListener!);

    // Detecta quando a aba volta ao foreground para resetar reconexão
    _visibilityListener = (_) {
      if (_disposed || _intentionalLeave) return;
      if (html.document.visibilityState == 'visible') {
        _reconnectCount = 0;
      }
    };
    html.document.addEventListener('visibilitychange', _visibilityListener!);

    // Quando internet volta, apenas reseta o contador.
    // NÃO recria a conferência — o Jitsi tenta ICE restart automaticamente.
    _onlineListener = (_) {
      if (_disposed || _intentionalLeave) return;
      _reconnectCount = 0;
    };
    html.window.addEventListener('online', _onlineListener!);

    if (widget.enableSpaNavigationListeners) {
      _popStateSub = html.window.onPopState.listen((_) => _leaveMeeting());
      _hashChangeSub =
          html.window.onHashChange.listen((_) => _leaveMeeting());
    }

    // Só cria a conferência quando o JWT já está disponível — evita o flash
    // de "authentication failed" que o iframe com jwt vazio causava.
    if (widget.jwt.isNotEmpty) {
      _meetingLoaded = true;
      _createApi();
    }
  }

  void _syncRoomKeys() {
    _roomKey = '${widget.appId}__${widget.roomShort}';
    _iframeDomId = 'jaas_iframe_${_roomKey}';
  }

  // ──────────────────────────── external_api.js ────────────────────────────

  /// Garante que o script oficial por tenant está carregado
  /// (https://8x8.vc/<AppID>/external_api.js — forma documentada pelo JaaS).
  Future<void> _ensureExternalApiScript() {
    if (js_util.hasProperty(html.window, 'JitsiMeetExternalAPI')) {
      return Future<void>.value();
    }
    return _scriptLoads.putIfAbsent(widget.appId, () {
      final completer = Completer<void>();
      final script = html.ScriptElement()
        ..src = 'https://8x8.vc/${widget.appId}/external_api.js'
        ..async = true;
      script.onLoad.first.then((_) {
        if (!completer.isCompleted) completer.complete();
      });
      script.onError.first.then((_) {
        // Remove do cache pra próxima tentativa reinjetar o script
        _scriptLoads.remove(widget.appId);
        script.remove();
        if (!completer.isCompleted) {
          completer.completeError(
              StateError('Falha ao carregar external_api.js'));
        }
      });
      html.document.head!.append(script);
      return completer.future;
    });
  }

  /// Cria (ou recria) a instância JitsiMeetExternalAPI dentro do container.
  /// Recriar a instância é também o mecanismo de reconexão — sempre usa o
  /// widget.jwt ATUAL, então uma reconexão pós-refresh já entra com token novo.
  Future<void> _createApi() async {
    if (_disposed || _intentionalLeave || widget.jwt.isEmpty) return;

    try {
      await _ensureExternalApiScript();
    } catch (_) {
      // Script não carregou (rede fora?) — tenta de novo com backoff
      _attemptReconnect();
      return;
    }
    if (_disposed || _intentionalLeave || _container == null) return;

    _destroyApi();

    final options = js_util.newObject();
    js_util.setProperty(
        options, 'roomName', '${widget.appId}/${widget.roomShort}');
    js_util.setProperty(options, 'jwt', widget.jwt);
    js_util.setProperty(options, 'parentNode', _container);
    js_util.setProperty(options, 'width', '100%');
    js_util.setProperty(options, 'height', '100%');
    js_util.setProperty(
        options, 'configOverwrite', js_util.jsify(_buildConfigOverwrite()));
    if (widget.displayName.isNotEmpty || widget.email.isNotEmpty) {
      js_util.setProperty(
        options,
        'userInfo',
        js_util.jsify(<String, String>{
          if (widget.displayName.isNotEmpty) 'displayName': widget.displayName,
          if (widget.email.isNotEmpty) 'email': widget.email,
        }),
      );
    }

    try {
      final ctor = js_util.getProperty(html.window, 'JitsiMeetExternalAPI');
      _api = js_util.callConstructor(ctor as Object, ['8x8.vc', options]);
    } catch (_) {
      _attemptReconnect();
      return;
    }

    _tagIframe();
    _addApiListeners();
    _scheduleJwtRefresh(widget.jwt);
  }

  /// Marca o iframe criado pelo external_api com id/data-* estáveis, pra
  /// limpeza de órfãos funcionar entre instâncias (e com a versão antiga).
  void _tagIframe() {
    try {
      final f = js_util.callMethod(_api!, 'getIFrame', []);
      if (f is html.IFrameElement) {
        f
          ..id = _iframeDomId
          ..setAttribute('data-jaas', 'true')
          ..setAttribute('data-room', _roomKey);
      }
    } catch (_) {}
  }

  void _on(String event, void Function(dynamic) handler) {
    try {
      js_util.callMethod(
          _api!, 'addListener', [event, js_util.allowInterop(handler)]);
    } catch (_) {}
  }

  void _addApiListeners() {
    // Entrou na sala — Jitsi está saudável, zera o estado de reconexão
    _on('videoConferenceJoined', (_) {
      if (_disposed) return;
      _reconnectCount = 0;
      _reconnectDelayTimer?.cancel();
    });

    // Saiu da sala (queda de rede, kick, ou hangup pelo botão do Jitsi).
    // Dá 15s pro ICE restart interno do Jitsi antes de forçar reconexão —
    // se videoConferenceJoined chegar nesse meio tempo, o timer é cancelado.
    _on('videoConferenceLeft', (_) => _scheduleDelayedReconnect());

    // Hangup concluído. Se foi o app que encerrou (endSignal/navegação),
    // este é o momento sancionado pra dar dispose(). Caso contrário, trata
    // como desconexão (mesmo fluxo do videoConferenceLeft).
    _on('readyToClose', (_) {
      if (_disposed) return;
      if (_intentionalLeave) {
        _hangupFallbackTimer?.cancel();
        _destroyApi();
        return;
      }
      _scheduleDelayedReconnect();
    });

    // Erro oficial do Jitsi. isFatal = o Jitsi mostrou o overlay de
    // reconexão dele; nosso backoff entra como reforço. Erros de token
    // pedem refresh do JWT antes de reconectar.
    _on('errorOccurred', (data) {
      if (_disposed || _intentionalLeave) return;
      try {
        final err = js_util.getProperty(data as Object, 'error') ?? data;
        final name =
            (js_util.getProperty(err as Object, 'name') ?? '').toString();
        final message =
            (js_util.getProperty(err, 'message') ?? '').toString();
        final isFatal = js_util.getProperty(err, 'isFatal') == true;

        final tokenProblem = name.toLowerCase().contains('token') ||
            message.toLowerCase().contains('token');
        if (tokenProblem) {
          _reconnectAfterJwtRefresh = true;
          widget.onJwtRefreshNeeded?.call();
          return;
        }
        if (isFatal) {
          _scheduleDelayedReconnect();
        }
      } catch (_) {}
    });

    // JWT rejeitado no (re)join — pede token novo; a reconexão acontece no
    // didUpdateWidget quando o pai entregar o JWT renovado.
    _on('passwordRequired', (_) {
      if (_disposed || _intentionalLeave) return;
      _reconnectAfterJwtRefresh = true;
      widget.onJwtRefreshNeeded?.call();
    });
  }

  void _destroyApi() {
    if (_api != null) {
      try {
        js_util.callMethod(_api!, 'dispose', []);
      } catch (_) {}
      _api = null;
    }
  }

  // ──────────────────────────── JWT lifecycle ────────────────────────────

  /// Decodifica o payload do JWT para extrair o timestamp de expiração (campo `exp`).
  int? _getJwtExp(String jwt) {
    try {
      final parts = jwt.split('.');
      if (parts.length != 3) return null;
      String payload = parts[1];
      switch (payload.length % 4) {
        case 2:
          payload += '==';
          break;
        case 3:
          payload += '=';
          break;
      }
      final decoded = utf8.decode(base64Url.decode(payload));
      final map = json.decode(decoded) as Map<String, dynamic>;
      return map['exp'] as int?;
    } catch (_) {
      return null;
    }
  }

  /// Agenda a renovação do JWT 30 minutos antes de expirar.
  void _scheduleJwtRefresh(String jwt) {
    _jwtRefreshTimer?.cancel();
    if (jwt.isEmpty) return;

    final exp = _getJwtExp(jwt);
    if (exp == null) return;

    final expiresAt = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    final refreshAt = expiresAt.subtract(const Duration(minutes: 30));
    final now = DateTime.now();

    if (refreshAt.isBefore(now)) {
      widget.onJwtRefreshNeeded?.call();
      return;
    }

    final delay = refreshAt.difference(now);
    _jwtRefreshTimer = Timer(delay, () {
      if (_disposed) return;
      widget.onJwtRefreshNeeded?.call();
    });
  }

  // ──────────────────────────── Reconexão ────────────────────────────

  /// Dá 15s pro Jitsi tentar ICE restart interno antes de forçar reconexão.
  void _scheduleDelayedReconnect() {
    if (_disposed || _intentionalLeave) return;
    _reconnectDelayTimer?.cancel();
    _reconnectDelayTimer = Timer(const Duration(seconds: 15), () {
      if (_disposed || _intentionalLeave) return;
      _attemptReconnect();
    });
  }

  /// Tenta reconectar ao JaaS após desconexão não intencional.
  /// Backoff progressivo de 2s em 2s (2s, 4s, ... 20s), máximo de
  /// [_maxReconnectAttempts] tentativas. Reconectar = recriar a instância
  /// JitsiMeetExternalAPI com o JWT atual (pós-refresh entra com token novo).
  void _attemptReconnect() {
    if (_disposed || _intentionalLeave) return;
    if (_reconnectCount >= _maxReconnectAttempts) return;
    if (widget.jwt.isEmpty) return;

    _reconnectCount++;
    final delaySec = _reconnectCount * 2;

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: delaySec), () {
      if (_disposed || _intentionalLeave) return;
      _createApi();
    });
  }

  @override
  void didUpdateWidget(covariant JaasMeetingViewPlatform oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Encerra a call graciosamente quando endSignal mudar
    if (widget.endSignal != oldWidget.endSignal) {
      _leaveMeeting();
      return;
    }

    final roomChanged = oldWidget.appId != widget.appId ||
        oldWidget.roomShort != widget.roomShort;

    // Só cria a conferência na PRIMEIRA vez que o JWT fica disponível.
    // _meetingLoaded impede que rebuilds do StreamBuilder a recriem.
    final jwtBecameAvailable =
        oldWidget.jwt.isEmpty && widget.jwt.isNotEmpty && !_meetingLoaded;

    if (roomChanged) {
      _syncRoomKeys();
      _cleanupOrphansForThisRoom(skipCurrent: true);
      _meetingLoaded = false;
      _reconnectCount = 0;
      _container?.setAttribute('data-room', _roomKey);
    }

    if (roomChanged || jwtBecameAvailable) {
      _meetingLoaded = true;
      _createApi();
    }

    // JWT foi renovado com um token diferente (refresh antes de expirar).
    // NÃO recria a conferência — o JWT atual continua válido na sessão Jitsi.
    // O novo JWT será usado automaticamente em caso de reconexão futura.
    final jwtRefreshed = _meetingLoaded &&
        widget.jwt.isNotEmpty &&
        oldWidget.jwt.isNotEmpty &&
        oldWidget.jwt != widget.jwt;

    if (jwtRefreshed) {
      _reconnectCount = 0;

      // Exceção: o token anterior foi REJEITADO (expirado/inválido) — aqui a
      // sessão já caiu, então reconecta imediatamente com o token novo.
      if (_reconnectAfterJwtRefresh) {
        _reconnectAfterJwtRefresh = false;
        _createApi();
      }
    }

    if ((jwtBecameAvailable || jwtRefreshed) && widget.jwt.isNotEmpty) {
      _scheduleJwtRefresh(widget.jwt);
    }
  }

  // ──────────────────────────── Limpeza ────────────────────────────

  /// Remove iframes/containers órfãos desta sala deixados por instâncias
  /// anteriores (inclui o formato da implementação antiga, pré-external_api).
  void _cleanupOrphansForThisRoom({required bool skipCurrent}) {
    try {
      final currentIframe = _currentIframe();

      final existingById = html.document.getElementById(_iframeDomId);
      if (existingById is html.IFrameElement) {
        final sameAsCurrent =
            skipCurrent && identical(existingById, currentIframe);
        if (!sameAsCurrent) {
          try {
            existingById.src = 'about:blank';
          } catch (_) {}
          existingById.remove();
        }
      }

      final nodes = html.document.querySelectorAll(
        'iframe[data-jaas="true"][data-room="$_roomKey"]',
      );
      for (final n in nodes) {
        if (n is html.IFrameElement) {
          if (skipCurrent && identical(n, currentIframe)) continue;
          try {
            n.src = 'about:blank';
          } catch (_) {}
          n.remove();
        } else {
          n.remove();
        }
      }

      // Containers órfãos de instâncias anteriores deste widget
      final containers = html.document.querySelectorAll(
        'div[data-jaas-container="true"][data-room="$_roomKey"]',
      );
      for (final c in containers) {
        if (identical(c, _container)) continue;
        c.remove();
      }
    } catch (_) {}
  }

  html.IFrameElement? _currentIframe() {
    if (_api == null) return null;
    try {
      final f = js_util.callMethod(_api!, 'getIFrame', []);
      if (f is html.IFrameElement) return f;
    } catch (_) {}
    return null;
  }

  /// Encerramento intencional (endSignal, navegação SPA, dispose do widget):
  /// manda hangup oficial e espera o readyToClose pra dar dispose() — com
  /// fallback de 3s caso o evento não chegue.
  void _leaveMeeting() {
    _intentionalLeave = true;
    _reconnectTimer?.cancel();
    _reconnectDelayTimer?.cancel();

    if (_api != null) {
      try {
        js_util.callMethod(_api!, 'executeCommand', ['hangup']);
      } catch (_) {}
      _hangupFallbackTimer?.cancel();
      _hangupFallbackTimer = Timer(const Duration(seconds: 3), _destroyApi);
    }

    _cleanupOrphansForThisRoom(skipCurrent: true);
  }

  // ──────────────────────────── configOverwrite ────────────────────────────

  Map<String, dynamic> _buildConfigOverwrite() {
    return <String, dynamic>{
      // Tela de seleção de mic/câmera antes de entrar (formato atual;
      // prejoinPageEnabled é o legado deprecated)
      'prejoinConfig': {'enabled': widget.prejoin},
      'startWithAudioMuted': widget.audioMuted,
      'startWithVideoMuted': widget.videoMuted,
      'defaultLanguage': widget.lang,
      'toolbarConfig': {'alwaysVisible': true, 'autoHideTimeout': 0},

      // ── Rede & Conexão ──
      // Desabilita P2P — JVB relay é mais confiável no JaaS
      'p2p': {'enabled': false},
      // ICE restart automático em caso de queda de conexão
      'enableIceRestart': true,
      // WebSocket é mais confiável que DataChannel para o bridge
      'openBridgeChannel': 'websocket',

      // ── Áudio — processamento robusto sem redução involuntária ──
      // Detecta quando não há áudio sendo transmitido (aviso útil)
      'enableNoAudioDetection': true,
      // Desabilitado: reduzia ganho do mic ao detectar ruído ambiente
      'enableNoisyMicDetection': false,
      // AGC ativo: faz boost de mics baixos automaticamente
      'disableAGC': false,
      // Codec Opus otimizado: bitrate alto para voz clara
      'audioQuality': {'opusMaxAverageBitrate': 32000},

      // ── Vídeo — degradação suave como o Meet ──
      // Resolução ideal 720p, mínimo 180p em rede ruim
      'resolution': 720,
      'constraints': {
        'video': {
          'height': {'ideal': 720, 'max': 720, 'min': 180},
        },
      },
      // Simulcast: envia múltiplas qualidades, servidor escolhe a melhor
      'enableSimulcast': true,
      // Suspende camadas de vídeo não assistidas (economiza banda)
      'enableLayerSuspension': true,
      // Limita streams de vídeo recebidos
      'channelLastN': 4,
      // Bitrate inicial baixo — sobe conforme rede permite (como o Meet)
      'startBitrate': 800,
      // Adaptação automática de qualidade baseada na largura de banda
      'enableAdaptiveVideoQuality': true,

      // ── Compatibilidade cross-browser (Edge, Firefox) ──
      // VP8 é o codec mais compatível entre navegadores
      'preferredCodec': 'VP8',
      // Unified Plan SDP para compatibilidade com Edge
      'enableUnifiedOnChrome': true,
    };
  }

  @override
  void dispose() {
    _disposed = true;
    _reconnectTimer?.cancel();
    _reconnectDelayTimer?.cancel();
    _hangupFallbackTimer?.cancel();
    _jwtRefreshTimer?.cancel();

    if (_beforeUnloadListener != null) {
      html.window.removeEventListener('beforeunload', _beforeUnloadListener!);
    }

    _popStateSub?.cancel();
    _hashChangeSub?.cancel();

    if (_visibilityListener != null) {
      html.document
          .removeEventListener('visibilitychange', _visibilityListener!);
    }
    if (_onlineListener != null) {
      html.window.removeEventListener('online', _onlineListener!);
    }

    // No unmount o platform view some junto — hangup + dispose imediatos
    _intentionalLeave = true;
    if (_api != null) {
      try {
        js_util.callMethod(_api!, 'executeCommand', ['hangup']);
      } catch (_) {}
      _destroyApi();
    }
    _cleanupOrphansForThisRoom(skipCurrent: false);
    _container = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: HtmlElementView(viewType: _viewType),
    );
  }
}
