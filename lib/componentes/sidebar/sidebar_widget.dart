import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'sidebar_model.dart';
export 'sidebar_model.dart';

class SidebarWidget extends StatefulWidget {
  const SidebarWidget({
    super.key,
    required this.route,
  });

  final String? route;

  @override
  State<SidebarWidget> createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget> {
  late SidebarModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SidebarModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  TransitionInfo get _fadeTransition => TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: const Duration(milliseconds: 0),
      );

  void _push(String routeName, {bool withRouteParam = false}) {
    context.pushNamed(
      routeName,
      queryParameters: withRouteParam
          ? {
              'route': serializeParam('', ParamType.String),
            }.withoutNulls
          : const {},
      extra: <String, dynamic>{
        '__transition_info__': _fadeTransition,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final route = widget.route;
    final isCompact = MediaQuery.sizeOf(context).width < kBreakpointSmall;

    return Container(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height,
      constraints: const BoxConstraints(maxWidth: 300.0),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        border: Border(
          right: BorderSide(
            color: theme.alternate,
            width: 1.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 28.0),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    'assets/images/Logo.png',
                    height: isCompact ? 56.0 : 80.0,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
            _SidebarItem(
              icon: Icons.dashboard_rounded,
              label: 'Dashboard',
              active: route == 'Dashboard',
              onTap: () =>
                  _push(DashboardWidget.routeName, withRouteParam: true),
            ),
            _SidebarItem(
              icon: Icons.calendar_month_rounded,
              label: 'Calendário de Aulas',
              active: route == 'Aulas',
              onTap: () => _push(CalendarioAulasListaWidget.routeName,
                  withRouteParam: true),
            ),
            _SidebarItem(
              icon: Icons.school_outlined,
              label: 'Mural',
              active: route == 'Treinamentos',
              onTap: () => _push(MuralWidget.routeName),
            ),
            _SidebarItem(
              icon: Icons.chat_rounded,
              label: 'Chat',
              active: route == 'Chat',
              onTap: () => _push(ChatWidget.routeName),
            ),
            _SidebarItem(
              icon: Icons.attach_money_rounded,
              label: 'Financeiro',
              active: route == 'Financeiro',
              onTap: () => _push(FinanceiroWidget.routeName),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(
                height: 1.0,
                thickness: 1.0,
                color: theme.alternate,
              ),
            ),
            _SidebarItem(
              icon: Icons.account_circle_rounded,
              label: 'Perfil',
              active: route == 'Perfil',
              onTap: () => _push(PerfilWidget.routeName),
            ),
            _SidebarItem(
              icon: Icons.logout_rounded,
              label: 'Logout',
              active: false,
              destructive: true,
              onTap: () async {
                GoRouter.of(context).prepareAuthEvent();
                await authManager.signOut();
                GoRouter.of(context).clearRedirectLocation();
                if (!context.mounted) return;
                context.goNamedAuth(LoginWidget.routeName, context.mounted);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;
  final bool destructive;

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final accent = widget.destructive ? theme.error : theme.primary;
    final isActive = widget.active;
    final isHighlighted = isActive || _hovered || _pressed;

    final bgColor = isActive
        ? accent.withOpacity(0.12)
        : (_hovered
            ? accent.withOpacity(0.06)
            : Colors.transparent);
    final iconColor = isHighlighted ? accent : theme.secondaryText;
    final textColor = isHighlighted ? accent : theme.primaryText;
    final fontWeight = isActive ? FontWeight.w700 : FontWeight.w500;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() {
          _hovered = false;
          _pressed = false;
        }),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10.0),
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) => setState(() => _pressed = false),
            onTapCancel: () => setState(() => _pressed = false),
            borderRadius: BorderRadius.circular(10.0),
            splashColor: accent.withOpacity(0.12),
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: const EdgeInsetsDirectional.fromSTEB(
                  9.0, 10.0, 12.0, 10.0),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10.0),
                border: Border(
                  left: BorderSide(
                    color: isActive ? accent : Colors.transparent,
                    width: 3.0,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    color: iconColor,
                    size: 22.0,
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      widget.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.bodyLarge.override(
                        font: GoogleFonts.inter(fontWeight: fontWeight),
                        fontSize: 15.0,
                        fontWeight: fontWeight,
                        color: textColor,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
