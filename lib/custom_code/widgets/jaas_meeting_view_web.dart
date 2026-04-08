// Web implementation using dart:html and dart:ui_web
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'dart:ui_web' as ui_web;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

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
  final VoidCallback? onJwtRefreshNeeded;

  @override
  State<JaasMeetingViewPlatform> createState() =>
      _JaasMeetingViewPlatformState();
}

class _JaasMeetingViewPlatformState extends State<JaasMeetingViewPlatform> {
  late final String _viewType;

  html.IFrameElement? _iframe;
  bool _iframeLoaded = false;

  html.EventListener? _beforeUnloadListener;
  html.EventListener? _messageListener;
  StreamSubscription<html.PopStateEvent>? _popStateSub;
  StreamSubscription<html.Event>? _hashChangeSub;

  late String _iframeDomId;
  late String _roomKey;

  // Reconexão automática
  bool _disposed = false;
  bool _intentionalLeave = false;
  int _reconnectCount = 0;
  Timer? _reconnectTimer;
  static const int _maxReconnectAttempts = 10;

  // Delay antes de forçar reconexão (dá tempo pro Jitsi ICE restart)
  Timer? _reconnectDelayTimer;

  // Renovação automática do JWT antes de expirar
  Timer? _jwtRefreshTimer;

  // Listener de visibilidade da aba
  html.EventListener? _visibilityListener;

  // Listener de reconexão automática quando internet volta
  html.EventListener? _onlineListener;

  @override
  void initState() {
    super.initState();

    _syncRoomKeys();
    _cleanupOrphanIframesForThisRoom(skip: null);

    _viewType = 'jaas-iframe-${DateTime.now().microsecondsSinceEpoch}';
    _iframe = _buildIFrame(_buildSrc());

    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int _) => _iframe!,
    );

    _beforeUnloadListener = (event) {
      (event as html.BeforeUnloadEvent).returnValue =
          'Você está em uma aula ao vivo. Deseja realmente sair?';
    };
    html.window.addEventListener('beforeunload', _beforeUnloadListener!);

    // Escuta eventos postMessage do iframe JaaS para detectar desconexões
    _messageListener = (event) => _onJaasMessage(event);
    html.window.addEventListener('message', _messageListener!);

    // Detecta quando a aba volta ao foreground para resetar reconexão
    _visibilityListener = (_) {
      if (_disposed || _intentionalLeave) return;
      if (html.document.visibilityState == 'visible') {
        _reconnectCount = 0;
      }
    };
    html.document.addEventListener('visibilitychange', _visibilityListener!);

    // Quando internet volta, apenas reseta o contador.
    // NÃO recarrega o iframe — o Jitsi tenta ICE restart automaticamente.
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
  }

  void _syncRoomKeys() {
    _roomKey = '${widget.appId}__${widget.roomShort}';
    _iframeDomId = 'jaas_iframe_${_roomKey}';
  }

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

  /// Processa mensagens postMessage vindas do iframe JaaS/Jitsi.
  /// O Jitsi envia eventos como videoConferenceLeft, readyToClose, etc.
  void _onJaasMessage(html.Event rawEvent) {
    if (_disposed || _intentionalLeave) return;

    try {
      final event = rawEvent as html.MessageEvent;

      // Aceitar apenas mensagens da origem 8x8.vc
      final origin = event.origin;
      if (origin == null || !origin.contains('8x8.vc')) return;

      // Tentar decodificar os dados da mensagem
      dynamic data = event.data;
      if (data is String) {
        try {
          data = json.decode(data);
        } catch (_) {
          return;
        }
      }

      if (data is! Map) return;

      final eventName = data['event'] ?? data['type'] ?? '';

      if (eventName == 'video-conference-left' ||
          eventName == 'videoConferenceLeft' ||
          eventName == 'conference-terminated' ||
          eventName == 'readyToClose') {
        // Dar 15s para o Jitsi tentar ICE restart interno antes de forçar reconexão
        _reconnectDelayTimer?.cancel();
        _reconnectDelayTimer = Timer(const Duration(seconds: 15), () {
          if (_disposed || _intentionalLeave) return;
          _attemptReconnect();
        });
      }

      // Jitsi se recuperou sozinho (ICE restart funcionou) — cancelar reconexão forçada
      if (eventName == 'video-conference-joined' ||
          eventName == 'videoConferenceJoined') {
        _reconnectCount = 0;
        _reconnectDelayTimer?.cancel();
      }
    } catch (_) {}
  }

  /// Tenta reconectar ao JaaS após desconexão não intencional.
  /// Usa backoff progressivo: 2s, 4s, 6s, 8s, 10s.
  /// Máximo de 5 tentativas.
  void _attemptReconnect() {
    if (_disposed || _intentionalLeave) return;
    if (_reconnectCount >= _maxReconnectAttempts) return;
    if (_iframe == null || widget.jwt.isEmpty) return;

    _reconnectCount++;
    final delaySec = _reconnectCount * 2;

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: delaySec), () {
      if (_disposed || _intentionalLeave) return;
      if (_iframe == null) return;

      // Recarrega o iframe com a mesma URL
      try {
        _iframe!.src = _buildSrc();
      } catch (_) {}
    });
  }

  @override
  void didUpdateWidget(covariant JaasMeetingViewPlatform oldWidget) {
    super.didUpdateWidget(oldWidget);

    final roomChanged = oldWidget.appId != widget.appId ||
        oldWidget.roomShort != widget.roomShort;

    final jwtBecameAvailable =
        oldWidget.jwt.isEmpty && widget.jwt.isNotEmpty && !_iframeLoaded;

    if (roomChanged) {
      _syncRoomKeys();
      _cleanupOrphanIframesForThisRoom(skip: _iframe);
      _iframeLoaded = false;
      _reconnectCount = 0;

      if (_iframe != null) {
        _iframe!
          ..id = _iframeDomId
          ..setAttribute('data-room', _roomKey);
      }
    }

    if ((roomChanged || jwtBecameAvailable) && _iframe != null) {
      _iframe!.src = _buildSrc();
      _iframeLoaded = true;
    }

    // JWT foi renovado com um token diferente (refresh antes de expirar).
    // NÃO recarrega o iframe — o JWT atual continua válido na sessão Jitsi.
    // O novo JWT será usado automaticamente em caso de reconexão futura.
    final jwtRefreshed = _iframeLoaded &&
        widget.jwt.isNotEmpty &&
        oldWidget.jwt.isNotEmpty &&
        oldWidget.jwt != widget.jwt;

    if (jwtRefreshed) {
      _reconnectCount = 0;
    }

    if ((jwtBecameAvailable || jwtRefreshed) && widget.jwt.isNotEmpty) {
      _scheduleJwtRefresh(widget.jwt);
    }
  }

  void _cleanupOrphanIframesForThisRoom({html.IFrameElement? skip}) {
    try {
      final existingById = html.document.getElementById(_iframeDomId);
      if (existingById is html.IFrameElement) {
        final sameAsCurrent = identical(existingById, skip);
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
          final sameAsCurrent = identical(n, skip);
          if (sameAsCurrent) continue;

          try {
            n.src = 'about:blank';
          } catch (_) {}
          n.remove();
        } else {
          n.remove();
        }
      }
    } catch (_) {}
  }

  void _leaveMeeting() {
    _intentionalLeave = true;
    _reconnectTimer?.cancel();
    _reconnectDelayTimer?.cancel();

    try {
      _cleanupOrphanIframesForThisRoom(skip: null);

      if (_iframe != null) {
        try {
          _iframe!.src = 'about:blank';
        } catch (_) {}
        try {
          _iframe!.remove();
        } catch (_) {}
        _iframe = null;
      }
    } catch (_) {}
  }

  html.IFrameElement _buildIFrame(String src) {
    final iframe = html.IFrameElement()
      ..id = _iframeDomId
      ..src = src
      ..style.border = '0'
      ..style.width = '100%'
      ..style.height = '100%'
      ..allow = 'camera; microphone; fullscreen; display-capture; autoplay'
      ..setAttribute('allowfullscreen', 'true')
      ..setAttribute(
        'sandbox',
        'allow-same-origin allow-scripts allow-forms '
            'allow-modals allow-popups allow-popups-to-escape-sandbox '
            'allow-presentation',
      )
      ..referrerPolicy = 'no-referrer-when-downgrade'
      ..setAttribute('data-jaas', 'true')
      ..setAttribute('data-room', _roomKey);

    return iframe;
  }

  String _buildSrc() {
    final uri = Uri(
      scheme: 'https',
      host: '8x8.vc',
      path: '${widget.appId}/${widget.roomShort}',
      queryParameters: <String, String>{'jwt': widget.jwt},
      fragment: _buildFragment(),
    );
    return uri.toString();
  }

  String _buildFragment() {
    final params = <String, String>{
      // Sempre mostra tela de seleção de mic/câmera antes de entrar
      'config.prejoinPageEnabled': 'true',
      'config.startWithAudioMuted': widget.audioMuted ? 'true' : 'false',
      'config.startWithVideoMuted': widget.videoMuted ? 'true' : 'false',
      'config.defaultLanguage': widget.lang,
      'config.toolbarConfig.alwaysVisible': 'true',
      'config.toolbarConfig.autoHideTimeout': '0',

      // ── Rede & Conexão ──
      // Desabilita P2P — JVB relay é mais confiável no JaaS
      'config.p2p.enabled': 'false',
      // ICE restart automático em caso de queda de conexão
      'config.enableIceRestart': 'true',
      // WebSocket é mais confiável que DataChannel para o bridge
      'config.openBridgeChannel': 'websocket',

      // ── Áudio — processamento robusto sem redução involuntária ──
      // Detecta quando não há áudio sendo transmitido (aviso útil)
      'config.enableNoAudioDetection': 'true',
      // Desabilitado: reduzia ganho do mic ao detectar ruído ambiente
      'config.enableNoisyMicDetection': 'false',
      // AGC ativo: faz boost de mics baixos automaticamente
      'config.disableAGC': 'false',
      // Codec Opus otimizado: bitrate alto para voz clara
      'config.audioQuality.opusMaxAverageBitrate': '32000',

      // ── Vídeo — degradação suave como o Meet ──
      // Resolução ideal 720p, mínimo 180p em rede ruim
      'config.resolution': '720',
      'config.constraints.video.height.ideal': '720',
      'config.constraints.video.height.max': '720',
      'config.constraints.video.height.min': '180',
      // Simulcast: envia múltiplas qualidades, servidor escolhe a melhor
      'config.enableSimulcast': 'true',
      // Suspende camadas de vídeo não assistidas (economiza banda)
      'config.enableLayerSuspension': 'true',
      // Limita streams de vídeo recebidos
      'config.channelLastN': '4',
      // Bitrate inicial baixo — sobe conforme rede permite (como o Meet)
      'config.startBitrate': '800',
      // Adaptação automática de qualidade baseada na largura de banda
      'config.enableAdaptiveVideoQuality': 'true',

      // ── Compatibilidade cross-browser (Edge, Firefox) ──
      // VP8 é o codec mais compatível entre navegadores
      'config.preferredCodec': 'VP8',
      // Unified Plan SDP para compatibilidade com Edge
      'config.enableUnifiedOnChrome': 'true',

      if (widget.displayName.isNotEmpty)
        'userInfo.displayName': widget.displayName,
      if (widget.email.isNotEmpty) 'userInfo.email': widget.email,
    };

    return params.entries
        .map((e) =>
            '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
  }

  @override
  void dispose() {
    _disposed = true;
    _reconnectTimer?.cancel();
    _reconnectDelayTimer?.cancel();
    _jwtRefreshTimer?.cancel();

    if (_beforeUnloadListener != null) {
      html.window
          .removeEventListener('beforeunload', _beforeUnloadListener!);
    }
    if (_messageListener != null) {
      html.window.removeEventListener('message', _messageListener!);
    }

    _popStateSub?.cancel();
    _hashChangeSub?.cancel();

    if (_visibilityListener != null) {
      html.document.removeEventListener('visibilitychange', _visibilityListener!);
    }
    if (_onlineListener != null) {
      html.window.removeEventListener('online', _onlineListener!);
    }

    _leaveMeeting();

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
