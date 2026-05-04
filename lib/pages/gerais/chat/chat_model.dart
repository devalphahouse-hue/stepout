import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'chat_widget.dart' show ChatWidget;

class ChatModel extends FlutterFlowModel<ChatWidget> {
  late SidebarModel sidebarModel;

  Stream<List<MensagensChatsRow>>? messagesStream;
  String? currentStreamChatId;

  final TextEditingController messageController = TextEditingController();
  final FocusNode messageFocusNode = FocusNode();

  final ScrollController messagesScrollController = ScrollController();

  bool sending = false;

  @override
  void initState(BuildContext context) {
    sidebarModel = createModel(context, () => SidebarModel());
  }

  @override
  void dispose() {
    sidebarModel.dispose();
    messageController.dispose();
    messageFocusNode.dispose();
    messagesScrollController.dispose();
  }
}
