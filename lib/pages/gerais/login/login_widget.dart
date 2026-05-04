import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_model.dart';
export 'login_model.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  static String routeName = 'Login';
  static String routePath = '/login';

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late LoginModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginModel());

    _model.emailAddressTextController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();
    _model.passwordTextController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();

    _model.emailAddressTextControllerValidator = (context, val) {
      final value = val?.trim() ?? '';
      if (value.isEmpty) return 'Informe seu e-mail.';
      final emailRegex = RegExp(r'^[\w\.\-+]+@[\w\-]+(\.[\w\-]+)+$');
      if (!emailRegex.hasMatch(value)) return 'E-mail inválido.';
      return null;
    };

    _model.passwordTextControllerValidator = (context, val) {
      if (val == null || val.isEmpty) return 'Informe sua senha.';
      if (val.length < 6) return 'A senha deve ter pelo menos 6 caracteres.';
      return null;
    };

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (_loading) return;
    if (_model.formKey.currentState?.validate() != true) return;

    safeSetState(() => _loading = true);
    try {
      GoRouter.of(context).prepareAuthEvent();
      final user = await authManager.signInWithEmail(
        context,
        _model.emailAddressTextController.text,
        _model.passwordTextController.text,
      );
      if (user == null) return;

      _model.userlogado = await MetaAlunosTable().queryRows(
        queryFn: (q) => q.eqOrNull('user_id', currentUserUid),
      );

      if ((_model.userlogado?.length ?? 0) != 0) {
        FFAppState().idfranquia =
            _model.userlogado?.firstOrNull?.franquiaId ?? '';
        safeSetState(() {});

        _model.fraquiaativa = await FranquiasTable().queryRows(
          queryFn: (q) => q.eqOrNull(
              'id', _model.userlogado?.firstOrNull?.franquiaId),
        );

        if (!context.mounted) return;
        if (_model.fraquiaativa?.firstOrNull?.statusFranquia == true) {
          context.pushNamedAuth(
            DashboardWidget.routeName,
            context.mounted,
            queryParameters: {
              'route': serializeParam('', ParamType.String),
            }.withoutNulls,
            extra: <String, dynamic>{
              '__transition_info__': TransitionInfo(
                hasTransition: true,
                transitionType: PageTransitionType.fade,
                duration: const Duration(milliseconds: 0),
              ),
            },
          );
        } else {
          context.pushNamedAuth(
            FranquiaInativaWidget.routeName,
            context.mounted,
            extra: <String, dynamic>{
              '__transition_info__': TransitionInfo(
                hasTransition: true,
                transitionType: PageTransitionType.fade,
                duration: const Duration(milliseconds: 0),
              ),
            },
          );
        }
      } else {
        GoRouter.of(context).prepareAuthEvent();
        await authManager.signOut();
        GoRouter.of(context).clearRedirectLocation();
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sem permissão de acesso.',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).primaryBackground,
              ),
            ),
            duration: const Duration(milliseconds: 4000),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    } finally {
      if (mounted) safeSetState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final showHero = width >= kBreakpointMedium;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.secondaryBackground,
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: _LoginFormPanel(
                  formKey: _model.formKey,
                  emailController: _model.emailAddressTextController!,
                  emailFocusNode: _model.emailAddressFocusNode!,
                  passwordController: _model.passwordTextController!,
                  passwordFocusNode: _model.passwordFocusNode!,
                  passwordVisible: _model.passwordVisibility,
                  emailValidator:
                      _model.emailAddressTextControllerValidator!,
                  passwordValidator:
                      _model.passwordTextControllerValidator!,
                  loading: _loading,
                  onTogglePassword: () => safeSetState(
                      () => _model.passwordVisibility =
                          !_model.passwordVisibility),
                  onForgot: () =>
                      context.pushNamed(EsqueceuSenhaWidget.routeName),
                  onLogin: _onLogin,
                ),
              ),
              if (showHero)
                Expanded(
                  flex: 1,
                  child: const _LoginHeroPanel(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginFormPanel extends StatelessWidget {
  const _LoginFormPanel({
    required this.formKey,
    required this.emailController,
    required this.emailFocusNode,
    required this.passwordController,
    required this.passwordFocusNode,
    required this.passwordVisible,
    required this.emailValidator,
    required this.passwordValidator,
    required this.loading,
    required this.onTogglePassword,
    required this.onForgot,
    required this.onLogin,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final FocusNode emailFocusNode;
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  final bool passwordVisible;
  final String? Function(BuildContext, String?) emailValidator;
  final String? Function(BuildContext, String?) passwordValidator;
  final bool loading;
  final VoidCallback onTogglePassword;
  final VoidCallback onForgot;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < kBreakpointSmall;

    return Container(
      color: theme.secondaryBackground,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 24.0 : 40.0, vertical: 32.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420.0),
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24.0),
                      child: Image.asset(
                        'assets/images/Logo.png',
                        width: isCompact ? 140.0 : 168.0,
                        height: isCompact ? 140.0 : 168.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    'Portal do Aluno',
                    textAlign: TextAlign.center,
                    style: theme.headlineMedium.override(
                      font:
                          GoogleFonts.interTight(fontWeight: FontWeight.w800),
                      fontSize: isCompact ? 24.0 : 28.0,
                      fontWeight: FontWeight.w800,
                      color: theme.primaryText,
                      letterSpacing: 0.0,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    'Faça login para acessar suas aulas, conteúdos e cobranças.',
                    textAlign: TextAlign.center,
                    style: theme.bodyMedium.override(
                      font: GoogleFonts.inter(),
                      fontSize: 14.0,
                      color: theme.secondaryText,
                      letterSpacing: 0.0,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isCompact ? 18.0 : 24.0,
                      vertical: isCompact ? 20.0 : 24.0,
                    ),
                    decoration: BoxDecoration(
                      color: theme.primaryBackground,
                      borderRadius: BorderRadius.circular(18.0),
                      border:
                          Border.all(color: theme.alternate, width: 1.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _LoginField(
                          controller: emailController,
                          focusNode: emailFocusNode,
                          label: 'E-mail',
                          hint: 'voce@exemplo.com',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: emailValidator,
                        ),
                        const SizedBox(height: 14.0),
                        _LoginField(
                          controller: passwordController,
                          focusNode: passwordFocusNode,
                          label: 'Senha',
                          hint: '••••••••',
                          icon: Icons.lock_outline_rounded,
                          obscureText: !passwordVisible,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => onLogin(),
                          suffixIcon: passwordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          onSuffixTap: onTogglePassword,
                          validator: passwordValidator,
                        ),
                        const SizedBox(height: 6.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: onForgot,
                            style: TextButton.styleFrom(
                              foregroundColor: theme.primary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              minimumSize: const Size(0, 32),
                              tapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Esqueceu sua senha?',
                              style: theme.bodyMedium.override(
                                font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600),
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600,
                                color: theme.primary,
                                letterSpacing: 0.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14.0),
                        _PrimaryLoginButton(
                          label: loading ? 'Entrando…' : 'Entrar',
                          loading: loading,
                          onTap: onLogin,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  _FooterHelp(theme: theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginField extends StatelessWidget {
  const _LoginField({
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hint,
    required this.icon,
    required this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.suffixIcon,
    this.onSuffixTap,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final ValueChanged<String>? onSubmitted;
  final String? Function(BuildContext, String?) validator;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
          child: Text(
            label,
            style: theme.labelMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: theme.secondaryText,
              letterSpacing: 0.2,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          onFieldSubmitted: onSubmitted,
          style: theme.bodyMedium.override(
            font: GoogleFonts.inter(),
            fontSize: 15.0,
            color: theme.primaryText,
            letterSpacing: 0.0,
          ),
          cursorColor: theme.primary,
          validator: (val) => validator(context, val),
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            hintStyle: theme.bodyMedium.override(
              font: GoogleFonts.inter(),
              fontSize: 15.0,
              color: theme.secondaryText,
              letterSpacing: 0.0,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 14.0, right: 10.0),
              child: Icon(icon, color: theme.secondaryText, size: 20.0),
            ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            suffixIcon: suffixIcon == null
                ? null
                : IconButton(
                    onPressed: onSuffixTap,
                    icon: Icon(
                      suffixIcon,
                      color: theme.secondaryText,
                      size: 20.0,
                    ),
                  ),
            filled: true,
            fillColor: theme.secondaryBackground,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14.0, vertical: 14.0),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.alternate, width: 1.0),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.primary, width: 1.5),
              borderRadius: BorderRadius.circular(12.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.error, width: 1.0),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.error, width: 1.5),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryLoginButton extends StatefulWidget {
  const _PrimaryLoginButton({
    required this.label,
    required this.loading,
    required this.onTap,
  });

  final String label;
  final bool loading;
  final VoidCallback onTap;

  @override
  State<_PrimaryLoginButton> createState() => _PrimaryLoginButtonState();
}

class _PrimaryLoginButtonState extends State<_PrimaryLoginButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final base = theme.primary;
    final bg =
        (_hovered || _pressed) ? base.withOpacity(0.88) : base;

    return MouseRegion(
      cursor: widget.loading
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) =>
            widget.loading ? null : setState(() => _pressed = true),
        onTapUp: (_) =>
            widget.loading ? null : setState(() => _pressed = false),
        onTapCancel: () =>
            widget.loading ? null : setState(() => _pressed = false),
        onTap: widget.loading ? null : widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            height: 50.0,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: base.withOpacity(0.18),
                  blurRadius: 18.0,
                  offset: const Offset(0, 6.0),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.loading) ...[
                  const SizedBox(
                    width: 18.0,
                    height: 18.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                ],
                Text(
                  widget.label,
                  style: theme.titleSmall.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w700),
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700,
                    color: theme.info,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterHelp extends StatelessWidget {
  const _FooterHelp({required this.theme});
  final FlutterFlowTheme theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 1.0,
          color: theme.alternate,
        ),
        const SizedBox(height: 16.0),
        Text(
          'Precisa de ajuda?',
          style: theme.bodyMedium.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.w600),
            fontSize: 13.0,
            fontWeight: FontWeight.w600,
            color: theme.primaryText,
            letterSpacing: 0.0,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          'Entre em contato com a sua escola para acessar suas credenciais.',
          textAlign: TextAlign.center,
          style: theme.bodySmall.override(
            font: GoogleFonts.inter(),
            fontSize: 12.5,
            color: theme.secondaryText,
            letterSpacing: 0.0,
            lineHeight: 1.4,
          ),
        ),
      ],
    );
  }
}

class _LoginHeroPanel extends StatelessWidget {
  const _LoginHeroPanel();

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/bannerlogin.png',
          fit: BoxFit.cover,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                theme.primary.withOpacity(0.55),
                theme.primary.withOpacity(0.0),
              ],
            ),
          ),
        ),
        Positioned(
          left: 32.0,
          right: 32.0,
          bottom: 32.0,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 18.0, vertical: 14.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.92),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              children: [
                Container(
                  width: 38.0,
                  height: 38.0,
                  decoration: BoxDecoration(
                    color: theme.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.school_rounded,
                    color: theme.primary,
                    size: 20.0,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Step Out English Club',
                        style: theme.titleSmall.override(
                          font: GoogleFonts.interTight(
                              fontWeight: FontWeight.w700),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: theme.primaryText,
                          letterSpacing: 0.0,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        'Aprenda inglês com aulas ao vivo, conteúdos e turmas.',
                        style: theme.bodySmall.override(
                          font: GoogleFonts.inter(),
                          fontSize: 12.0,
                          color: theme.secondaryText,
                          letterSpacing: 0.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
