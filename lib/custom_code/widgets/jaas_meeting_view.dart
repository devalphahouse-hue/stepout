// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;

// ✅ Flutter Web moderno
import 'dart:ui_web' as ui_web;

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class JaasMeetingView extends StatefulWidget {
  const JaasMeetingView({
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
    this.enableSpaNavigationListeners =
        false, // ✅ novo: liga/desliga popstate/hashchange
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

  /// ✅ Em muitos projetos FlutterFlow/Web, popstate/hashchange dispara por mudanças internas
  /// e isso pode derrubar a call sem você “sair”. Deixe false por padrão.
  final bool enableSpaNavigationListeners;

  @override
  State<JaasMeetingView> createState() => _JaasMeetingViewState();
}

class _JaasMeetingViewState extends State<JaasMeetingView> {
  late final String _viewType;

  html.IFrameElement? _iframe;

  // Listeners/subscriptions (Web)
  html.EventListener? _beforeUnloadListener;
  html.EventListener? _pageHideListener;
  StreamSubscription<html.PopStateEvent>? _popStateSub;
  StreamSubscription<html.Event>? _hashChangeSub;

  // ✅ IDs/atributos para limpeza de iframes “órfãos”
  late String _iframeDomId;
  late String _roomKey;

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) return;

    _syncRoomKeys();

    // ✅ remove qualquer iframe antigo da mesma sala (mas não há iframe atual ainda)
    _cleanupOrphanIframesForThisRoom(skip: null);

    // viewType pode continuar único (ok)
    _viewType = 'jaas-iframe-${DateTime.now().microsecondsSinceEpoch}';
    _iframe = _buildIFrame(_buildSrc());

    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int _) => _iframe!,
    );

    // ✅ Fechar aba / refresh
    _beforeUnloadListener = (event) => _leaveMeeting();
    html.window.addEventListener('beforeunload', _beforeUnloadListener!);

    // ✅ Em alguns browsers o pagehide dispara melhor que beforeunload
    _pageHideListener = (event) => _leaveMeeting();
    html.window.addEventListener('pagehide', _pageHideListener!);

    // ✅ Navegação SPA (OPCIONAL)
    if (widget.enableSpaNavigationListeners) {
      _popStateSub = html.window.onPopState.listen((_) => _leaveMeeting());
      _hashChangeSub = html.window.onHashChange.listen((_) => _leaveMeeting());
    }
  }

  void _syncRoomKeys() {
    _roomKey = '${widget.appId}__${widget.roomShort}';
    _iframeDomId = 'jaas_iframe_${_roomKey}';
  }

  @override
  void didUpdateWidget(covariant JaasMeetingView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!kIsWeb) return;

    final roomChanged = oldWidget.appId != widget.appId ||
        oldWidget.roomShort != widget.roomShort;

    // Só recarrega o iframe se a sala mudou ou se o JWT mudou de/para vazio
    // (primeira carga do token). Ignora mudanças em props cosméticas para
    // evitar que rebuilds do StreamBuilder destruam a videochamada.
    final jwtBecameAvailable =
        oldWidget.jwt.isEmpty && widget.jwt.isNotEmpty;
    final jwtWasCleared =
        oldWidget.jwt.isNotEmpty && widget.jwt.isEmpty;
    final jwtChanged = jwtBecameAvailable || jwtWasCleared;

    if (roomChanged) {
      _syncRoomKeys();
      _cleanupOrphanIframesForThisRoom(skip: _iframe);

      if (_iframe != null) {
        _iframe!
          ..id = _iframeDomId
          ..setAttribute('data-room', _roomKey);
      }
    }

    if ((roomChanged || jwtChanged) && _iframe != null) {
      _iframe!.src = _buildSrc();
    }
  }

  /// ✅ Remove iframes órfãos desta sala, mas NÃO remove o iframe atual (skip).
  void _cleanupOrphanIframesForThisRoom({html.IFrameElement? skip}) {
    try {
      // 1) remove por id estável (se não for o iframe atual)
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

      // 2) remove por data-atributos (se não for o iframe atual)
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

  /// ✅ Sai da reunião “de verdade”
  void _leaveMeeting() {
    if (!kIsWeb) return;

    try {
      // Remove qualquer iframe órfão desta sala (não precisa skip aqui)
      _cleanupOrphanIframesForThisRoom(skip: null);

      // Remove o iframe atual também
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
      'config.prejoinPageEnabled': widget.prejoin ? 'true' : 'false',
      'config.startWithAudioMuted': widget.audioMuted ? 'true' : 'false',
      'config.startWithVideoMuted': widget.videoMuted ? 'true' : 'false',
      'config.defaultLanguage': widget.lang,
      'config.toolbarConfig.alwaysVisible': 'true',
      'config.toolbarConfig.autoHideTimeout': '0',
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
    if (kIsWeb) {
      if (_beforeUnloadListener != null) {
        html.window.removeEventListener('beforeunload', _beforeUnloadListener!);
      }
      if (_pageHideListener != null) {
        html.window.removeEventListener('pagehide', _pageHideListener!);
      }

      _popStateSub?.cancel();
      _hashChangeSub?.cancel();

      _leaveMeeting();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.black,
        alignment: Alignment.center,
        child: const Text(
          'Este widget é apenas para Web (iframe).',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      );
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: HtmlElementView(viewType: _viewType),
    );
  }
}
