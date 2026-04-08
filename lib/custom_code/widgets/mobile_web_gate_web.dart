import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Implementação web do gate mobile.
/// Detecta se o acesso é via celular/tablet e bloqueia com overlay fullscreen.
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

    // Overlay fullscreen bloqueante
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ícone de computador
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF16213E),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.desktop_windows_rounded,
                    size: 56,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 32),

                // Título
                const Text(
                  'Acesso disponível apenas pelo computador',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 16),

                // Texto explicativo
                const Text(
                  'Para a melhor experiência nas aulas ao vivo, acesse o sistema pelo computador usando o navegador Google Chrome.\n\n'
                  'Estamos trabalhando no aplicativo nativo e em breve estará disponível para celulares e tablets.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    height: 1.5,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 40),

                // Ícone do Chrome como sugestão
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.laptop_chromebook,
                      color: Colors.white38,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Recomendado: Google Chrome no computador',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
