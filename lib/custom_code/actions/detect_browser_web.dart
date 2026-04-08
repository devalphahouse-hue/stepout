// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Detecta o browser via userAgent na web.
String detectBrowserPlatform() {
  try {
    final ua = html.window.navigator.userAgent.toLowerCase();
    if (ua.contains('edg/') || ua.contains('edga/') || ua.contains('edgios/')) return 'edge';
    if (ua.contains('firefox') || ua.contains('fxios')) return 'firefox';
    if (ua.contains('opr/') || ua.contains('opera')) return 'opera';
    if (ua.contains('safari') && !ua.contains('chrome')) return 'safari';
    if (ua.contains('chrome')) return 'chrome';
  } catch (_) {}
  return 'outro';
}
