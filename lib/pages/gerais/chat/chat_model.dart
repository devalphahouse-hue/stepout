import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/empty_list/empty_list_widget.dart';
import '/componentes/nova_conversa/nova_conversa_widget.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/componentes/sidebar_slim/sidebar_slim_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'chat_widget.dart' show ChatWidget;
import 'dart:async';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatModel extends FlutterFlowModel<ChatWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Sidebar component.
  late SidebarModel sidebarModel;
  // Model for SidebarSlim component.
  late SidebarSlimModel sidebarSlimModel;
  Stream<List<MensagensChatsRow>>? columnSupabaseStream1;
  // State field(s) for tfMobile widget.
  FocusNode? tfMobileFocusNode1;
  TextEditingController? tfMobileTextController1;
  String? Function(BuildContext, String?)? tfMobileTextController1Validator;
  // Stores action output result for [Backend Call - Insert Row] action in tfMobile widget.
  MensagensChatsRow? insertMessageCopy;
  Completer<ApiCallResponse>? apiRequestCompleter;
  // Stores action output result for [Backend Call - Insert Row] action in IconButton widget.
  MensagensChatsRow? insertMessage;
  Stream<List<MensagensChatsRow>>? columnSupabaseStream2;
  // State field(s) for tfMobile widget.
  FocusNode? tfMobileFocusNode2;
  TextEditingController? tfMobileTextController2;
  String? Function(BuildContext, String?)? tfMobileTextController2Validator;
  // Stores action output result for [Backend Call - Insert Row] action in tfMobile widget.
  MensagensChatsRow? insertMessage2;
  // Stores action output result for [Backend Call - Insert Row] action in IconButton widget.
  MensagensChatsRow? insertMessageCell;

  @override
  void initState(BuildContext context) {
    sidebarModel = createModel(context, () => SidebarModel());
    sidebarSlimModel = createModel(context, () => SidebarSlimModel());
  }

  @override
  void dispose() {
    sidebarModel.dispose();
    sidebarSlimModel.dispose();
    tfMobileFocusNode1?.dispose();
    tfMobileTextController1?.dispose();

    tfMobileFocusNode2?.dispose();
    tfMobileTextController2?.dispose();
  }

  /// Additional helper methods.
  Future waitForApiRequestCompleted({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = apiRequestCompleter?.isCompleted ?? false;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }
}
