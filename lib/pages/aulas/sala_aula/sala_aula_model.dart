import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'sala_aula_widget.dart' show SalaAulaWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SalaAulaModel extends FlutterFlowModel<SalaAulaWidget> {
  ///  State fields for stateful widgets in this page.

  Stream<List<AulasRow>>? salaAulaSupabaseStream;
  // Stores action output result for [Backend Call - Query Rows] action in SalaAula widget.
  List<UsersRow>? userlog;
  // Stores action output result for [Backend Call - Query Rows] action in SalaAula widget.
  List<AulasRow>? aulatual;
  // Stores action output result for [Backend Call - API (SalaJitsi)] action in SalaAula widget.
  ApiCallResponse? apiResulti7f;
  // Model for Sidebar component.
  late SidebarModel sidebarModel;
  // Model for Sidebar component (drawer).
  late SidebarModel drawerSidebarModel;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;

  @override
  void initState(BuildContext context) {
    sidebarModel = createModel(context, () => SidebarModel());
    drawerSidebarModel = createModel(context, () => SidebarModel());
  }

  @override
  void dispose() {
    sidebarModel.dispose();
    drawerSidebarModel.dispose();
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}
