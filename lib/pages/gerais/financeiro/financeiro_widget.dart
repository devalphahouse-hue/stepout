import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/components/modal_pagamento_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'financeiro_model.dart';
export 'financeiro_model.dart';

class FinanceiroWidget extends StatefulWidget {
  const FinanceiroWidget({super.key, this.route});

  final String? route;

  static String routeName = 'Financeiro';
  static String routePath = '/financeiro';

  @override
  State<FinanceiroWidget> createState() => _FinanceiroWidgetState();
}

class _FinanceiroWidgetState extends State<FinanceiroWidget> {
  late FinanceiroModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentPage = 1;
  int _perPage = 10;

  Future<void> _refreshPage() async {
    safeSetState(() {
      _model.clearFinanceiroCache();
      _model.apiRequestCompleted = false;
    });
    await _model.waitForApiRequestCompleted();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FinanceiroModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _runSearch() async {
    safeSetState(() {
      _currentPage = 1;
      _model.clearFinanceiroCache();
      _model.apiRequestCompleted = false;
    });
    await _model.waitForApiRequestCompleted();
  }

  Future<void> _clearSearch() async {
    safeSetState(() {
      _model.textController?.clear();
      _currentPage = 1;
      _model.clearFinanceiroCache();
      _model.apiRequestCompleted = false;
    });
    await _model.waitForApiRequestCompleted();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final theme = FlutterFlowTheme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= kBreakpointMedium;
    final isCompact = width < kBreakpointSmall;

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
          child: const SidebarWidget(route: 'Financeiro'),
        ),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isWide)
                const SizedBox(
                  width: 300.0,
                  child: SidebarWidget(route: 'Financeiro'),
                ),
              Expanded(
                child: SingleChildScrollView(
                  primary: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      responsivePadding(context),
                      responsivePadding(context),
                      responsivePadding(context),
                      responsivePadding(context) + 24.0,
                    ),
                    child: FutureBuilder<ApiCallResponse>(
                          future: _model.financeiro(
                            requestFn: () =>
                                SupabaseGroup.filtroCobrancaCall.call(
                              pTipoCobranca: 'aluno',
                              pSearch: _model.textController.text,
                              pUserId: currentUserUid,
                              pPage: _currentPage,
                              pPerPage: _perPage,
                              token: currentJwtToken,
                            ),
                          ).then((result) {
                            _model.apiRequestCompleted = true;
                            return result;
                          }),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return _buildHeader(
                                context: context,
                                isCompact: isCompact,
                                count: 0,
                                totalLabel: 'R\$ 0,00',
                                child: const _ErrorState(),
                              );
                            }
                            if (!snapshot.hasData) {
                              return _buildHeader(
                                context: context,
                                isCompact: isCompact,
                                count: null,
                                totalLabel: '—',
                                child: const _LoadingState(),
                              );
                            }

                            final body = snapshot.data!.jsonBody;
                            final data = (body is Map && body['data'] is List)
                                ? (body['data'] as List<dynamic>)
                                : <dynamic>[];
                            final totalCount = (body is Map
                                        ? (body['total'] as num?)
                                        : null)
                                    ?.toInt() ??
                                0;
                            final totalPages = (body is Map
                                        ? (body['totalPages'] as num?)
                                        : null)
                                    ?.toInt() ??
                                0;
                            final totalLabel = functions.formatCurrencyBr(
                                body is Map ? body['totalValor'] : 0);

                            return _buildHeader(
                              context: context,
                              isCompact: isCompact,
                              count: totalCount,
                              totalLabel: totalLabel,
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(height: 20.0),
                                  _SearchBar(
                                    controller: _model.textController!,
                                    focusNode: _model.textFieldFocusNode!,
                                    onSearch: _runSearch,
                                    onClear: _clearSearch,
                                  ),
                                  const SizedBox(height: 20.0),
                                  if (data.isEmpty)
                                    _EmptyState(
                                      hasFilter: _model
                                              .textController.text.isNotEmpty,
                                      onClearFilter: _clearSearch,
                                    )
                                  else
                                    _ChargesList(
                                      data: data,
                                      isWide: isWide,
                                    ),
                                  if (data.isNotEmpty) ...[
                                    const SizedBox(height: 16.0),
                                    _Pagination(
                                      currentPage: _currentPage,
                                      totalPages:
                                          totalPages == 0 ? 1 : totalPages,
                                      perPage: _perPage,
                                      onPrev: () async {
                                        if (_currentPage > 1) {
                                          safeSetState(
                                              () => _currentPage--);
                                          await _refreshPage();
                                        }
                                      },
                                      onNext: () async {
                                        if (_currentPage < totalPages) {
                                          safeSetState(
                                              () => _currentPage++);
                                          await _refreshPage();
                                        }
                                      },
                                      onPerPageChanged: (v) async {
                                        if (v == null) return;
                                        safeSetState(() {
                                          _perPage = v;
                                          _currentPage = 1;
                                        });
                                        await _refreshPage();
                                      },
                                    ),
                                  ],
                                ],
                              ),
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

  Widget _buildHeader({
    required BuildContext context,
    required bool isCompact,
    required int? count,
    required String totalLabel,
    required Widget child,
  }) {
    final theme = FlutterFlowTheme.of(context);
    final isWide = MediaQuery.sizeOf(context).width >= kBreakpointMedium;

    final titleBlock = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 56.0,
          height: 56.0,
          decoration: BoxDecoration(
            color: theme.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16.0),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.account_balance_wallet_rounded,
            color: theme.primary,
            size: 28.0,
          ),
        ),
        const SizedBox(width: 14.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Financeiro',
                style: theme.headlineSmall.override(
                  font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                  color: theme.primaryText,
                  letterSpacing: 0.0,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                count == null
                    ? 'Carregando suas cobranças…'
                    : count == 0
                        ? 'Nenhuma cobrança encontrada'
                        : '$count ${count == 1 ? 'cobrança' : 'cobranças'} no total',
                style: theme.bodyMedium.override(
                  font: GoogleFonts.inter(),
                  color: theme.secondaryText,
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    final totalChip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: theme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: theme.primary.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Total',
            style: theme.labelSmall.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              fontSize: 11.0,
              fontWeight: FontWeight.w600,
              color: theme.primary,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 2.0),
          Text(
            totalLabel,
            style: theme.titleMedium.override(
              font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: theme.primary,
              letterSpacing: 0.0,
            ),
          ),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isWide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: titleBlock),
              totalChip,
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: titleBlock),
                  if (!isWide)
                    _IconButtonAction(
                      icon: Icons.menu_open_rounded,
                      filled: true,
                      onTap: () => scaffoldKey.currentState?.openDrawer(),
                      tooltip: 'Abrir menu',
                    ),
                ],
              ),
              const SizedBox(height: 14.0),
              Align(
                alignment: Alignment.centerLeft,
                child: totalChip,
              ),
            ],
          ),
        child,
      ],
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.onSearch,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSearch;
  final VoidCallback onClear;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final hasText = widget.controller.text.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: theme.alternate),
      ),
      padding:
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 8.0),
            child:
                Icon(Icons.search_rounded, size: 22.0, color: theme.secondaryText),
          ),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => widget.onSearch(),
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(),
                fontSize: 15.0,
                color: theme.primaryText,
                letterSpacing: 0.0,
              ),
              decoration: InputDecoration(
                isCollapsed: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12.0),
                border: InputBorder.none,
                hintText: 'Buscar por ID da cobrança',
                hintStyle: theme.bodyMedium.override(
                  font: GoogleFonts.inter(),
                  fontSize: 15.0,
                  color: theme.secondaryText,
                  letterSpacing: 0.0,
                ),
              ),
            ),
          ),
          if (hasText) ...[
            _IconButtonAction(
              icon: Icons.close_rounded,
              onTap: widget.onClear,
              tooltip: 'Limpar busca',
            ),
            const SizedBox(width: 8.0),
          ],
          _PrimaryButton(
            label: 'Buscar',
            icon: Icons.arrow_forward_rounded,
            onTap: widget.onSearch,
          ),
        ],
      ),
    );
  }
}

class _ChargesList extends StatelessWidget {
  const _ChargesList({required this.data, required this.isWide});
  final List<dynamic> data;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: theme.alternate),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14.0,
            offset: const Offset(0.0, 4.0),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          if (isWide) const _TableHeader(),
          ...List.generate(data.length, (i) {
            final item = data[i];
            return Padding(
              padding: EdgeInsets.only(top: i == 0 ? 0.0 : 4.0),
              child: _ChargeRow(item: item, isWide: isWide),
            );
          }),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final cellStyle = theme.labelMedium.override(
      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
      fontSize: 11.5,
      fontWeight: FontWeight.w600,
      color: theme.secondaryText,
      letterSpacing: 0.6,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 14.0, 16.0, 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text('ID', style: cellStyle),
          ),
          Expanded(
            flex: 2,
            child: Text('VALOR', style: cellStyle),
          ),
          Expanded(
            flex: 3,
            child: Text('NOME', style: cellStyle),
          ),
          Expanded(
            flex: 2,
            child: Text('DATA', style: cellStyle),
          ),
          Expanded(
            flex: 2,
            child: Text('STATUS', style: cellStyle),
          ),
          const SizedBox(width: 110.0),
        ],
      ),
    );
  }
}

class _ChargeRow extends StatefulWidget {
  const _ChargeRow({required this.item, required this.isWide});
  final dynamic item;
  final bool isWide;

  @override
  State<_ChargeRow> createState() => _ChargeRowState();
}

class _ChargeRowState extends State<_ChargeRow> {
  bool _hovered = false;

  void _open() async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          elevation: 0,
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(dialogContext).unfocus();
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: ModalPagamentoWidget(items: widget.item),
          ),
        );
      },
    );
  }

  String _id() {
    return functions.shortIdFallback(
      getJsonField(widget.item, r'''$.id_cobranca_asaas''')?.toString(),
      getJsonField(widget.item, r'''$.id''')?.toString(),
    );
  }

  String _valor() {
    return functions.formatCurrencyBr(
      getJsonField(widget.item, r'''$.valor'''),
    );
  }

  String _nome() {
    return valueOrDefault<String>(
      getJsonField(widget.item, r'''$.user_nome''')?.toString(),
      '—',
    );
  }

  String _data() {
    final raw = getJsonField(widget.item, r'''$.created_at''')?.toString();
    if (raw == null || raw.isEmpty) return '—';
    return valueOrDefault<String>(
      dateTimeFormat(
        'dd/MM/yyyy',
        functions.stringToDatetime(raw),
        locale: FFLocalizations.of(context).languageCode,
      ),
      '—',
    );
  }

  String? _statusRaw() =>
      getJsonField(widget.item, r'''$.status_cobranca''')?.toString();

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final bg = _hovered
        ? theme.alternate.withOpacity(0.4)
        : theme.secondaryBackground;

    final statusBadge = _StatusBadge(statusRaw: _statusRaw());

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          onTap: _open,
          borderRadius: BorderRadius.circular(12.0),
          splashColor: theme.primary.withOpacity(0.1),
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: widget.isWide
                ? const EdgeInsets.fromLTRB(16.0, 14.0, 12.0, 14.0)
                : const EdgeInsets.all(14.0),
            child: widget.isWide
                ? _wideRow(theme, statusBadge)
                : _compactRow(theme, statusBadge),
          ),
        ),
      ),
    );
  }

  Widget _wideRow(FlutterFlowTheme theme, Widget statusBadge) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            _id(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.bodyMedium.override(
              font: GoogleFonts.robotoMono(),
              fontSize: 13.0,
              color: theme.secondaryText,
              letterSpacing: 0.0,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            _valor(),
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w700),
              fontSize: 15.0,
              fontWeight: FontWeight.w700,
              color: theme.primaryText,
              letterSpacing: 0.0,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            _nome(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(),
              fontSize: 14.0,
              color: theme.primaryText,
              letterSpacing: 0.0,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            _data(),
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(),
              fontSize: 13.0,
              color: theme.secondaryText,
              letterSpacing: 0.0,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.centerLeft,
            child: statusBadge,
          ),
        ),
        SizedBox(
          width: 110.0,
          child: Align(
            alignment: Alignment.centerRight,
            child: _PrimaryButton(
              label: 'Visualizar',
              icon: Icons.visibility_outlined,
              compact: true,
              onTap: _open,
            ),
          ),
        ),
      ],
    );
  }

  Widget _compactRow(FlutterFlowTheme theme, Widget statusBadge) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                _id(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.bodyMedium.override(
                  font: GoogleFonts.robotoMono(),
                  fontSize: 12.0,
                  color: theme.secondaryText,
                  letterSpacing: 0.0,
                ),
              ),
            ),
            statusBadge,
          ],
        ),
        const SizedBox(height: 6.0),
        Text(
          _valor(),
          style: theme.headlineSmall.override(
            font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
            fontSize: 22.0,
            fontWeight: FontWeight.w700,
            color: theme.primaryText,
            letterSpacing: 0.0,
          ),
        ),
        const SizedBox(height: 4.0),
        Row(
          children: [
            Icon(Icons.person_outline_rounded,
                size: 14.0, color: theme.secondaryText),
            const SizedBox(width: 4.0),
            Expanded(
              child: Text(
                _nome(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.bodyMedium.override(
                  font: GoogleFonts.inter(),
                  fontSize: 13.0,
                  color: theme.secondaryText,
                  letterSpacing: 0.0,
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Icon(Icons.calendar_today_rounded,
                size: 13.0, color: theme.secondaryText),
            const SizedBox(width: 4.0),
            Text(
              _data(),
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(),
                fontSize: 13.0,
                color: theme.secondaryText,
                letterSpacing: 0.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        SizedBox(
          width: double.infinity,
          child: _PrimaryButton(
            label: 'Visualizar cobrança',
            icon: Icons.visibility_outlined,
            onTap: _open,
            block: true,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.statusRaw});
  final String? statusRaw;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final label = functions.cobrancaStatusLabel(statusRaw);
    final bg = functions.cobrancaStatusColorBg(statusRaw);
    final fg = functions.cobrancaStatusColorFg(statusRaw);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.0,
            height: 6.0,
            decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6.0),
          Text(
            label,
            style: theme.labelSmall.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              fontSize: 11.0,
              fontWeight: FontWeight.w600,
              color: fg,
              letterSpacing: 0.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _Pagination extends StatelessWidget {
  const _Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.perPage,
    required this.onPrev,
    required this.onNext,
    required this.onPerPageChanged,
  });

  final int currentPage;
  final int totalPages;
  final int perPage;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final ValueChanged<int?> onPerPageChanged;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final canPrev = currentPage > 1;
    final canNext = currentPage < totalPages;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _PageNav(
          icon: Icons.chevron_left_rounded,
          enabled: canPrev,
          onTap: onPrev,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Text(
            'Página $currentPage de $totalPages',
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: theme.primaryText,
              letterSpacing: 0.0,
            ),
          ),
        ),
        _PageNav(
          icon: Icons.chevron_right_rounded,
          enabled: canNext,
          onTap: onNext,
        ),
        const SizedBox(width: 24.0),
        Text(
          'Itens por página:',
          style: theme.labelMedium.override(
            font: GoogleFonts.inter(),
            color: theme.secondaryText,
            fontSize: 13.0,
            letterSpacing: 0.0,
          ),
        ),
        const SizedBox(width: 8.0),
        DropdownButton<int>(
          value: perPage,
          underline: const SizedBox.shrink(),
          borderRadius: BorderRadius.circular(10.0),
          style: theme.bodyMedium.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.w600),
            color: theme.primaryText,
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.0,
          ),
          items: const [5, 10, 20, 50]
              .map((v) => DropdownMenuItem<int>(
                    value: v,
                    child: Text(v.toString()),
                  ))
              .toList(),
          onChanged: onPerPageChanged,
        ),
      ],
    );
  }
}

class _PageNav extends StatefulWidget {
  const _PageNav({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  State<_PageNav> createState() => _PageNavState();
}

class _PageNavState extends State<_PageNav> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final bg = !widget.enabled
        ? theme.alternate
        : (_hovered ? theme.primary.withOpacity(0.88) : theme.primary);
    final color = widget.enabled ? theme.info : theme.secondaryText;

    return MouseRegion(
      cursor: widget.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.enabled ? widget.onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          width: 38.0,
          height: 38.0,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10.0),
          ),
          alignment: Alignment.center,
          child: Icon(widget.icon, color: color, size: 22.0),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.compact = false,
    this.block = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool compact;
  final bool block;

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final base = theme.primary;
    final bg = _pressed || _hovered ? base.withOpacity(0.88) : base;
    final fg = theme.info;

    final content = Row(
      mainAxisSize:
          widget.block ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(widget.icon, size: 16.0, color: fg),
        const SizedBox(width: 6.0),
        Text(
          widget.label,
          style: theme.titleSmall.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.w600),
            fontSize: 13.0,
            fontWeight: FontWeight.w600,
            color: fg,
            letterSpacing: 0.0,
          ),
        ),
      ],
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            padding: EdgeInsets.symmetric(
              horizontal: widget.compact ? 12.0 : 16.0,
              vertical: widget.compact ? 8.0 : 12.0,
            ),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}

class _IconButtonAction extends StatefulWidget {
  const _IconButtonAction({
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.filled = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  final bool filled;

  @override
  State<_IconButtonAction> createState() => _IconButtonActionState();
}

class _IconButtonActionState extends State<_IconButtonAction> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final accent = theme.primary;
    final bg = widget.filled
        ? (_hovered ? accent.withOpacity(0.88) : accent)
        : (_hovered ? theme.alternate.withOpacity(0.5) : Colors.transparent);
    final fg =
        widget.filled ? theme.info : (_hovered ? accent : theme.primaryText);

    final btn = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10.0),
          ),
          alignment: Alignment.center,
          child: Icon(widget.icon, color: fg, size: 22.0),
        ),
      ),
    );
    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: btn);
    }
    return btn;
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasFilter, required this.onClearFilter});
  final bool hasFilter;
  final VoidCallback onClearFilter;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: theme.alternate),
      ),
      padding:
          const EdgeInsets.symmetric(horizontal: 24.0, vertical: 56.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 88.0,
            height: 88.0,
            decoration: BoxDecoration(
              color: theme.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.receipt_long_rounded,
              size: 42.0,
              color: theme.primary,
            ),
          ),
          const SizedBox(height: 18.0),
          Text(
            hasFilter
                ? 'Nenhuma cobrança encontrada'
                : 'Você ainda não tem cobranças',
            textAlign: TextAlign.center,
            style: theme.titleMedium.override(
              font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: theme.primaryText,
              letterSpacing: 0.0,
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            hasFilter
                ? 'Tente buscar por outro ID ou limpe os filtros para ver tudo.'
                : 'Quando uma cobrança for emitida, ela aparecerá aqui.',
            textAlign: TextAlign.center,
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(),
              fontSize: 14.0,
              color: theme.secondaryText,
              letterSpacing: 0.0,
            ),
          ),
          if (hasFilter) ...[
            const SizedBox(height: 18.0),
            OutlinedButton.icon(
              onPressed: onClearFilter,
              icon: const Icon(Icons.refresh_rounded, size: 18.0),
              label: const Text('Limpar busca'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.primary,
                side: BorderSide(color: theme.primary),
                padding: const EdgeInsets.symmetric(
                    horizontal: 18.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999.0),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64.0),
      child: Center(
        child: SizedBox(
          width: 36.0,
          height: 36.0,
          child: CircularProgressIndicator(
            strokeWidth: 3.0,
            valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState();

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 24.0),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: theme.alternate),
      ),
      padding:
          const EdgeInsets.symmetric(horizontal: 24.0, vertical: 56.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded,
              size: 48.0, color: theme.error),
          const SizedBox(height: 12.0),
          Text(
            'Não foi possível carregar suas cobranças',
            textAlign: TextAlign.center,
            style: theme.titleMedium.override(
              font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
              fontSize: 17.0,
              fontWeight: FontWeight.w700,
              color: theme.primaryText,
              letterSpacing: 0.0,
            ),
          ),
        ],
      ),
    );
  }
}
