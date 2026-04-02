// Widget indicador de status de rede para videochamadas
// Mostra um badge visual com a qualidade da conexão (verde/amarelo/vermelho)
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:js_util' as js_util;

enum NetworkQuality { good, unstable, offline }

class NetworkStatusIndicator extends StatefulWidget {
  const NetworkStatusIndicator({super.key});

  @override
  State<NetworkStatusIndicator> createState() => _NetworkStatusIndicatorState();
}

class _NetworkStatusIndicatorState extends State<NetworkStatusIndicator> {
  NetworkQuality _quality = NetworkQuality.good;
  String _details = '';
  Timer? _pingTimer;
  html.EventListener? _onlineListener;
  html.EventListener? _offlineListener;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) return;

    _checkInitialStatus();

    _onlineListener = (_) {
      _updateStatus(online: true);
    };
    _offlineListener = (_) {
      _updateStatus(online: false);
    };
    html.window.addEventListener('online', _onlineListener!);
    html.window.addEventListener('offline', _offlineListener!);

    // Verifica qualidade da rede a cada 10 segundos
    _pingTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _measureConnection();
    });
  }

  void _checkInitialStatus() {
    final isOnline = html.window.navigator.onLine ?? true;
    _updateStatus(online: isOnline);
    if (isOnline) {
      _measureConnection();
    }
  }

  void _updateStatus({required bool online}) {
    if (!mounted) return;
    if (!online) {
      setState(() {
        _quality = NetworkQuality.offline;
        _details = 'Sem conexão com a internet';
      });
    } else if (_quality == NetworkQuality.offline) {
      setState(() {
        _quality = NetworkQuality.good;
        _details = 'Conexão restabelecida';
      });
      _measureConnection();
    }
  }

  void _measureConnection() {
    if (!kIsWeb || !mounted) return;

    try {
      // Network Information API (navigator.connection)
      final nav = html.window.navigator;
      final connection = js_util.getProperty(nav, 'connection') ??
          js_util.getProperty(nav, 'mozConnection') ??
          js_util.getProperty(nav, 'webkitConnection');

      if (connection != null) {
        final effectiveType =
            js_util.getProperty(connection, 'effectiveType') as String?;
        final downlink =
            (js_util.getProperty(connection, 'downlink') as num?)?.toDouble();
        final rtt =
            (js_util.getProperty(connection, 'rtt') as num?)?.toInt();

        NetworkQuality newQuality;
        String newDetails;

        if (effectiveType == '4g' && (rtt == null || rtt < 200)) {
          newQuality = NetworkQuality.good;
          newDetails = 'Conexão estável';
          if (downlink != null) {
            newDetails += ' (${downlink.toStringAsFixed(1)} Mbps)';
          }
          if (rtt != null) {
            newDetails += ' - Latência: ${rtt}ms';
          }
        } else if (effectiveType == '3g' ||
            (rtt != null && rtt >= 200 && rtt < 500)) {
          newQuality = NetworkQuality.unstable;
          newDetails = 'Conexão instável';
          if (rtt != null) newDetails += ' - Latência: ${rtt}ms';
          if (downlink != null) {
            newDetails += ' (${downlink.toStringAsFixed(1)} Mbps)';
          }
        } else if (effectiveType == '2g' ||
            effectiveType == 'slow-2g' ||
            (rtt != null && rtt >= 500)) {
          newQuality = NetworkQuality.unstable;
          newDetails = 'Conexão muito lenta';
          if (rtt != null) newDetails += ' - Latência: ${rtt}ms';
        } else {
          newQuality = NetworkQuality.good;
          newDetails = 'Conexão ativa';
        }

        if (mounted) {
          setState(() {
            _quality = newQuality;
            _details = newDetails;
          });
        }
        return;
      }
    } catch (_) {}

    // Fallback: se não tem Network Info API, usa apenas online/offline
    if (mounted) {
      final isOnline = html.window.navigator.onLine ?? true;
      setState(() {
        _quality = isOnline ? NetworkQuality.good : NetworkQuality.offline;
        _details = isOnline ? 'Conexão ativa' : 'Sem conexão';
      });
    }
  }

  @override
  void dispose() {
    _pingTimer?.cancel();
    if (kIsWeb) {
      if (_onlineListener != null) {
        html.window.removeEventListener('online', _onlineListener!);
      }
      if (_offlineListener != null) {
        html.window.removeEventListener('offline', _offlineListener!);
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return const SizedBox.shrink();

    final Color color;
    final IconData icon;
    final String label;

    switch (_quality) {
      case NetworkQuality.good:
        color = const Color(0xFF4CAF50); // verde
        icon = Icons.signal_wifi_4_bar;
        label = 'Boa';
      case NetworkQuality.unstable:
        color = const Color(0xFFFFC107); // amarelo
        icon = Icons.signal_wifi_statusbar_connected_no_internet_4;
        label = 'Instável';
      case NetworkQuality.offline:
        color = const Color(0xFFF44336); // vermelho
        icon = Icons.signal_wifi_off;
        label = 'Offline';
    }

    return Tooltip(
      message: _details,
      preferBelow: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16.0),
            const SizedBox(width: 6.0),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
