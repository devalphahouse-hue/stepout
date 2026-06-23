import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Implementação web do gate mobile.
/// Detecta se o acesso é via celular/tablet e, em vez de liberar a web
/// (experiência ruim no navegador mobile), convida o usuário a baixar o
/// aplicativo nativo nas lojas.
class MobileWebGatePlatform extends StatelessWidget {
  const MobileWebGatePlatform({super.key, required this.child});

  final Widget child;

  bool _isMobileOrTablet(BuildContext context) {
    // 1. Detectar por userAgent (mais confiável para dispositivos reais)
    final ua = html.window.navigator.userAgent.toLowerCase();
    final isMobileUA = ua.contains('mobile') ||
        ua.contains('android') ||
        ua.contains('iphone') ||
        ua.contains('ipad') ||
        ua.contains('ipod') ||
        ua.contains('webos') ||
        ua.contains('blackberry') ||
        ua.contains('opera mini') ||
        ua.contains('opera mobi') ||
        ua.contains('windows phone');

    if (isMobileUA) return true;

    // 2. Detectar tablets que não reportam "mobile" no UA (ex: iPad com Safari desktop mode)
    // Verificar maxTouchPoints > 1 indica tela touch (tablet/celular)
    final maxTouch = html.window.navigator.maxTouchPoints ?? 0;
    final isTouchDevice = maxTouch > 1;

    // Se tem touch E a tela é menor que desktop, é tablet/celular
    final width = MediaQuery.sizeOf(context).width;
    if (isTouchDevice && width < 992) return true;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isMobileOrTablet(context)) return child;

    // Overlay fullscreen convidando para baixar o app
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MobileWebGateDownloadScreen(),
    );
  }
}

/// Tela de convite para baixar o app nativo (mostrada na web em celular/tablet).
/// Pública para permitir preview isolado em desenvolvimento.
class MobileWebGateDownloadScreen extends StatelessWidget {
  const MobileWebGateDownloadScreen({super.key});

  // URLs das lojas (app aluno)
  static const String _appStoreUrl =
      'https://apps.apple.com/us/app/stepout-aluno/id6771817851';
  static const String _playStoreUrl =
      'https://play.google.com/store/apps/details?id=br.com.stepout.aluno.app';

  void _openStore(String url) {
    html.window.open(url, '_blank');
  }

  // Cores da marca STEP OUT
  static const Color _brandTeal = Color(0xFF0C5854);
  static const Color _brandTealDark = Color(0xFF063C39);
  static const Color _brandOrange = Color(0xFFF68F05);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_brandTeal, _brandTealDark],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 36),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white.withOpacity(0.10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo STEP OUT
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _brandOrange.withOpacity(0.30),
                              blurRadius: 28,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/Logo.png',
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Título
                      const Text(
                        'Baixe o app STEP OUT\nno seu celular',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          height: 1.25,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Acento laranja
                      Container(
                        width: 52,
                        height: 4,
                        decoration: BoxDecoration(
                          color: _brandOrange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Texto explicativo
                      Text(
                        'Para a melhor experiência nas aulas ao vivo pelo '
                        'celular, baixe o aplicativo STEP OUT Aluno na sua loja.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          height: 1.5,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Badges das lojas
                      _StoreBadge(
                        icon: FontAwesomeIcons.apple,
                        topLabel: 'Baixar na',
                        bottomLabel: 'App Store',
                        onTap: () => _openStore(_appStoreUrl),
                      ),
                      const SizedBox(height: 14),
                      _StoreBadge(
                        icon: FontAwesomeIcons.googlePlay,
                        topLabel: 'Disponível no',
                        bottomLabel: 'Google Play',
                        onTap: () => _openStore(_playStoreUrl),
                      ),
                      const SizedBox(height: 24),

                      // Rodapé: alternativa no navegador
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.laptop_mac_rounded,
                            color: Colors.white.withOpacity(0.55),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Prefere o navegador? Use o computador com o Chrome.',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.55),
                                fontSize: 12.5,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Wrapper visual da tela de download (Scaffold).
/// Botão no estilo dos badges oficiais das lojas (preto, arredondado,
/// com o logo da loja + duas linhas de texto). Clicável.
class _StoreBadge extends StatelessWidget {
  const _StoreBadge({
    required this.icon,
    required this.topLabel,
    required this.bottomLabel,
    required this.onTap,
  });

  final IconData icon;
  final String topLabel;
  final String bottomLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      borderRadius: BorderRadius.circular(14),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.18)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(icon, color: Colors.white, size: 32),
              const SizedBox(width: 14),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topLabel,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 0.3,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    bottomLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
