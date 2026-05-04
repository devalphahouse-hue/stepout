import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'nova_conversa_widget.dart' show NovaConversaWidget;
import 'package:flutter/material.dart';

class NovaConversaModel extends FlutterFlowModel<NovaConversaWidget> {
  // Stores action output result for [Backend Call - API (BuscarChat)] action in Button widget.
  ApiCallResponse? apiResultclt;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  ChatsRow? criarchat;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
