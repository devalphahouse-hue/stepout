import 'package:flutter/material.dart';

/// Stub para plataformas não-web (mobile nativo). Nunca bloqueia.
class MobileWebGatePlatform extends StatelessWidget {
  const MobileWebGatePlatform({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
