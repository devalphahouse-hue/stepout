import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/empty_list/empty_list_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'nova_conversa_widget.dart' show NovaConversaWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NovaConversaModel extends FlutterFlowModel<NovaConversaWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (BuscarChat)] action in Button widget.
  ApiCallResponse? apiResultclt;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  ChatsRow? criarchat;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
