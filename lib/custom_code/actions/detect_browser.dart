import 'detect_browser_stub.dart'
    if (dart.library.html) 'detect_browser_web.dart';

/// Retorna o nome do browser atual: 'chrome', 'edge', 'safari', 'firefox', 'opera', 'outro'.
/// Em plataformas não-web, retorna 'unknown'.
String detectBrowser() => detectBrowserPlatform();

/// Retorna o nome amigável do browser para exibição.
String browserDisplayName(String browser) {
  switch (browser) {
    case 'edge':
      return 'Microsoft Edge';
    case 'safari':
      return 'Safari';
    case 'firefox':
      return 'Firefox';
    case 'opera':
      return 'Opera';
    default:
      return 'um navegador diferente do Chrome';
  }
}
