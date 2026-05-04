import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'esqueceu_senha_model.dart';
export 'esqueceu_senha_model.dart';

class EsqueceuSenhaWidget extends StatefulWidget {
  const EsqueceuSenhaWidget({super.key});

  static String routeName = 'EsqueceuSenha';
  static String routePath = '/esqueceuSenha';

  @override
  State<EsqueceuSenhaWidget> createState() => _EsqueceuSenhaWidgetState();
}

class _EsqueceuSenhaWidgetState extends State<EsqueceuSenhaWidget> {
  late EsqueceuSenhaModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _sent = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EsqueceuSenhaModel());

    _model.emailAddressTextController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();

    _model.emailAddressTextControllerValidator = (context, val) {
      final value = val?.trim() ?? '';
      if (value.isEmpty) return 'Informe seu e-mail.';
      final emailRegex = RegExp(r'^[\w\.\-+]+@[\w\-]+(\.[\w\-]+)+$');
      if (!emailRegex.hasMatch(value)) return 'E-mail inválido.';
      return null;
    };

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _onSend() async {
    if (_loading) return;
    if (_formKey.currentState?.validate() != true) return;

    safeSetState(() => _loading = true);
    try {
      await authManager.resetPassword(
        email: _model.emailAddressTextController.text.trim(),
        context: context,
        redirectTo: 'https://aluno.stepout.com.br/login',
      );
      if (!mounted) return;
      safeSetState(() => _sent = true);
    } finally {
      if (mounted) safeSetState(() => _loading = false);
    }
  }

  void _backToLogin() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      context.goNamed(LoginWidget.routeName);
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
                child: _Panel(
                  formKey: _formKey,
                  controller: _model.emailAddressTextController!,
                  focusNode: _model.emailAddressFocusNode!,
                  validator: _model.emailAddressTextControllerValidator!,
                  loading: _loading,
                  sent: _sent,
                  onSend: _onSend,
                  onBack: _backToLogin,
                  onRetry: () => safeSetState(() => _sent = false),
                ),
              ),
              if (showHero)
                Expanded(
                  flex: 1,
                  child: const _HeroPanel(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.formKey,
    required this.controller,
    required this.focusNode,
    required this.validator,
    required this.loading,
    required this.sent,
    required this.onSend,
    required this.onBack,
    required this.onRetry,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? Function(BuildContext, String?) validator;
  final bool loading;
  final bool sent;
  final VoidCallback onSend;
  final VoidCallback onBack;
  final VoidCallback onRetry;

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
                  sent ? 'Confira seu e-mail' : 'Esqueceu sua senha?',
                  textAlign: TextAlign.center,
                  style: theme.headlineMedium.override(
                    font: GoogleFonts.interTight(fontWeight: FontWeight.w800),
                    fontSize: isCompact ? 24.0 : 28.0,
                    fontWeight: FontWeight.w800,
                    color: theme.primaryText,
                    letterSpacing: 0.0,
                  ),
                ),
                const SizedBox(height: 6.0),
                Text(
                  sent
                      ? 'Enviamos um link de redefinição. Verifique sua caixa de entrada.'
                      : 'Informe seu e-mail e enviaremos um link para redefinir sua senha.',
                  textAlign: TextAlign.center,
                  style: theme.bodyMedium.override(
                    font: GoogleFonts.inter(),
                    fontSize: 14.0,
                    color: theme.secondaryText,
                    letterSpacing: 0.0,
                    lineHeight: 1.4,
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
                  child: sent
                      ? _SuccessState(
                          email: controller.text.trim(),
                          onBack: onBack,
                          onRetry: onRetry,
                        )
                      : _RequestState(
                          formKey: formKey,
                          controller: controller,
                          focusNode: focusNode,
                          validator: validator,
                          loading: loading,
                          onSend: onSend,
                        ),
                ),
                const SizedBox(height: 20.0),
                if (!sent)
                  Center(
                    child: TextButton.icon(
                      onPressed: onBack,
                      icon: Icon(Icons.arrow_back_rounded,
                          color: theme.primary, size: 16.0),
                      label: Text(
                        'Voltar ao login',
                        style: theme.bodyMedium.override(
                          font: GoogleFonts.inter(
                              fontWeight: FontWeight.w600),
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                          color: theme.primary,
                          letterSpacing: 0.0,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        minimumSize: const Size(0, 36),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
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

class _RequestState extends StatelessWidget {
  const _RequestState({
    required this.formKey,
    required this.controller,
    required this.focusNode,
    required this.validator,
    required this.loading,
    required this.onSend,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? Function(BuildContext, String?) validator;
  final bool loading;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _LabeledField(
            controller: controller,
            focusNode: focusNode,
            validator: validator,
            label: 'E-mail',
            hint: 'voce@exemplo.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => onSend(),
          ),
          const SizedBox(height: 16.0),
          _PrimaryButton(
            label: loading ? 'Enviando…' : 'Enviar link',
            loading: loading,
            onTap: onSend,
          ),
        ],
      ),
    );
  }
}

class _SuccessState extends StatelessWidget {
  const _SuccessState({
    required this.email,
    required this.onBack,
    required this.onRetry,
  });

  final String email;
  final VoidCallback onBack;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Container(
            width: 64.0,
            height: 64.0,
            decoration: BoxDecoration(
              color: theme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.mark_email_read_rounded,
              color: theme.primary,
              size: 32.0,
            ),
          ),
        ),
        const SizedBox(height: 14.0),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(),
              fontSize: 14.0,
              color: theme.secondaryText,
              letterSpacing: 0.0,
              lineHeight: 1.45,
            ),
            children: [
              const TextSpan(text: 'Enviado para '),
              TextSpan(
                text: email,
                style: theme.bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w700),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                  color: theme.primaryText,
                  letterSpacing: 0.0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18.0),
        _PrimaryButton(
          label: 'Voltar ao login',
          loading: false,
          onTap: onBack,
        ),
        const SizedBox(height: 6.0),
        TextButton(
          onPressed: onRetry,
          style: TextButton.styleFrom(
            foregroundColor: theme.primary,
            padding: const EdgeInsets.symmetric(
                horizontal: 8.0, vertical: 8.0),
          ),
          child: Text(
            'Não recebeu? Reenviar',
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              fontSize: 13.0,
              fontWeight: FontWeight.w600,
              color: theme.primary,
              letterSpacing: 0.0,
            ),
          ),
        ),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.controller,
    required this.focusNode,
    required this.validator,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String? Function(BuildContext, String?) validator;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

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
          onFieldSubmitted: onSubmitted,
          validator: (val) => validator(context, val),
          style: theme.bodyMedium.override(
            font: GoogleFonts.inter(),
            fontSize: 15.0,
            color: theme.primaryText,
            letterSpacing: 0.0,
          ),
          cursorColor: theme.primary,
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

class _PrimaryButton extends StatefulWidget {
  const _PrimaryButton({
    required this.label,
    required this.loading,
    required this.onTap,
  });

  final String label;
  final bool loading;
  final VoidCallback onTap;

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

class _HeroPanel extends StatelessWidget {
  const _HeroPanel();

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
                    Icons.lock_reset_rounded,
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
                        'Recuperação segura',
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
                        'Em poucos minutos você volta para suas aulas.',
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
