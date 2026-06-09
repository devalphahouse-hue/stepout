import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/bottom_nav_mobile/bottom_nav_mobile_widget.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/componentes/sidebar_slim/sidebar_slim_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dashboard_model.dart';
export 'dashboard_model.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({
    super.key,
    required this.route,
  });

  final String? route;

  static String routeName = 'Dashboard';
  static String routePath = '/dashboard';

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  late DashboardModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DashboardModel());

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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        drawer: Drawer(
          elevation: 0.0,
          width: 300.0,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          child: SidebarWidget(route: 'Dashboard'),
        ),
        bottomNavigationBar:
            const BottomNavMobileWidget(active: 'Dashboard'),
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
                  child: SidebarWidget(
                    route: 'Dashboard',
                  ),
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
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                      Padding(
                        padding: EdgeInsets.all(responsivePadding(context)),
                        child: FutureBuilder<List<UsersRow>>(
                          future: UsersTable().queryRows(
                            queryFn: (q) => q.eqOrNull(
                              'id',
                              currentUserUid,
                            ),
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Erro ao carregar dados.',
                                    style: FlutterFlowTheme.of(context).bodyMedium),
                              );
                            }
                            if (!snapshot.hasData) {
                              return Center(
                                child: SizedBox(
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
                            final usersRow = snapshot.data!.isNotEmpty
                                ? snapshot.data!.first
                                : null;
                            final fullName =
                                (usersRow?.nome ?? currentUserDisplayName).trim();
                            final firstName = fullName.isNotEmpty
                                ? fullName.split(' ').first
                                : '';
                            final initial = firstName.isNotEmpty
                                ? firstName.substring(0, 1).toUpperCase()
                                : (currentUserEmail.isNotEmpty
                                    ? currentUserEmail
                                        .substring(0, 1)
                                        .toUpperCase()
                                    : '?');
                            final hour = DateTime.now().hour;
                            final greeting = hour < 12
                                ? 'Bom dia'
                                : hour < 18
                                    ? 'Boa tarde'
                                    : 'Boa noite';
                            final greetingLine = firstName.isNotEmpty
                                ? '$greeting, $firstName!'
                                : '$greeting!';
                            final imageUrl = usersRow?.imagemPerfil;
                            final hasImage =
                                imageUrl != null && imageUrl.isNotEmpty;

                            return Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 56.0,
                                          height: 56.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primary
                                                .withOpacity(0.12),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: ClipOval(
                                            child: hasImage
                                                ? Image.network(
                                                    imageUrl,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (_, __, ___) => Center(
                                                      child: Text(
                                                        initial,
                                                        style: GoogleFonts
                                                            .interTight(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 22.0,
                                                          color:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .primary,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Center(
                                                    child: Text(
                                                      initial,
                                                      style: GoogleFonts
                                                          .interTight(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 22.0,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        SizedBox(width: 16.0),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                greetingLine,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .headlineSmall
                                                    .override(
                                                      font: GoogleFonts
                                                          .interTight(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                              ),
                                              SizedBox(height: 2.0),
                                              Text(
                                                'Bem-vindo de volta ao Step Out',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.inter(),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                            ],
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
                                      fillColor:
                                          FlutterFlowTheme.of(context).primary,
                                      icon: Icon(
                                        Icons.menu_open,
                                        color:
                                            FlutterFlowTheme.of(context).info,
                                        size: 24.0,
                                      ),
                                      onPressed: () async {
                                        scaffoldKey.currentState!.openDrawer();
                                      },
                                    ),
                                ],
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            responsivePadding(context),
                            8.0,
                            responsivePadding(context),
                            16.0),
                        child: Builder(
                          builder: (context) {
                                final width =
                                    MediaQuery.sizeOf(context).width;
                                final isMobile = width < kBreakpointSmall;
                                final isTablet =
                                    width >= kBreakpointSmall &&
                                        width < kBreakpointLarge;
                                final cardWidth = isMobile
                                    ? (width -
                                            (responsivePadding(context) * 2 +
                                                16)) /
                                        2
                                    : isTablet
                                        ? (width -
                                                (responsivePadding(context) *
                                                        2 +
                                                    48)) /
                                            4
                                        : 240.0;
                                return Wrap(
                                  spacing: 16.0,
                                  runSpacing: 16.0,
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment:
                                      WrapCrossAlignment.start,
                                  children: [
                                    _QuickActionCard(
                                      width: cardWidth,
                                      icon: Icons.calendar_today_rounded,
                                      title: 'Calendário',
                                      subtitle: 'Veja suas aulas',
                                      onTap: () => context.pushNamed(
                                        CalendarioAulasListaWidget.routeName,
                                        queryParameters: {
                                          'route': serializeParam(
                                              '', ParamType.String),
                                        }.withoutNulls,
                                      ),
                                    ),
                                    _QuickActionCard(
                                      width: cardWidth,
                                      icon: Icons.dashboard_rounded,
                                      title: 'Mural',
                                      subtitle: 'Novidades e avisos',
                                      onTap: () => context
                                          .pushNamed(MuralWidget.routeName),
                                    ),
                                    _QuickActionCard(
                                      width: cardWidth,
                                      icon: Icons
                                          .chat_bubble_outline_rounded,
                                      title: 'Chat',
                                      subtitle: 'Fale com seu professor',
                                      onTap: () => context
                                          .pushNamed(ChatWidget.routeName),
                                    ),
                                    _QuickActionCard(
                                      width: cardWidth,
                                      icon: Icons.person_outline_rounded,
                                      title: 'Perfil',
                                      subtitle: 'Sua conta',
                                      onTap: () => context.pushNamed(
                                          PerfilWidget.routeName),
                                    ),
                                  ],
                                );
                              },
                            ),
                      ),
                      Expanded(
                        child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            responsivePadding(context),
                            8.0,
                            responsivePadding(context),
                            16.0),
                        child: FutureBuilder<List<BannersRow>>(
                              future: BannersTable().queryRows(
                                queryFn: (q) => q.eqOrNull(
                                  'banner_aluno',
                                  true,
                                ),
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return SizedBox.shrink();
                                }
                                final isMobile =
                                    MediaQuery.sizeOf(context).width <
                                        kBreakpointSmall;
                                if (!snapshot.hasData) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      borderRadius:
                                          BorderRadius.circular(24.0),
                                    ),
                                    child: Center(
                                      child: SizedBox(
                                        width: 32.0,
                                        height: 32.0,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<
                                                  Color>(
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                final banners = snapshot.data!;
                                if (banners.isEmpty) {
                                  return SizedBox.shrink();
                                }
                                return ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(24.0),
                                  child: Container(
                                    color: FlutterFlowTheme.of(context)
                                        .primary,
                                    child: Stack(
                                        children: [
                                        PageView.builder(
                                          controller: _model
                                                  .pageViewController ??=
                                              PageController(
                                                  initialPage: 0),
                                          itemCount: banners.length,
                                          itemBuilder: (context, idx) {
                                            final banner = banners[idx];
                                            final imageUrl = isMobile
                                                ? (banner.imagemMobile !=
                                                            null &&
                                                        banner.imagemMobile!
                                                            .isNotEmpty
                                                    ? banner.imagemMobile!
                                                    : (banner.imagemPc ?? ''))
                                                : (banner.imagemPc ?? '');
                                            return Image.network(
                                              imageUrl,
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (_, __, ___) => Container(
                                                color:
                                                    FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                              ),
                                            );
                                          },
                                        ),
                                        if (banners.length > 1)
                                          Positioned(
                                            left: 0,
                                            right: 0,
                                            bottom: 16.0,
                                            child: Center(
                                              child: smooth_page_indicator
                                                  .SmoothPageIndicator(
                                                controller: _model
                                                        .pageViewController ??=
                                                    PageController(
                                                        initialPage: 0),
                                                count: banners.length,
                                                onDotClicked: (i) async {
                                                  await _model
                                                      .pageViewController!
                                                      .animateToPage(
                                                    i,
                                                    duration: Duration(
                                                        milliseconds: 400),
                                                    curve: Curves.easeOut,
                                                  );
                                                  safeSetState(() {});
                                                },
                                                effect:
                                                    smooth_page_indicator
                                                        .ExpandingDotsEffect(
                                                  dotWidth: 8.0,
                                                  dotHeight: 8.0,
                                                  spacing: 6.0,
                                                  expansionFactor: 3,
                                                  dotColor: Colors.white
                                                      .withOpacity(0.5),
                                                  activeDotColor:
                                                      Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                      ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatefulWidget {
  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.width,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final double width;

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final active = _hovered || _pressed;
    final scale = _pressed ? 0.97 : (_hovered ? 1.03 : 1.0);
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
        child: SizedBox(
          width: widget.width,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20.0),
            child: InkWell(
              onTap: widget.onTap,
              onTapDown: (_) => setState(() => _pressed = true),
              onTapUp: (_) => setState(() => _pressed = false),
              onTapCancel: () => setState(() => _pressed = false),
              borderRadius: BorderRadius.circular(20.0),
              splashColor: theme.primary.withOpacity(0.08),
              highlightColor: Colors.transparent,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: active
                      ? theme.primary.withOpacity(0.04)
                      : theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: active
                        ? theme.primary.withOpacity(0.40)
                        : theme.alternate,
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(active ? 0.05 : 0.02),
                      blurRadius: active ? 22.0 : 14.0,
                      offset: Offset(0, active ? 8.0 : 4.0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 48.0,
                      height: 48.0,
                      decoration: BoxDecoration(
                        color: theme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Icon(
                        widget.icon,
                        color: theme.primary,
                        size: 24.0,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      widget.title,
                      style: theme.titleMedium.override(
                        font: GoogleFonts.interTight(
                          fontWeight: FontWeight.w700,
                        ),
                        color: theme.primaryText,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.0,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      widget.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.bodySmall.override(
                        font: GoogleFonts.inter(),
                        color: theme.secondaryText,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
