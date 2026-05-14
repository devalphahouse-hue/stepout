import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/componentes/sidebar_slim/sidebar_slim_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/detect_browser.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'calendario_aulas_lista_model.dart';
export 'calendario_aulas_lista_model.dart';

class CalendarioAulasListaWidget extends StatefulWidget {
  const CalendarioAulasListaWidget({
    super.key,
    this.route,
  });

  final String? route;

  static String routeName = 'CalendarioAulasLista';
  static String routePath = '/calendarioAulasLista';

  @override
  State<CalendarioAulasListaWidget> createState() =>
      _CalendarioAulasListaWidgetState();
}

enum _PeriodoFiltro { todas, hoje, estaSemana, proximaSemana, proximos30 }

class _CalendarioAulasListaWidgetState
    extends State<CalendarioAulasListaWidget> {
  late CalendarioAulasListaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  _PeriodoFiltro _periodo = _PeriodoFiltro.todas;

  static (DateTime, DateTime)? _intervalo(_PeriodoFiltro p) {
    final now = DateTime.now();
    final hoje = DateTime(now.year, now.month, now.day);
    switch (p) {
      case _PeriodoFiltro.todas:
        return null;
      case _PeriodoFiltro.hoje:
        return (hoje, hoje.add(const Duration(days: 1)));
      case _PeriodoFiltro.estaSemana:
        final inicio = hoje.subtract(Duration(days: hoje.weekday - 1));
        return (inicio, inicio.add(const Duration(days: 7)));
      case _PeriodoFiltro.proximaSemana:
        final inicioEstaSemana =
            hoje.subtract(Duration(days: hoje.weekday - 1));
        final inicio = inicioEstaSemana.add(const Duration(days: 7));
        return (inicio, inicio.add(const Duration(days: 7)));
      case _PeriodoFiltro.proximos30:
        return (hoje, hoje.add(const Duration(days: 30)));
    }
  }

  List<AulasRow> _filtrar(List<AulasRow> aulas) {
    final intervalo = _intervalo(_periodo);
    if (intervalo == null) return aulas;
    final (inicio, fim) = intervalo;
    return aulas.where((a) {
      final d = a.datetimeinicioAula;
      if (d == null) return false;
      return !d.isBefore(inicio) && d.isBefore(fim);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CalendarioAulasListaModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().dataParamentroCalendario = getCurrentTimestamp;
      safeSetState(() {});
      FFAppState().ListaDiasCalendarioAulas = functions
          .gerarLista7Dias(getCurrentTimestamp)!
          .toList()
          .cast<DiaCalendarioAulasStruct>();
      safeSetState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.secondaryBackground,
        drawer: Drawer(
          elevation: 0.0,
          width: 300.0,
          backgroundColor: theme.primaryBackground,
          child: SidebarWidget(route: 'Aulas'),
        ),
        body: SafeArea(
          top: true,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: SidebarWidget(route: 'Aulas'),
                ),
              if (responsiveVisibility(
                context: context,
                phone: false,
                desktop: false,
              ))
                wrapWithModel(
                  model: _model.sidebarSlimModel,
                  updateCallback: () => safeSetState(() {}),
                  child: SidebarSlimWidget(),
                ),
              Expanded(
                child: SingleChildScrollView(
                  primary: false,
                  child: Padding(
                    padding: EdgeInsets.all(responsivePadding(context)),
                    child: FutureBuilder<List<AulasRow>>(
                          future: SupaFlow.client
                              .from('Aulas')
                              .select('*, turmas!inner(deleted_at)')
                              .contains(
                                'alunos_convidados',
                                '{${currentUserUid}}',
                              )
                              .gte(
                                'datetimeinicio_aula',
                                supaSerialize<DateTime>(
                                    getCurrentTimestamp)!,
                              )
                              .filter('turmas.deleted_at', 'is', null)
                              .order('datetimeinicio_aula',
                                  ascending: true)
                              .then((rows) => rows
                                  .map((r) => AulasRow(
                                      Map<String, dynamic>.from(r)))
                                  .toList()),
                          builder: (context, snapshot) {
                            final hasError = snapshot.hasError;
                            final hasData = snapshot.hasData;
                            final aulasTodas =
                                hasData ? snapshot.data! : <AulasRow>[];
                            final aulas =
                                hasData ? _filtrar(aulasTodas) : <AulasRow>[];
                            final isCompact =
                                MediaQuery.sizeOf(context).width <
                                    kBreakpointSmall;

                            String subtitle;
                            if (hasError) {
                              subtitle =
                                  'Não foi possível carregar suas aulas';
                            } else if (!hasData) {
                              subtitle = 'Carregando suas aulas...';
                            } else if (aulasTodas.isEmpty) {
                              subtitle = 'Nenhuma aula agendada por enquanto';
                            } else if (aulas.length == 1) {
                              subtitle = '1 aula próxima';
                            } else {
                              subtitle =
                                  '${aulas.length} aulas próximas';
                            }

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Calendário de Aulas',
                                            style: theme.headlineMedium
                                                .override(
                                              font: GoogleFonts.interTight(
                                                fontWeight:
                                                    FontWeight.w700,
                                              ),
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.0,
                                            ),
                                          ),
                                          const SizedBox(height: 4.0),
                                          Text(
                                            subtitle,
                                            style: theme.bodyMedium.override(
                                              font: GoogleFonts.inter(),
                                              color: theme.secondaryText,
                                              letterSpacing: 0.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (responsiveVisibility(
                                      context: context,
                                      tablet: false,
                                      tabletLandscape: false,
                                      desktop: false,
                                    ))
                                      FlutterFlowIconButton(
                                        borderRadius: 8.0,
                                        buttonSize: 40.0,
                                        fillColor: theme.primary,
                                        icon: Icon(
                                          Icons.menu_open,
                                          color: theme.info,
                                          size: 24.0,
                                        ),
                                        onPressed: () async {
                                          scaffoldKey.currentState!
                                              .openDrawer();
                                        },
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 24.0),
                                if (hasError)
                                  _buildErrorState(context)
                                else if (!hasData)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 64.0),
                                    child: Center(
                                      child: SizedBox(
                                        width: 36.0,
                                        height: 36.0,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            theme.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                else if (aulasTodas.isEmpty)
                                  _buildEmptyState(context)
                                else ...[
                                  _PeriodoChips(
                                    theme: theme,
                                    selected: _periodo,
                                    onChanged: (p) =>
                                        setState(() => _periodo = p),
                                  ),
                                  const SizedBox(height: 16.0),
                                  if (aulas.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 24.0),
                                      child: Center(
                                        child: Text(
                                          'Nenhuma aula no período selecionado.',
                                          style: theme.bodyMedium.override(
                                            font: GoogleFonts.inter(),
                                            color: theme.secondaryText,
                                            letterSpacing: 0.0,
                                          ),
                                        ),
                                      ),
                                    )
                                  else
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        for (int i = 0;
                                            i < aulas.length;
                                            i++) ...[
                                          if (i > 0)
                                            const SizedBox(height: 12.0),
                                          _AulaCard(
                                            aula: aulas[i],
                                            isCompact: isCompact,
                                          ),
                                        ],
                                      ],
                                    ),
                                ],
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 56.0, horizontal: 16.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88.0,
              height: 88.0,
              decoration: BoxDecoration(
                color: theme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.event_available_rounded,
                color: theme.primary,
                size: 40.0,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Nenhuma aula agendada',
              style: theme.titleMedium.override(
                font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.0,
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              'Quando uma aula for marcada para você, ela aparecerá aqui.',
              textAlign: TextAlign.center,
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(),
                color: theme.secondaryText,
                letterSpacing: 0.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 56.0, horizontal: 16.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: theme.error,
              size: 36.0,
            ),
            const SizedBox(height: 12.0),
            Text(
              'Não foi possível carregar suas aulas.',
              textAlign: TextAlign.center,
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(),
                letterSpacing: 0.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AulaCard extends StatefulWidget {
  const _AulaCard({
    required this.aula,
    required this.isCompact,
  });

  final AulasRow aula;
  final bool isCompact;

  @override
  State<_AulaCard> createState() => _AulaCardState();
}

class _AulaCardState extends State<_AulaCard> {
  bool _hovered = false;
  bool _pressed = false;

  bool _canEnterAula(DateTime now, DateTime? start, DateTime? end) {
    if (start == null || end == null) return false;
    final fiveBefore = functions.inicioMenos5Min(start);
    if (fiveBefore == null) return false;
    return now.secondsSinceEpoch >= fiveBefore.secondsSinceEpoch &&
        now.secondsSinceEpoch <= end.secondsSinceEpoch;
  }

  String _statusLabel(DateTime now, DateTime start, DateTime end) {
    if (now.isAfter(start.subtract(const Duration(minutes: 5))) &&
        now.isBefore(end)) {
      return 'Ao vivo';
    }
    final diff = start.difference(now);
    if (diff.inDays >= 1) {
      return diff.inDays == 1 ? 'Amanhã' : 'Daqui ${diff.inDays} dias';
    }
    if (diff.inHours >= 1) {
      return 'Em ${diff.inHours}h';
    }
    if (diff.inMinutes > 0) {
      return 'Em ${diff.inMinutes}min';
    }
    return 'Em breve';
  }

  Future<void> _handleEnter() async {
    final confirmou = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final browserName = detectBrowser();
        final isChrome = browserName == 'chrome';
        bool aceitou = false;
        return StatefulBuilder(
          builder: (stfContext, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              title: Text(
                'Antes de entrar na aula',
                style:
                    FlutterFlowTheme.of(context).headlineSmall.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FontWeight.w600,
                          ),
                          letterSpacing: 0.0,
                        ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isChrome) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(8.0),
                          border:
                              Border.all(color: const Color(0xFFFCA5A5)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.warning_amber_rounded,
                              color: Color(0xFFDC2626),
                              size: 22,
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                'Você está usando ${browserDisplayName(browserName)}. Recomendamos fortemente o Google Chrome para evitar problemas de áudio e vídeo durante a aula.',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500),
                                      color: const Color(0xFFDC2626),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                    Text(
                      'Para garantir a melhor experiência na aula ao vivo, siga estas dicas:',
                      style: FlutterFlowTheme.of(context)
                          .bodyMedium
                          .override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.normal,
                            ),
                            letterSpacing: 0.0,
                          ),
                    ),
                    const SizedBox(height: 16.0),
                    _dicaItem(context, '1.',
                        'Use o Google Chrome — é o navegador mais compatível com a videochamada. Edge, Safari e Firefox podem causar problemas de áudio e travamentos'),
                    _dicaItem(context, '2.',
                        'Verifique sua internet — abra outro site para confirmar. Conexões instáveis causam travamento de vídeo e quedas de áudio'),
                    _dicaItem(context, '3.',
                        'Prefira cabo ou Wi-Fi forte — dados móveis (4G/5G) podem ser instáveis. Se estiver no Wi-Fi, fique próximo ao roteador'),
                    _dicaItem(context, '4.',
                        'Feche outros programas e abas — cada aba aberta consome memória e banda. Feche tudo que não for essencial'),
                    _dicaItem(context, '5.',
                        'Evite computador sobrecarregado — se seu PC estiver lento, reinicie-o antes da aula'),
                    _dicaItem(context, '6.',
                        'Teste câmera e microfone antes — ao entrar na aula, você verá uma tela para selecionar e testar seus dispositivos'),
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: aceitou,
                            activeColor:
                                FlutterFlowTheme.of(context).primary,
                            onChanged: (v) => setDialogState(
                                () => aceitou = v ?? false),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            'Li e entendi as recomendações',
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500),
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                FFButtonWidget(
                  onPressed: aceitou
                      ? () => Navigator.of(dialogContext).pop(true)
                      : null,
                  text: 'Confirmar e entrar',
                  options: FFButtonOptions(
                    height: 44.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        24.0, 0.0, 24.0, 0.0),
                    color: aceitou
                        ? FlutterFlowTheme.of(context).primary
                        : const Color(0xFFCCCCCC),
                    textStyle: FlutterFlowTheme.of(context)
                        .titleSmall
                        .override(
                          font: GoogleFonts.interTight(
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontWeight,
                          ),
                          color: Colors.white,
                          letterSpacing: 0.0,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmou != true || !mounted) return;

    FFAppState().jaasJWT = '';
    setState(() {});

    context.pushNamed(
      SalaAulaWidget.routeName,
      queryParameters: {
        'aulaId': serializeParam(widget.aula.id, ParamType.String),
      }.withoutNulls,
    );
  }

  static Widget _dicaItem(
      BuildContext context, String numero, String texto) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            numero,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  letterSpacing: 0.0,
                ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              texto,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.normal),
                    letterSpacing: 0.0,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final aula = widget.aula;
    final start = aula.datetimeinicioAula;
    final end = aula.datetimeTerminoaula;
    final now = getCurrentTimestamp;

    final canEnter = _canEnterAula(now, start, end);
    final isLive = canEnter;
    final statusLabel =
        (start != null && end != null) ? _statusLabel(now, start, end) : '';

    final scale = _pressed ? 0.99 : (_hovered ? 1.01 : 1.0);
    final shadowColor = isLive
        ? theme.primary.withOpacity(_hovered ? 0.28 : 0.18)
        : (_hovered ? const Color(0x18000000) : const Color(0x10000000));
    final borderColor = isLive
        ? theme.primary
        : (_hovered ? theme.primary.withOpacity(0.4) : theme.alternate);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        scale: scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: theme.primaryBackground,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: borderColor,
              width: isLive ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: _hovered ? 20.0 : 12.0,
                offset: Offset(0, _hovered ? 6.0 : 3.0),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isCompact ? 14.0 : 18.0,
            vertical: widget.isCompact ? 14.0 : 16.0,
          ),
          child: widget.isCompact
              ? _buildCompactLayout(context, theme, statusLabel, isLive)
              : _buildWideLayout(context, theme, statusLabel, isLive),
        ),
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context, FlutterFlowTheme theme,
      String statusLabel, bool isLive) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _DatePill(date: widget.aula.datetimeinicioAula, isHighlighted: isLive),
        const SizedBox(width: 18.0),
        Expanded(
          child: _buildInfoColumn(context, theme, statusLabel, isLive),
        ),
        if (isLive) ...[
          const SizedBox(width: 16.0),
          _buildAction(context, theme, isLive),
        ],
      ],
    );
  }

  Widget _buildCompactLayout(BuildContext context, FlutterFlowTheme theme,
      String statusLabel, bool isLive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _DatePill(
                date: widget.aula.datetimeinicioAula,
                isHighlighted: isLive),
            const SizedBox(width: 14.0),
            Expanded(
              child: _buildInfoColumn(context, theme, statusLabel, isLive),
            ),
          ],
        ),
        if (isLive) ...[
          const SizedBox(height: 14.0),
          SizedBox(
            width: double.infinity,
            child: _buildAction(context, theme, isLive),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoColumn(BuildContext context, FlutterFlowTheme theme,
      String statusLabel, bool isLive) {
    final aula = widget.aula;
    final start = aula.datetimeinicioAula;
    final end = aula.datetimeTerminoaula;
    final timeRange = (start != null && end != null)
        ? '${dateTimeFormat('Hm', start)} – ${dateTimeFormat('Hm', end)}'
        : '';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (statusLabel.isNotEmpty)
              _StatusBadge(label: statusLabel, isLive: isLive),
          ],
        ),
        if (statusLabel.isNotEmpty) const SizedBox(height: 8.0),
        FutureBuilder<List<TurmasRow>>(
          future: TurmasTable().queryRows(
            queryFn: (q) => q.eqOrNull('id', aula.turma),
          ),
          builder: (context, snapshot) {
            final nome = snapshot.data?.firstOrNull?.nomeDaTurma ??
                'Carregando...';
            return Text(
              nome,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.titleMedium.override(
                font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.0,
              ),
            );
          },
        ),
        const SizedBox(height: 4.0),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.schedule_rounded,
              size: 14.0,
              color: theme.secondaryText,
            ),
            const SizedBox(width: 4.0),
            Text(
              timeRange,
              style: theme.bodySmall.override(
                font: GoogleFonts.inter(),
                color: theme.secondaryText,
                letterSpacing: 0.0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAction(
      BuildContext context, FlutterFlowTheme theme, bool isLive) {
    return FFButtonWidget(
      onPressed: _handleEnter,
      text: 'Entrar na aula',
      icon: const Icon(
        Icons.videocam_rounded,
        size: 18.0,
        color: Colors.white,
      ),
      options: FFButtonOptions(
        height: 42.0,
        padding: const EdgeInsetsDirectional.fromSTEB(
            20.0, 0.0, 20.0, 0.0),
        iconPadding:
            const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 6.0, 0.0),
        color: theme.primary,
        textStyle: theme.titleSmall.override(
          font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
          color: Colors.white,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.0,
        ),
        elevation: 0.0,
        borderRadius: BorderRadius.circular(22.0),
      ),
    );
  }
}

class _DatePill extends StatelessWidget {
  const _DatePill({
    required this.date,
    required this.isHighlighted,
  });

  final DateTime? date;
  final bool isHighlighted;

  static const _months = [
    'JAN',
    'FEV',
    'MAR',
    'ABR',
    'MAI',
    'JUN',
    'JUL',
    'AGO',
    'SET',
    'OUT',
    'NOV',
    'DEZ',
  ];
  static const _weekdays = ['SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SÁB', 'DOM'];

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final d = date;
    final day = d != null ? d.day.toString().padLeft(2, '0') : '--';
    final month = d != null ? _months[d.month - 1] : '';
    final weekday = d != null ? _weekdays[d.weekday - 1] : '';

    final bg = isHighlighted ? theme.primary : theme.primary.withOpacity(0.08);
    final fg = isHighlighted ? Colors.white : theme.primary;
    final muted = isHighlighted
        ? Colors.white.withOpacity(0.85)
        : theme.primary.withOpacity(0.7);

    return Container(
      width: 64.0,
      height: 72.0,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            month,
            style: TextStyle(
              fontFamily: GoogleFonts.interTight().fontFamily,
              fontSize: 11.0,
              fontWeight: FontWeight.w700,
              color: muted,
              letterSpacing: 0.6,
            ),
          ),
          Text(
            day,
            style: TextStyle(
              fontFamily: GoogleFonts.interTight().fontFamily,
              fontSize: 24.0,
              fontWeight: FontWeight.w800,
              color: fg,
              height: 1.1,
              letterSpacing: 0.0,
            ),
          ),
          Text(
            weekday,
            style: TextStyle(
              fontFamily: GoogleFonts.inter().fontFamily,
              fontSize: 10.0,
              fontWeight: FontWeight.w600,
              color: muted,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.isLive,
  });

  final String label;
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final bg =
        isLive ? theme.primary : theme.primary.withOpacity(0.1);
    final fg = isLive ? Colors.white : theme.primary;

    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLive) ...[
            Container(
              width: 6.0,
              height: 6.0,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6.0),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: GoogleFonts.inter().fontFamily,
              fontSize: 11.0,
              fontWeight: FontWeight.w700,
              color: fg,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodoChips extends StatelessWidget {
  const _PeriodoChips({
    required this.theme,
    required this.selected,
    required this.onChanged,
  });

  final FlutterFlowTheme theme;
  final _PeriodoFiltro selected;
  final ValueChanged<_PeriodoFiltro> onChanged;

  static const _opcoes = <(_PeriodoFiltro, String)>[
    (_PeriodoFiltro.todas, 'Todas'),
    (_PeriodoFiltro.hoje, 'Hoje'),
    (_PeriodoFiltro.estaSemana, 'Esta semana'),
    (_PeriodoFiltro.proximaSemana, 'Próxima semana'),
    (_PeriodoFiltro.proximos30, 'Próximos 30 dias'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < _opcoes.length; i++) ...[
            if (i > 0) const SizedBox(width: 8.0),
            _PeriodoChip(
              theme: theme,
              label: _opcoes[i].$2,
              active: selected == _opcoes[i].$1,
              onTap: () => onChanged(_opcoes[i].$1),
            ),
          ],
        ],
      ),
    );
  }
}

class _PeriodoChip extends StatefulWidget {
  const _PeriodoChip({
    required this.theme,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final FlutterFlowTheme theme;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_PeriodoChip> createState() => _PeriodoChipState();
}

class _PeriodoChipState extends State<_PeriodoChip> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final active = widget.active;
    final bg = active
        ? theme.primary
        : (_hover
            ? theme.primary.withValues(alpha: 0.08)
            : theme.primaryBackground);
    final fg = active ? Colors.white : theme.primaryText;
    final borderColor = active ? theme.primary : theme.alternate;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          padding:
              const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999.0),
            border: Border.all(color: borderColor, width: 1.0),
          ),
          child: Text(
            widget.label,
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
              color: fg,
              letterSpacing: 0.0,
            ),
          ),
        ),
      ),
    );
  }
}
