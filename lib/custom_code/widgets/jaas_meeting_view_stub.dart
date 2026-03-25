// Mobile implementation using native Jitsi Meet SDK (with screen sharing support)
import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

class JaasMeetingViewPlatform extends StatefulWidget {
  const JaasMeetingViewPlatform({
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
  State<JaasMeetingViewPlatform> createState() =>
      _JaasMeetingViewPlatformState();
}

class _JaasMeetingViewPlatformState extends State<JaasMeetingViewPlatform> {
  final JitsiMeet _jitsiMeet = JitsiMeet();
  bool _joined = false;

  @override
  void initState() {
    super.initState();
    if (widget.jwt.isNotEmpty) {
      _joinMeeting();
    }
  }

  @override
  void didUpdateWidget(covariant JaasMeetingViewPlatform oldWidget) {
    super.didUpdateWidget(oldWidget);

    final jwtBecameAvailable =
        oldWidget.jwt.isEmpty && widget.jwt.isNotEmpty && !_joined;

    if (jwtBecameAvailable) {
      _joinMeeting();
    }
  }

  Future<void> _joinMeeting() async {
    if (_joined) return;
    _joined = true;

    final options = JitsiMeetConferenceOptions(
      serverURL: "https://8x8.vc",
      room: "${widget.appId}/${widget.roomShort}",
      token: widget.jwt,
      userInfo: JitsiMeetUserInfo(
        displayName: widget.displayName.isNotEmpty ? widget.displayName : null,
        email: widget.email.isNotEmpty ? widget.email : null,
      ),
      configOverrides: {
        "startWithAudioMuted": widget.audioMuted,
        "startWithVideoMuted": widget.videoMuted,
        "prejoinPageEnabled": widget.prejoin,
        "defaultLanguage": widget.lang,
      },
      featureFlags: {
        "unsaferoomwarning.enabled": false,
      },
    );

    final listener = JitsiMeetEventListener(
      conferenceTerminated: (url, error) {
        if (mounted) {
          setState(() => _joined = false);
          // Navigate back when the meeting ends
          Navigator.of(context).maybePop();
        }
      },
    );

    await _jitsiMeet.join(options, listener);
  }

  @override
  void dispose() {
    _jitsiMeet.hangUp();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.black,
      alignment: Alignment.center,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text(
            'Entrando na reunião...',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
