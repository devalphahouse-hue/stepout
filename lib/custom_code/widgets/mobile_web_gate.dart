import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

// Importação condicional: dart:html só disponível na web
import 'mobile_web_gate_stub.dart'
    if (dart.library.html) 'mobile_web_gate_web.dart';

/// Widget que bloqueia o acesso ao sistema quando acessado por celular/tablet na web.
/// Mostra um overlay fullscreen impedindo qualquer navegação.
class MobileWebGate extends StatelessWidget {
  const MobileWebGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return child;

    return MobileWebGatePlatform(child: child);
  }
}
