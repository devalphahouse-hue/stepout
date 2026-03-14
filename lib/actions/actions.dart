import '/backend/api_requests/api_manager.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';

Future validacaoLoad(BuildContext context) async {
  List<FranquiasRow>? franquia;

  franquia = await FranquiasTable().queryRows(
    queryFn: (q) => q.eqOrNull(
      'id',
      FFAppState().idfranquia,
    ),
  );
  if (franquia?.firstOrNull?.statusFranquia == true) {
    return;
  }

  context.pushNamed(FranquiaInativaWidget.routeName);
}
