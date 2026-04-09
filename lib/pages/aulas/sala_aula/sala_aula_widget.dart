import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'sala_aula_model.dart';
export 'sala_aula_model.dart';

class SalaAulaWidget extends StatefulWidget {
  const SalaAulaWidget({
    super.key,
    required this.aulaId,
  });

  final String? aulaId;

  static String routeName = 'SalaAula';
  static String routePath = '/salaAula';

  @override
  State<SalaAulaWidget> createState() => _SalaAulaWidgetState();
}

class _SalaAulaWidgetState extends State<SalaAulaWidget> {
  late SalaAulaModel _model;
  String _jwtFixo = '';

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _jaasMeetingKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SalaAulaModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.userlog = await UsersTable().queryRows(
        queryFn: (q) => q.eqOrNull(
          'id',
          currentUserUid,
        ),
      );
      _model.aulatual = await AulasTable().queryRows(
        queryFn: (q) => q.eqOrNull(
          'id',
          widget!.aulaId,
        ),
      );
      _model.apiResulti7f = await SalaJitsiCall.call(
        sala: _model.aulatual?.firstOrNull?.id,
        role: _model.userlog?.firstOrNull?.role,
        token: currentJwtToken,
      );

      if ((_model.apiResulti7f?.succeeded ?? true)) {
        _jwtFixo = SalaJitsiCall.tokenjwt(
          (_model.apiResulti7f?.jsonBody ?? ''),
        )!;
        FFAppState().jaasJWT = _jwtFixo;
        safeSetState(() {});
      }
    });

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure the stream is initialized (cached with ??= so it's safe to use in multiple StreamBuilders)
    _model.salaAulaSupabaseStream ??= SupaFlow.client
        .from("Aulas")
        .stream(primaryKey: ['id'])
        .eqOrNull(
          'id',
          widget!.aulaId,
        )
        .map((list) => list.map((item) => AulasRow(item)).toList());

    return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
            floatingActionButton: responsiveVisibility(
              context: context,
              tabletLandscape: false,
              desktop: false,
            )
                ? PointerInterceptor(
                    child: FloatingActionButton(
                    backgroundColor: FlutterFlowTheme.of(context).primary,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        enableDrag: false,
                        backgroundColor: Colors.transparent,
                        builder: (bottomSheetContext) {
                          return StreamBuilder<List<AulasRow>>(
                          stream: _model.salaAulaSupabaseStream,
                          builder: (context, snapshot) {
                            List<AulasRow> salaAulaAulasRowList = snapshot.data ?? [];
                            final salaAulaAulasRow = salaAulaAulasRowList.isNotEmpty
                                ? salaAulaAulasRowList.first
                                : null;

                            // Atualiza o controller do mural mobile com o valor em tempo real do stream
                            final _muralText = salaAulaAulasRow?.muralAula ?? '';
                            if (_model.textController2 != null &&
                                _model.textController2!.text != _muralText) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (_model.textController2 != null &&
                                    _model.textController2!.text != _muralText) {
                                  _model.textController2!.text = _muralText;
                                }
                              });
                            }

                            return PointerInterceptor(
                          child: Container(
                            height: MediaQuery.sizeOf(context).height * 0.55,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primaryBackground,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.0),
                                topRight: Radius.circular(16.0),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Botão fechar
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Informações da Aula',
                                          style: FlutterFlowTheme.of(context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        InkWell(
                                          onTap: () => Navigator.of(bottomSheetContext).pop(),
                                          child: Container(
                                            width: 32.0,
                                            height: 32.0,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).alternate,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.close,
                                              color: FlutterFlowTheme.of(context).primaryText,
                                              size: 18.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16.0),
                                    // Conteúdos vinculados
                                    Text(
                                      'Conteúdos vinculados',
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Builder(
                                      builder: (context) {
                                        final listaConteudos =
                                            salaAulaAulasRow?.conteudosVinculados?.toList() ?? [];
                                        return ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: listaConteudos.length,
                                          itemBuilder: (context, index) {
                                            final conteudoId = listaConteudos[index];
                                            return FutureBuilder<List<ConteudosRow>>(
                                              future: ConteudosTable().querySingleRow(
                                                queryFn: (q) => q.eqOrNull('id', conteudoId),
                                              ),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 4.0),
                                                    child: SizedBox(
                                                      height: 20.0,
                                                      width: 20.0,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2.0,
                                                        valueColor: AlwaysStoppedAnimation<Color>(
                                                          FlutterFlowTheme.of(context).primary,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                                final row = snapshot.data!.isNotEmpty
                                                    ? snapshot.data!.first
                                                    : null;
                                                return Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 4.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          '- ${row?.nomeConteudo ?? ''}',
                                                          style: FlutterFlowTheme.of(context)
                                                              .bodyMedium,
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          if (row?.linkConteudo != null) {
                                                            await launchURL(row!.linkConteudo!);
                                                          }
                                                        },
                                                        child: Icon(
                                                          Icons.remove_red_eye_outlined,
                                                          color: FlutterFlowTheme.of(context)
                                                              .primaryText,
                                                          size: 22.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    SizedBox(height: 16.0),
                                    // Mural
                                    Container(
                                      width: double.infinity,
                                      child: TextFormField(
                                        controller: _model.textController2,
                                        focusNode: _model.textFieldFocusNode2,
                                        autofocus: false,
                                        readOnly: true,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          labelText: 'Mural',
                                          labelStyle: FlutterFlowTheme.of(context).labelMedium,
                                          hintText: 'Mural da Aula',
                                          hintStyle: FlutterFlowTheme.of(context).labelMedium,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).alternate,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).error,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).error,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          filled: true,
                                          fillColor:
                                              FlutterFlowTheme.of(context).primaryBackground,
                                        ),
                                        style: FlutterFlowTheme.of(context).bodyMedium,
                                        maxLines: 6,
                                        minLines: 3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          );
                          },
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.article_outlined,
                      color: FlutterFlowTheme.of(context).info,
                      size: 24.0,
                    ),
                  ),
                )
                : null,
            drawer: Drawer(
              elevation: 16.0,
              child: PointerInterceptor(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 1.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * 1.0,
                    constraints: BoxConstraints(
                      maxWidth: 300.0,
                    ),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      boxShadow: [
                        BoxShadow(
                          color: FlutterFlowTheme.of(context).alternate,
                          offset: Offset(
                            1.0,
                            0.0,
                          ),
                        )
                      ],
                    ),
                    child: wrapWithModel(
                      model: _model.drawerSidebarModel,
                      updateCallback: () => safeSetState(() {}),
                      child: SidebarWidget(
                        route: 'Aula',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: SafeArea(
              child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (responsiveVisibility(
                  context: context,
                  tablet: false,
                  tabletLandscape: false,
                  desktop: false,
                ))
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                    child: FlutterFlowIconButton(
                      borderRadius: 8.0,
                      buttonSize: 40.0,
                      fillColor: FlutterFlowTheme.of(context).primary,
                      icon: Icon(
                        Icons.menu_open,
                        color: FlutterFlowTheme.of(context).info,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        scaffoldKey.currentState!.openDrawer();
                      },
                    ),
                  ),
                Expanded(
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (responsiveVisibility(
                          context: context,
                          phone: false,
                          tablet: false,
                          tabletLandscape: false,
                        ))
                          wrapWithModel(
                            model: _model.sidebarModel,
                            updateCallback: () => safeSetState(() {}),
                            child: SidebarWidget(
                              route: 'Aula',
                            ),
                          ),
                        Expanded(
                          child: Stack(
                            children: [
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return custom_widgets.JaasMeetingView(
                                    key: _jaasMeetingKey,
                                    width: constraints.maxWidth,
                                    height: constraints.maxHeight,
                                    appId:
                                        'vpaas-magic-cookie-621aa69dceea45c4b411c688b616a9bb',
                                    roomShort: widget!.aulaId!,
                                    jwt: _jwtFixo,
                                    displayName:
                                        _model.userlog!.firstOrNull!.nome!,
                                    email: currentUserEmail,
                                    audioMuted: false,
                                    videoMuted: false,
                                    prejoin: true,
                                    lang: 'ptBR',
                                    enableSpaNavigationListeners: false,
                                    onJwtRefreshNeeded: () async {
                                      final result = await SalaJitsiCall.call(
                                        sala: widget!.aulaId,
                                        role: _model.userlog?.firstOrNull?.role,
                                        token: currentJwtToken,
                                      );
                                      if (result.succeeded) {
                                        final newJwt = SalaJitsiCall.tokenjwt(
                                          result.jsonBody ?? '',
                                        );
                                        if (newJwt != null && newJwt.isNotEmpty) {
                                          _jwtFixo = newJwt;
                                          FFAppState().jaasJWT = _jwtFixo;
                                          safeSetState(() {});
                                        }
                                      }
                                    },
                                  );
                                },
                              ),
                              Positioned(
                                top: 8.0,
                                right: 8.0,
                                child: PointerInterceptor(
                                  child: custom_widgets.NetworkStatusIndicator(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (responsiveVisibility(
                          context: context,
                          phone: false,
                          tablet: false,
                        ))
                          StreamBuilder<List<AulasRow>>(
                            stream: _model.salaAulaSupabaseStream,
                            builder: (context, snapshot) {
                              List<AulasRow> salaAulaAulasRowList = snapshot.data ?? [];
                              final salaAulaAulasRow = salaAulaAulasRowList.isNotEmpty
                                  ? salaAulaAulasRowList.first
                                  : null;

                              // Atualiza os controllers do mural com o valor em tempo real do stream
                              final _muralText = salaAulaAulasRow?.muralAula ?? '';
                              if (_model.textController1 != null &&
                                  _model.textController1!.text != _muralText) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  if (_model.textController1 != null &&
                                      _model.textController1!.text != _muralText) {
                                    _model.textController1!.text = _muralText;
                                  }
                                });
                              }

                              return Container(
                            width: 250.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Material(
                                          color: Colors.transparent,
                                          elevation: 2.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            constraints: BoxConstraints(
                                                minHeight: 200.0),
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Conteúdos vinculados',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                      SingleChildScrollView(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Builder(
                                                              builder:
                                                                  (context) {
                                                                final listaConteudos =
                                                                    salaAulaAulasRow
                                                                            ?.conteudosVinculados
                                                                            ?.toList() ??
                                                                        [];

                                                                return ListView
                                                                    .builder(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  shrinkWrap:
                                                                      true,
                                                                  physics:
                                                                      NeverScrollableScrollPhysics(),
                                                                  scrollDirection:
                                                                      Axis.vertical,
                                                                  itemCount:
                                                                      listaConteudos
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          listaConteudosIndex) {
                                                                    final listaConteudosItem =
                                                                        listaConteudos[
                                                                            listaConteudosIndex];
                                                                    return FutureBuilder<
                                                                        List<
                                                                            ConteudosRow>>(
                                                                      future: ConteudosTable()
                                                                          .querySingleRow(
                                                                        queryFn:
                                                                            (q) =>
                                                                                q.eqOrNull(
                                                                          'id',
                                                                          listaConteudosItem,
                                                                        ),
                                                                      ),
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        // Customize what your widget looks like when it's loading.
                                                                        if (!snapshot
                                                                            .hasData) {
                                                                          return Center(
                                                                            child:
                                                                                SizedBox(
                                                                              width: 50.0,
                                                                              height: 50.0,
                                                                              child: CircularProgressIndicator(
                                                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                                                  FlutterFlowTheme.of(context).primary,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }
                                                                        List<ConteudosRow>
                                                                            rowConteudosRowList =
                                                                            snapshot.data!;

                                                                        final rowConteudosRow = rowConteudosRowList.isNotEmpty
                                                                            ? rowConteudosRowList.first
                                                                            : null;

                                                                        return Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Flexible(
                                                                              child: Text(
                                                                                '- ${valueOrDefault<String>(
                                                                                  rowConteudosRow?.nomeConteudo,
                                                                                  'nomeConteudo',
                                                                                )}',
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      font: GoogleFonts.inter(
                                                                                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                      ),
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                            InkWell(
                                                                              splashColor: Colors.transparent,
                                                                              focusColor: Colors.transparent,
                                                                              hoverColor: Colors.transparent,
                                                                              highlightColor: Colors.transparent,
                                                                              onTap: () async {
                                                                                await launchURL(rowConteudosRow!.linkConteudo!);
                                                                              },
                                                                              child: Icon(
                                                                                Icons.remove_red_eye_outlined,
                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                size: 24.0,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ].divide(
                                                        SizedBox(height: 5.0)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Material(
                                          color: Colors.transparent,
                                          elevation: 2.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            constraints: BoxConstraints(
                                                minHeight: 200.0),
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    child: TextFormField(
                                                        controller: _model
                                                            .textController1,
                                                        focusNode: _model
                                                            .textFieldFocusNode1,
                                                        autofocus: false,
                                                        readOnly: true,
                                                        obscureText: false,
                                                        decoration:
                                                            InputDecoration(
                                                          isDense: true,
                                                          labelText: 'Mural',
                                                          labelStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .inter(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontStyle,
                                                                  ),
                                                          hintText:
                                                              'Mural da Aula',
                                                          hintStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .inter(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontStyle,
                                                                  ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .alternate,
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0x00000000),
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          errorBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .error,
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          focusedErrorBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .error,
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          filled: true,
                                                          fillColor: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                        maxLines: 6,
                                                        minLines: 6,
                                                        cursorColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        enableInteractiveSelection:
                                                            true,
                                                        validator: _model
                                                            .textController1Validator
                                                            .asValidator(
                                                                context),
                                                      ),
                                                    ),
                                                  ].divide(SizedBox(height: 5.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ].divide(SizedBox(height: 12.0)),
                                      ),
                                    ),
                                  ].divide(SizedBox(height: 12.0)),
                                ),
                              ),
                            );
                            },
                          ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          ),
          ),
        );
  }
}
