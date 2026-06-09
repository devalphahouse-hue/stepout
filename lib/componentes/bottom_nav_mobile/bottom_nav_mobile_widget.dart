import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Bottom navigation bar exibida apenas em larguras < kBreakpointMedium.
/// Em telas maiores retorna SizedBox.shrink() (não ocupa espaço).
class BottomNavMobileWidget extends StatelessWidget {
  const BottomNavMobileWidget({
    super.key,
    required this.active,
  });

  /// Identificador da rota ativa: 'Dashboard', 'Aulas', 'Mural' ou 'Chat'.
  final String active;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= kBreakpointMedium) {
      return const SizedBox.shrink();
    }

    final theme = FlutterFlowTheme.of(context);

    return Material(
      color: theme.primaryBackground,
      elevation: 8.0,
      child: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: theme.alternate, width: 1.0),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.dashboard_rounded,
                label: 'Dashboard',
                isActive: active == 'Dashboard',
                onTap: () => _go(context, DashboardWidget.routeName,
                    withRouteParam: true),
              ),
              _NavItem(
                icon: Icons.calendar_month_rounded,
                label: 'Aulas',
                isActive: active == 'Aulas',
                onTap: () => _go(context, CalendarioAulasListaWidget.routeName,
                    withRouteParam: true),
              ),
              _NavItem(
                icon: Icons.school_outlined,
                label: 'Mural',
                isActive: active == 'Mural',
                onTap: () => _go(context, MuralWidget.routeName),
              ),
              _NavItem(
                icon: Icons.chat_rounded,
                label: 'Chat',
                isActive: active == 'Chat',
                onTap: () => _go(context, ChatWidget.routeName),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _go(BuildContext context, String routeName,
      {bool withRouteParam = false}) {
    context.pushNamed(
      routeName,
      queryParameters: withRouteParam
          ? {'route': serializeParam('', ParamType.String)}.withoutNulls
          : const {},
      extra: <String, dynamic>{
        '__transition_info__': TransitionInfo(
          hasTransition: true,
          transitionType: PageTransitionType.fade,
          duration: const Duration(milliseconds: 0),
        ),
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final color = isActive ? theme.primary : theme.secondaryText;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        splashColor: theme.primary.withOpacity(0.12),
        highlightColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 24.0),
              const SizedBox(height: 4.0),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.bodySmall.override(
                  font: GoogleFonts.inter(
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  ),
                  fontSize: 11.0,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: color,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
