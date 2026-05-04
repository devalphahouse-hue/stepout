// Mobile stub: indicator is web-only, renders nothing on Android/iOS
import 'package:flutter/material.dart';

class NetworkStatusIndicatorPlatform extends StatelessWidget {
  const NetworkStatusIndicatorPlatform({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
