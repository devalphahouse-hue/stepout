import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'franquia_inativa_model.dart';
export 'franquia_inativa_model.dart';

class FranquiaInativaWidget extends StatefulWidget {
  const FranquiaInativaWidget({super.key});

  static String routeName = 'FranquiaInativa';
  static String routePath = '/franquiaInativa';

  @override
  State<FranquiaInativaWidget> createState() => _FranquiaInativaWidgetState();
}

class _FranquiaInativaWidgetState extends State<FranquiaInativaWidget> {
  late FranquiaInativaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FranquiaInativaModel());

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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Center(
            child: Text(
              'Franquia inativa. Entre em contato com o suporte.',
              style: FlutterFlowTheme.of(context).bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
