import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'termos_de_uso_model.dart';
export 'termos_de_uso_model.dart';

class TermosDeUsoWidget extends StatefulWidget {
  const TermosDeUsoWidget({super.key});

  static String routeName = 'TermosDeUso';
  static String routePath = '/termosDeUso';

  @override
  State<TermosDeUsoWidget> createState() => _TermosDeUsoWidgetState();
}

class _TermosDeUsoWidgetState extends State<TermosDeUsoWidget> {
  late TermosDeUsoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TermosDeUsoModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Center(
            child: Text(
              'Conteúdo em desenvolvimento',
              style: FlutterFlowTheme.of(context).bodyMedium,
            ),
          ),
        ),
      ),
    );
  }
}
