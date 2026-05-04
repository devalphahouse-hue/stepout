import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'mural_model.dart';
export 'mural_model.dart';

class MuralWidget extends StatefulWidget {
  const MuralWidget({super.key, this.route});

  final String? route;

  static String routeName = 'Mural';
  static String routePath = '/mural';

  @override
  State<MuralWidget> createState() => _MuralWidgetState();
}

class _MuralWidgetState extends State<MuralWidget> {
  late MuralModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const int _perPage = 10;
  int _currentPage = 1;
  int? _filterYear;
  int? _filterMonth;

  Future<_MuralPage>? _future;
  String? _futureKey;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MuralModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  String _key() => 'p=$_currentPage|y=$_filterYear|m=$_filterMonth';

  Future<_MuralPage> _ensureFuture() {
    final key = _key();
    if (_future == null || _futureKey != key) {
      _futureKey = key;
      _future = _runQuery();
    }
    return _future!;
  }

  Future<_MuralPage> _runQuery() async {
    final offset = (_currentPage - 1) * _perPage;
    final endRange = offset + _perPage;

    String? gte;
    String? lt;
    final effectiveYear = _filterYear ??
        (_filterMonth != null ? DateTime.now().year : null);
    if (effectiveYear != null) {
      final m = _filterMonth;
      if (m != null) {
        final next = m == 12
            ? DateTime(effectiveYear + 1, 1, 1)
            : DateTime(effectiveYear, m + 1, 1);
        gte = DateTime(effectiveYear, m, 1).toIso8601String();
        lt = next.toIso8601String();
      } else {
        gte = DateTime(effectiveYear, 1, 1).toIso8601String();
        lt = DateTime(effectiveYear + 1, 1, 1).toIso8601String();
      }
    }

    final rows = await MuralTable().queryRows(
      queryFn: (q) => q
          .eqOrNull('idaluno', currentUserUid)
          .gteOrNull('created_at', gte)
          .ltOrNull('created_at', lt)
          .order('created_at', ascending: false)
          .range(offset, endRange),
    );

    final hasMore = rows.length > _perPage;
    final entries = hasMore ? rows.sublist(0, _perPage) : rows;
    return _MuralPage(
      entries: entries,
      hasMore: hasMore,
      page: _currentPage,
    );
  }

  void _setYear(int? y) {
    safeSetState(() {
      _filterYear = y;
      _currentPage = 1;
      _future = null;
    });
  }

  void _setMonth(int? m) {
    safeSetState(() {
      _filterMonth = m;
      _currentPage = 1;
      _future = null;
    });
  }

  void _clearFilters() {
    safeSetState(() {
      _filterYear = null;
      _filterMonth = null;
      _currentPage = 1;
      _future = null;
    });
  }

  void _goPrev() {
    if (_currentPage > 1) {
      safeSetState(() {
        _currentPage--;
        _future = null;
      });
    }
  }

  void _goNext() {
    safeSetState(() {
      _currentPage++;
      _future = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final theme = FlutterFlowTheme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= kBreakpointMedium;
    final isCompact = width < kBreakpointSmall;
    final hasFilter = _filterYear != null || _filterMonth != null;

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
          child: const SidebarWidget(route: 'Treinamentos'),
        ),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isWide)
                const SizedBox(
                  width: 300.0,
                  child: SidebarWidget(route: 'Treinamentos'),
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
                    child: FutureBuilder<_MuralPage>(
                          future: _ensureFuture(),
                          builder: (context, snapshot) {
                            final hasError = snapshot.hasError;
                            final hasData = snapshot.hasData;
                            final page = hasData ? snapshot.data! : null;

                            String subtitle;
                            if (hasError) {
                              subtitle =
                                  'Não foi possível carregar suas anotações';
                            } else if (!hasData) {
                              subtitle = 'Carregando suas anotações…';
                            } else if (page!.entries.isEmpty &&
                                _currentPage == 1) {
                              subtitle = hasFilter
                                  ? 'Nenhuma anotação no período selecionado'
                                  : 'Nenhuma anotação por enquanto';
                            } else {
                              final extra = page.hasMore ? '+' : '';
                              subtitle =
                                  'Página $_currentPage  •  ${page.entries.length}$extra ${page.entries.length == 1 ? 'anotação' : 'anotações'}';
                            }

                            return Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                              children: [
                                _Header(
                                  subtitle: subtitle,
                                  isWide: isWide,
                                  onMenu: () => scaffoldKey.currentState
                                      ?.openDrawer(),
                                ),
                                const SizedBox(height: 20.0),
                                _FilterBar(
                                  selectedYear: _filterYear,
                                  selectedMonth: _filterMonth,
                                  onYearChanged: _setYear,
                                  onMonthChanged: _setMonth,
                                  onClear: hasFilter ? _clearFilters : null,
                                ),
                                const SizedBox(height: 20.0),
                                if (hasError)
                                  _buildErrorState(context)
                                else if (!hasData)
                                  const _LoadingBlock()
                                else if (page!.entries.isEmpty)
                                  _buildEmptyState(
                                    context,
                                    hasFilter: hasFilter,
                                    onClearFilter: _clearFilters,
                                  )
                                else
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      for (int i = 0;
                                          i < page.entries.length;
                                          i++) ...[
                                        if (i > 0)
                                          const SizedBox(height: 16.0),
                                        _MuralCard(
                                          entry: page.entries[i],
                                          isCompact: isCompact,
                                        ),
                                      ],
                                    ],
                                  ),
                                if (hasData &&
                                    (page!.hasMore || _currentPage > 1)) ...[
                                  const SizedBox(height: 20.0),
                                  _PaginationBar(
                                    currentPage: _currentPage,
                                    canPrev: _currentPage > 1,
                                    canNext: page.hasMore,
                                    onPrev: _goPrev,
                                    onNext: _goNext,
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

  Widget _buildEmptyState(
    BuildContext context, {
    required bool hasFilter,
    required VoidCallback onClearFilter,
  }) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: theme.alternate),
      ),
      padding: const EdgeInsets.symmetric(vertical: 56.0, horizontal: 24.0),
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
                Icons.menu_book_rounded,
                color: theme.primary,
                size: 40.0,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              hasFilter
                  ? 'Nenhuma anotação no período'
                  : 'Sem anotações ainda',
              style: theme.titleMedium.override(
                font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.0,
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              hasFilter
                  ? 'Tente outro mês/ano ou limpe os filtros para ver tudo.'
                  : 'Quando seu professor postar conteúdo de uma aula, ele vai aparecer aqui.',
              textAlign: TextAlign.center,
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(),
                color: theme.secondaryText,
                letterSpacing: 0.0,
              ),
            ),
            if (hasFilter) ...[
              const SizedBox(height: 18.0),
              OutlinedButton.icon(
                onPressed: onClearFilter,
                icon: const Icon(Icons.refresh_rounded, size: 18.0),
                label: const Text('Limpar filtros'),
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
            Icon(Icons.error_outline_rounded,
                color: theme.error, size: 36.0),
            const SizedBox(height: 12.0),
            Text(
              'Não foi possível carregar suas anotações.',
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

class _MuralPage {
  _MuralPage({
    required this.entries,
    required this.hasMore,
    required this.page,
  });

  final List<MuralRow> entries;
  final bool hasMore;
  final int page;
}

class _Header extends StatelessWidget {
  const _Header({
    required this.subtitle,
    required this.isWide,
    required this.onMenu,
  });

  final String subtitle;
  final bool isWide;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Row(
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
            Icons.menu_book_rounded,
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
                'Mural do Aluno',
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
                subtitle,
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
        if (!isWide)
          _MenuButton(onTap: onMenu),
      ],
    );
  }
}

class _MenuButton extends StatefulWidget {
  const _MenuButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<_MenuButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final accent = theme.primary;
    return MouseRegion(
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
            color: _hovered ? accent.withOpacity(0.88) : accent,
            borderRadius: BorderRadius.circular(10.0),
          ),
          alignment: Alignment.center,
          child: Icon(Icons.menu_open_rounded, color: theme.info, size: 22.0),
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.selectedYear,
    required this.selectedMonth,
    required this.onYearChanged,
    required this.onMonthChanged,
    required this.onClear,
  });

  final int? selectedYear;
  final int? selectedMonth;
  final ValueChanged<int?> onYearChanged;
  final ValueChanged<int?> onMonthChanged;
  final VoidCallback? onClear;

  static const _months = [
    (1, 'Janeiro'),
    (2, 'Fevereiro'),
    (3, 'Março'),
    (4, 'Abril'),
    (5, 'Maio'),
    (6, 'Junho'),
    (7, 'Julho'),
    (8, 'Agosto'),
    (9, 'Setembro'),
    (10, 'Outubro'),
    (11, 'Novembro'),
    (12, 'Dezembro'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final currentYear = DateTime.now().year;
    final years =
        List<int>.generate(5, (i) => currentYear - i); // last 5 years incl.

    return Container(
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: theme.alternate),
      ),
      padding:
          const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12.0,
        runSpacing: 8.0,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.filter_alt_rounded,
                  size: 18.0, color: theme.secondaryText),
              const SizedBox(width: 8.0),
              Text(
                'Filtrar por',
                style: theme.labelMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  color: theme.secondaryText,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.0,
                ),
              ),
            ],
          ),
          _FilterPill<int?>(
            label: selectedYear == null ? 'Ano' : selectedYear.toString(),
            value: selectedYear,
            items: [
              const DropdownMenuItem<int?>(
                value: null,
                child: Text('Todos os anos'),
              ),
              ...years.map(
                (y) => DropdownMenuItem<int?>(
                  value: y,
                  child: Text(y.toString()),
                ),
              ),
            ],
            onChanged: onYearChanged,
            highlighted: selectedYear != null,
          ),
          _FilterPill<int?>(
            label: selectedMonth == null
                ? 'Mês'
                : _months
                    .firstWhere((m) => m.$1 == selectedMonth)
                    .$2,
            value: selectedMonth,
            items: [
              const DropdownMenuItem<int?>(
                value: null,
                child: Text('Todos os meses'),
              ),
              ..._months.map(
                (m) => DropdownMenuItem<int?>(
                  value: m.$1,
                  child: Text(m.$2),
                ),
              ),
            ],
            onChanged: onMonthChanged,
            highlighted: selectedMonth != null,
          ),
          if (onClear != null)
            TextButton.icon(
              onPressed: onClear,
              icon: const Icon(Icons.close_rounded, size: 16.0),
              label: const Text('Limpar'),
              style: TextButton.styleFrom(
                foregroundColor: theme.error,
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999.0),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FilterPill<T> extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.highlighted,
  });

  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final bg = highlighted
        ? theme.primary.withOpacity(0.12)
        : theme.secondaryBackground;
    final fg = highlighted ? theme.primary : theme.primaryText;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999.0),
        border: Border.all(
          color: highlighted
              ? theme.primary.withOpacity(0.4)
              : theme.alternate,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          isDense: true,
          borderRadius: BorderRadius.circular(12.0),
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: fg, size: 20.0),
          style: theme.bodyMedium.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.w600),
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: fg,
            letterSpacing: 0.0,
          ),
          dropdownColor: theme.primaryBackground,
          hint: Text(
            label,
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: fg,
              letterSpacing: 0.0,
            ),
          ),
          selectedItemBuilder: (context) => items
              .map(
                (item) => Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item.value == null ? label : (item.child as Text).data!,
                    style: theme.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: fg,
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({
    required this.currentPage,
    required this.canPrev,
    required this.canNext,
    required this.onPrev,
    required this.onNext,
  });

  final int currentPage;
  final bool canPrev;
  final bool canNext;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
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
            'Página $currentPage',
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

class _LoadingBlock extends StatelessWidget {
  const _LoadingBlock();

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
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
          ),
        ),
      ),
    );
  }
}

class _MuralCard extends StatefulWidget {
  const _MuralCard({
    required this.entry,
    required this.isCompact,
  });

  final MuralRow entry;
  final bool isCompact;

  @override
  State<_MuralCard> createState() => _MuralCardState();
}

class _MuralCardState extends State<_MuralCard> {
  bool _hovered = false;

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

  String _firstInitial(String? name) {
    final n = (name ?? '').trim();
    if (n.isEmpty) return '?';
    return n.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final entry = widget.entry;
    final created = entry.createdAt;
    final professor = (entry.nomeProfessor ?? '').trim();
    final conteudo = (entry.conteudo ?? '').trim();

    final day = created.day.toString().padLeft(2, '0');
    final month = _months[created.month - 1];
    final year = created.year.toString();

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: theme.primaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: _hovered
                ? theme.primary.withOpacity(0.4)
                : theme.alternate,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: _hovered
                  ? const Color(0x18000000)
                  : const Color(0x10000000),
              blurRadius: _hovered ? 18.0 : 12.0,
              offset: Offset(0, _hovered ? 6.0 : 3.0),
            ),
          ],
        ),
        padding: EdgeInsets.all(widget.isCompact ? 16.0 : 22.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 56.0,
                  height: 64.0,
                  decoration: BoxDecoration(
                    color: theme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        month,
                        style: TextStyle(
                          fontFamily:
                              GoogleFonts.interTight().fontFamily,
                          fontSize: 11.0,
                          fontWeight: FontWeight.w700,
                          color: theme.primary.withOpacity(0.7),
                          letterSpacing: 0.6,
                        ),
                      ),
                      Text(
                        day,
                        style: TextStyle(
                          fontFamily:
                              GoogleFonts.interTight().fontFamily,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w800,
                          color: theme.primary,
                          height: 1.05,
                        ),
                      ),
                      Text(
                        year,
                        style: TextStyle(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          fontSize: 10.0,
                          fontWeight: FontWeight.w600,
                          color: theme.primary.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aula',
                        style: theme.bodySmall.override(
                          font: GoogleFonts.inter(
                              fontWeight: FontWeight.w600),
                          color: theme.secondaryText,
                          letterSpacing: 0.4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      if (professor.isNotEmpty)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 28.0,
                              height: 28.0,
                              decoration: BoxDecoration(
                                color:
                                    theme.primary.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                _firstInitial(professor),
                                style: TextStyle(
                                  fontFamily: GoogleFonts.interTight()
                                      .fontFamily,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                  color: theme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Flexible(
                              child: Text(
                                professor,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.titleSmall.override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.w700,
                                  ),
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          'Sem professor informado',
                          style: theme.titleSmall.override(
                            font: GoogleFonts.interTight(
                                fontWeight: FontWeight.w600),
                            color: theme.secondaryText,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.0,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18.0),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: widget.isCompact ? 12.0 : 16.0,
                vertical: 12.0,
              ),
              decoration: BoxDecoration(
                color: theme.secondaryBackground,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: conteudo.isEmpty
                  ? Text(
                      'Sem conteúdo registrado.',
                      style: theme.bodyMedium.override(
                        font: GoogleFonts.inter(),
                        color: theme.secondaryText,
                        letterSpacing: 0.0,
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _buildContentLines(theme, conteudo),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildContentLines(FlutterFlowTheme theme, String content) {
    final rawLines = content
        .split(RegExp(r'\r?\n'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    final widgets = <Widget>[];
    for (var i = 0; i < rawLines.length; i++) {
      if (i > 0) widgets.add(const SizedBox(height: 6.0));
      final line = rawLines[i];
      final eqIdx = line.indexOf('=');
      if (eqIdx > 0 && eqIdx < line.length - 1) {
        final left = line.substring(0, eqIdx).trim();
        final right = line.substring(eqIdx + 1).trim();
        widgets.add(_VocabRow(left: left, right: right));
      } else {
        widgets.add(
          Text(
            line,
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(),
              letterSpacing: 0.0,
            ),
          ),
        );
      }
    }
    return widgets;
  }
}

class _VocabRow extends StatelessWidget {
  const _VocabRow({required this.left, required this.right});

  final String left;
  final String right;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final isNarrow = MediaQuery.sizeOf(context).width < kBreakpointSmall;

    final leftText = Text(
      left,
      style: theme.bodyMedium.override(
        font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
        fontWeight: FontWeight.w700,
        letterSpacing: 0.0,
      ),
    );
    final arrow = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Icon(
        Icons.arrow_forward_rounded,
        size: 14.0,
        color: theme.primary,
      ),
    );
    final rightText = Text(
      right,
      style: theme.bodyMedium.override(
        font: GoogleFonts.inter(),
        color: theme.primaryText,
        letterSpacing: 0.0,
      ),
    );

    if (isNarrow) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: leftText),
          arrow,
          Expanded(child: rightText),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 220.0,
          child: leftText,
        ),
        arrow,
        Expanded(child: rightText),
      ],
    );
  }
}
