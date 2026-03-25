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

import 'jaas_meeting_view_stub.dart'
    if (dart.library.html) 'jaas_meeting_view_web.dart';

class JaasMeetingView extends StatelessWidget {
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
    this.enableSpaNavigationListeners = false,
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

  @override
  Widget build(BuildContext context) {
    return JaasMeetingViewPlatform(
      width: width,
      height: height,
      appId: appId,
      roomShort: roomShort,
      jwt: jwt,
      audioMuted: audioMuted,
      videoMuted: videoMuted,
      prejoin: prejoin,
      lang: lang,
      displayName: displayName,
      email: email,
      enableSpaNavigationListeners: enableSpaNavigationListeners,
    );
  }
}
