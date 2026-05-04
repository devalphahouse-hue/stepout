import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'nova_conversa_model.dart';
export 'nova_conversa_model.dart';

class NovaConversaWidget extends StatefulWidget {
  const NovaConversaWidget({super.key});

  @override
  State<NovaConversaWidget> createState() => _NovaConversaWidgetState();
}

class _NovaConversaWidgetState extends State<NovaConversaWidget> {
  late NovaConversaModel _model;

  late final TextEditingController _searchController;
  late final FocusNode _searchFocus;
  String _query = '';
  String? _openingChatForId;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NovaConversaModel());
    _searchController = TextEditingController();
    _searchFocus = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  bool _matches(dynamic user) {
    if (_query.isEmpty) return true;
    final q = _query.toLowerCase();
    final nome =
        (getJsonField(user, r'''$.nome''')?.toString() ?? '').toLowerCase();
    final email =
        (getJsonField(user, r'''$.email''')?.toString() ?? '').toLowerCase();
    final role =
        (getJsonField(user, r'''$.role''')?.toString() ?? '').toLowerCase();
    return nome.contains(q) || email.contains(q) || role.contains(q);
  }

  Future<void> _openChatFor(dynamic usersItem) async {
    final theirId = getJsonField(usersItem, r'''$.id''').toString();
    safeSetState(() => _openingChatForId = theirId);
    try {
      _model.apiResultclt = await SupabaseGroup.buscarChatCall.call(
        pUserA: theirId,
        pUserB: currentUserUid,
        token: currentJwtToken,
      );

      if (SupabaseGroup.buscarChatCall
              .chatid((_model.apiResultclt?.jsonBody ?? '')) ==
          'false') {
        _model.criarchat = await ChatsTable().insert({
          'user1': currentUserUid,
          'user2': theirId,
        });
        FFAppState().chatId = _model.criarchat!.id;
      } else {
        FFAppState().chatId = SupabaseGroup.buscarChatCall
            .chatid((_model.apiResultclt?.jsonBody ?? ''))!;
      }
      if (!mounted) return;
      safeSetState(() {});
      context.goNamed(
        ChatWidget.routeName,
        extra: <String, dynamic>{
          '__transition_info__': const TransitionInfo(
            hasTransition: true,
            transitionType: PageTransitionType.fade,
            duration: Duration(milliseconds: 0),
          ),
        },
      );
    } finally {
      if (mounted) safeSetState(() => _openingChatForId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final isCompact = MediaQuery.sizeOf(context).width < kBreakpointSmall;

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: theme.alternate, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _Header(
              title: 'Nova conversa',
              subtitle: 'Selecione um contato para começar a conversar.',
              onClose: () => Navigator.of(context).pop(),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  isCompact ? 16 : 24, 0, isCompact ? 16 : 24, 12),
              child: _SearchPill(
                controller: _searchController,
                focusNode: _searchFocus,
                onChanged: (value) =>
                    safeSetState(() => _query = value.trim()),
                onClear: () {
                  _searchController.clear();
                  safeSetState(() => _query = '');
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<ApiCallResponse>(
                future: SupabaseGroup.listarContatosConversaCall.call(
                  token: currentJwtToken,
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: SizedBox(
                        width: 36,
                        height: 36,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(theme.primary),
                        ),
                      ),
                    );
                  }
                  final response = snapshot.data!;
                  final users = response.jsonBody.toList();
                  final visible = users.where(_matches).toList();

                  if (users.isEmpty) {
                    return const _EmptyState(
                      icon: Icons.people_outline_rounded,
                      title: 'Nenhum contato disponível',
                      message:
                          'Quando houver professores ou franquias vinculadas, eles aparecerão aqui.',
                    );
                  }
                  if (visible.isEmpty) {
                    return _EmptyState(
                      icon: Icons.search_off_rounded,
                      title: 'Sem resultados',
                      message: 'Não encontramos contatos para "$_query".',
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      isCompact ? 12 : 20,
                      4,
                      isCompact ? 12 : 20,
                      20,
                    ),
                    itemCount: visible.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final usersItem = visible[index];
                      final id = getJsonField(usersItem, r'''$.id''')
                              ?.toString() ??
                          '';
                      final isLoading = _openingChatForId == id;
                      return _ContactCard(
                        nome: getJsonField(usersItem, r'''$.nome''')
                                ?.toString() ??
                            'Contato',
                        email: getJsonField(usersItem, r'''$.email''')
                                ?.toString() ??
                            '',
                        role: getJsonField(usersItem, r'''$.role''')
                                ?.toString() ??
                            '',
                        avatarUrl: getJsonField(usersItem, r'''$.imagem_perfil''')
                            ?.toString(),
                        loading: isLoading,
                        compact: isCompact,
                        onTap: isLoading ? null : () => _openChatFor(usersItem),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.subtitle,
    required this.onClose,
  });

  final String title;
  final String subtitle;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 12, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: theme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.forum_rounded,
              color: theme.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.headlineSmall.override(
                    font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: theme.primaryText,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.bodySmall.override(
                    font: GoogleFonts.inter(),
                    fontSize: 13,
                    color: theme.secondaryText,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Fechar',
            onPressed: onClose,
            icon: Icon(Icons.close_rounded, color: theme.secondaryText),
            splashRadius: 22,
          ),
        ],
      ),
    );
  }
}

class _SearchPill extends StatelessWidget {
  const _SearchPill({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final hasText = controller.text.isNotEmpty;
    return Container(
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.alternate, width: 1.0),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        style: theme.bodyMedium.override(
          font: GoogleFonts.inter(),
          fontSize: 14,
          color: theme.primaryText,
          letterSpacing: 0,
        ),
        decoration: InputDecoration(
          hintText: 'Buscar por nome, e-mail ou tipo…',
          hintStyle: theme.bodyMedium.override(
            font: GoogleFonts.inter(),
            fontSize: 14,
            color: theme.secondaryText,
            letterSpacing: 0,
          ),
          prefixIcon:
              Icon(Icons.search_rounded, color: theme.secondaryText, size: 20),
          suffixIcon: hasText
              ? IconButton(
                  splashRadius: 18,
                  icon: Icon(Icons.close_rounded,
                      size: 18, color: theme.secondaryText),
                  onPressed: onClear,
                )
              : null,
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}

class _ContactCard extends StatefulWidget {
  const _ContactCard({
    required this.nome,
    required this.email,
    required this.role,
    required this.avatarUrl,
    required this.loading,
    required this.compact,
    required this.onTap,
  });

  final String nome;
  final String email;
  final String role;
  final String? avatarUrl;
  final bool loading;
  final bool compact;
  final VoidCallback? onTap;

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final initials = _initials(widget.nome);
    final fallbackAvatar =
        (widget.avatarUrl == null || widget.avatarUrl!.isEmpty)
            ? null
            : widget.avatarUrl;

    return MouseRegion(
      cursor: widget.onTap == null
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: _hover
              ? theme.primary.withValues(alpha: 0.04)
              : theme.primaryBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hover ? theme.primary.withValues(alpha: 0.35) : theme.alternate,
            width: 1.0,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: widget.compact ? 12 : 14,
          vertical: 12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _Avatar(url: fallbackAvatar, initials: initials),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.nome,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.primaryText,
                      letterSpacing: 0,
                    ),
                  ),
                  if (widget.email.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      widget.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.bodySmall.override(
                        font: GoogleFonts.inter(),
                        fontSize: 12.5,
                        color: theme.secondaryText,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                  if (widget.role.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _RoleChip(role: widget.role),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            _OpenChatButton(
              loading: widget.loading,
              onPressed: widget.onTap,
              compact: widget.compact,
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.url, required this.initials});

  final String? url;
  final String initials;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.primary.withValues(alpha: 0.10),
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: url == null
          ? Text(
              initials,
              style: theme.titleSmall.override(
                font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: theme.primary,
                letterSpacing: 0,
              ),
            )
          : Image.network(
              url!,
              fit: BoxFit.cover,
              width: 52,
              height: 52,
              errorBuilder: (_, __, ___) => Text(
                initials,
                style: theme.titleSmall.override(
                  font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: theme.primary,
                  letterSpacing: 0,
                ),
              ),
            ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({required this.role});

  final String role;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final normalized = role.toLowerCase();
    Color bg;
    Color fg;
    IconData icon;
    String label;
    switch (normalized) {
      case 'professor':
        bg = const Color(0xFFFFF4E5);
        fg = const Color(0xFFB45309);
        icon = Icons.school_rounded;
        label = 'Professor';
        break;
      case 'franquia':
        bg = theme.primary.withValues(alpha: 0.12);
        fg = theme.primary;
        icon = Icons.business_rounded;
        label = 'Franquia';
        break;
      case 'aluno':
        bg = const Color(0xFFEEF2FF);
        fg = const Color(0xFF4338CA);
        icon = Icons.person_rounded;
        label = 'Aluno';
        break;
      default:
        bg = theme.alternate;
        fg = theme.secondaryText;
        icon = Icons.label_rounded;
        label = role;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.labelSmall.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: fg,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _OpenChatButton extends StatefulWidget {
  const _OpenChatButton({
    required this.loading,
    required this.onPressed,
    required this.compact,
  });

  final bool loading;
  final VoidCallback? onPressed;
  final bool compact;

  @override
  State<_OpenChatButton> createState() => _OpenChatButtonState();
}

class _OpenChatButtonState extends State<_OpenChatButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final disabled = widget.onPressed == null;
    return MouseRegion(
      cursor: disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: disabled
              ? theme.primary.withValues(alpha: 0.5)
              : (_hover ? theme.primary.withValues(alpha: 0.92) : theme.primary),
          borderRadius: BorderRadius.circular(10),
          boxShadow: _hover && !disabled
              ? [
                  BoxShadow(
                    color: theme.primary.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : const [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: widget.onPressed,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.compact ? 12 : 14,
                vertical: 10,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.loading)
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  else
                    const Icon(Icons.send_rounded,
                        size: 14, color: Colors.white),
                  if (!widget.compact) ...[
                    const SizedBox(width: 6),
                    Text(
                      widget.loading ? 'Abrindo…' : 'Abrir chat',
                      style: FlutterFlowTheme.of(context).titleSmall.override(
                            font: GoogleFonts.interTight(
                                fontWeight: FontWeight.w600),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: theme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: theme.primary, size: 28),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.titleMedium.override(
                font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: theme.primaryText,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.bodySmall.override(
                font: GoogleFonts.inter(),
                fontSize: 13,
                color: theme.secondaryText,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
