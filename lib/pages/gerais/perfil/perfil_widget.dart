import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/upload_data.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'perfil_model.dart';
export 'perfil_model.dart';

class PerfilWidget extends StatefulWidget {
  const PerfilWidget({super.key, this.route});

  final String? route;

  static String routeName = 'Perfil';
  static String routePath = '/perfil';

  @override
  State<PerfilWidget> createState() => _PerfilWidgetState();
}

class _PerfilWidgetState extends State<PerfilWidget> {
  late PerfilModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const String _avatarFallback =
      'https://qmfitknztvxvzpgjyvxf.supabase.co/storage/v1/object/public/geral/Ellipse%2051.png';

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PerfilModel());

    _model.textFieldNomeFocusNode ??= FocusNode();
    _model.textFieldEmail1FocusNode ??= FocusNode();
    _model.textFieldTelefoneFocusNode ??= FocusNode();
    _model.textFieldTelefoneMask =
        MaskTextInputFormatter(mask: '(##) #####-####');
    _model.textFieldCPFFocusNode ??= FocusNode();
    _model.textFieldCPFMask = MaskTextInputFormatter(mask: '###.###.###-##');
    _model.textFieldDNascFocusNode ??= FocusNode();
    _model.textFieldDNascMask = MaskTextInputFormatter(mask: '##/##/####');
    _model.textFieldNocionFocusNode ??= FocusNode();
    _model.textFieldFocusNode ??= FocusNode();
    _model.textFieldMask = MaskTextInputFormatter(mask: '#####-###');
    _model.textFieldPaisFocusNode ??= FocusNode();
    _model.textFieldEnderecoFocusNode ??= FocusNode();
    _model.textFieldBairroFocusNode ??= FocusNode();
    _model.textFieldNumeroFocusNode ??= FocusNode();
    _model.textFieldCompleFocusNode ??= FocusNode();
    _model.textFieldCidadeFocusNode ??= FocusNode();
    _model.textFieldUFFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _ensureControllers(UsersRow? row) {
    _model.textFieldNomeTextController ??=
        TextEditingController(text: row?.nome);
    _model.textFieldEmail1TextController ??=
        TextEditingController(text: row?.email);
    _model.textFieldTelefoneTextController ??=
        TextEditingController(text: row?.telefone);
    _model.textFieldCPFTextController ??=
        TextEditingController(text: row?.cpf);
    _model.textFieldDNascTextController ??=
        TextEditingController(text: row?.dataNascimento);
    _model.textFieldNocionTextController ??=
        TextEditingController(text: row?.nacionalidade);
    _model.textController7 ??= TextEditingController(text: row?.cep);
    _model.textFieldPaisTextController ??=
        TextEditingController(text: row?.pais);
    _model.textFieldEnderecoTextController ??=
        TextEditingController(text: row?.endereco);
    _model.textFieldBairroTextController ??=
        TextEditingController(text: row?.bairro);
    _model.textFieldNumeroTextController ??=
        TextEditingController(text: row?.numero);
    _model.textFieldCompleTextController ??=
        TextEditingController(text: row?.complemento);
    _model.textFieldCidadeTextController ??=
        TextEditingController(text: row?.cidade);
    _model.textFieldUFTextController ??= TextEditingController(text: row?.uf);
  }

  Future<void> _runCepLookup() async {
    final cep = _model.textController7?.text ?? '';
    if (cep.length < 8) return;
    _model.resultCEP = await BuscarCEPCall.call(cep: cep);
    if (!mounted) return;
    if (_model.resultCEP?.succeeded ?? false) {
      safeSetState(() {
        _model.textFieldPaisTextController?.text = 'Brasil';
        _model.textFieldEnderecoTextController?.text =
            BuscarCEPCall.rua(_model.resultCEP?.jsonBody ?? '') ?? '';
        _model.textFieldBairroTextController?.text =
            BuscarCEPCall.bairro(_model.resultCEP?.jsonBody ?? '') ?? '';
        _model.textFieldCidadeTextController?.text =
            BuscarCEPCall.cidade(_model.resultCEP?.jsonBody ?? '') ?? '';
        _model.textFieldUFTextController?.text =
            BuscarCEPCall.uf(_model.resultCEP?.jsonBody ?? '') ?? '';
      });
    } else {
      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            content:
                Text((_model.resultCEP?.jsonBody ?? '').toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext),
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _pickPhoto() async {
    final selectedMedia = await selectMediaWithSourceBottomSheet(
      context: context,
      storageFolderPath: 'imagens_perfil',
      allowPhoto: true,
    );
    if (selectedMedia == null ||
        !selectedMedia.every(
            (m) => validateFileFormat(m.storagePath, context))) {
      return;
    }

    safeSetState(() =>
        _model.isDataUploading_uploadSubsFotoPerfilFranquia = true);
    var selectedUploadedFiles = <FFUploadedFile>[];
    var downloadUrls = <String>[];
    try {
      selectedUploadedFiles = selectedMedia
          .map((m) => FFUploadedFile(
                name: m.storagePath.split('/').last,
                bytes: m.bytes,
                height: m.dimensions?.height,
                width: m.dimensions?.width,
                blurHash: m.blurHash,
                originalFilename: m.originalFilename,
              ))
          .toList();
      downloadUrls = await uploadSupabaseStorageFiles(
        bucketName: 'geral',
        selectedFiles: selectedMedia,
      );
    } finally {
      _model.isDataUploading_uploadSubsFotoPerfilFranquia = false;
    }

    if (selectedUploadedFiles.length == selectedMedia.length &&
        downloadUrls.length == selectedMedia.length) {
      safeSetState(() {
        _model.uploadedLocalFile_uploadSubsFotoPerfilFranquia =
            selectedUploadedFiles.first;
        _model.uploadedFileUrl_uploadSubsFotoPerfilFranquia =
            downloadUrls.first;
      });
    } else {
      safeSetState(() {});
    }
  }

  Future<void> _save(UsersRow? row) async {
    if (_saving) return;
    safeSetState(() => _saving = true);
    try {
      final imagemPerfilNova =
          _model.uploadedFileUrl_uploadSubsFotoPerfilFranquia;
      await UsersTable().update(
        data: {
          'nome': _model.textFieldNomeTextController.text,
          'email': _model.textFieldEmail1TextController.text,
          'telefone': _model.textFieldTelefoneTextController.text,
          'cpf': _model.textFieldCPFTextController.text,
          'data_nascimento': _model.textFieldDNascTextController.text,
          'nacionalidade': _model.textFieldNocionTextController.text,
          'cep': _model.textController7.text,
          'pais': _model.textFieldPaisTextController.text,
          'endereco': _model.textFieldEnderecoTextController.text,
          'bairro': _model.textFieldBairroTextController.text,
          'numero': _model.textFieldNumeroTextController.text,
          'complemento': _model.textFieldCompleTextController.text,
          'cidade': _model.textFieldCidadeTextController.text,
          'uf': _model.textFieldUFTextController.text,
          if (imagemPerfilNova.isNotEmpty) 'imagem_perfil': imagemPerfilNova,
        },
        matchingRows: (rows) => rows.eqOrNull('id', currentUserUid),
      );

      _model.apiResult2px = await SupabaseGroup.updateMyAuthEmailCall.call(
        email: _model.textFieldEmail1TextController.text,
        token: currentJwtToken,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Perfil atualizado com sucesso.'),
          backgroundColor: FlutterFlowTheme.of(context).primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Não foi possível salvar: $e'),
          backgroundColor: FlutterFlowTheme.of(context).error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) safeSetState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final theme = FlutterFlowTheme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= kBreakpointMedium;

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
          child: const SidebarWidget(route: 'Perfil'),
        ),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isWide)
                const SizedBox(
                  width: 300.0,
                  child: SidebarWidget(route: 'Perfil'),
                ),
              Expanded(
                child: FutureBuilder<List<UsersRow>>(
                  future: UsersTable().querySingleRow(
                    queryFn: (q) => q.eqOrNull('id', currentUserUid),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Erro ao carregar dados.',
                            style: theme.bodyMedium),
                      );
                    }
                    if (!snapshot.hasData) {
                      return Center(
                        child: SizedBox(
                          width: 36.0,
                          height: 36.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 3.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(theme.primary),
                          ),
                        ),
                      );
                    }
                    final row = snapshot.data!.isNotEmpty
                        ? snapshot.data!.first
                        : null;
                    _ensureControllers(row);

                    final fullName =
                        (row?.nome ?? currentUserDisplayName).trim();
                    final firstName = fullName.isNotEmpty
                        ? fullName.split(' ').first
                        : '';
                    final initial = firstName.isNotEmpty
                        ? firstName.substring(0, 1).toUpperCase()
                        : (currentUserEmail.isNotEmpty
                            ? currentUserEmail.substring(0, 1).toUpperCase()
                            : '?');

                    final uploadedUrl =
                        _model.uploadedFileUrl_uploadSubsFotoPerfilFranquia;
                    final imageUrl = uploadedUrl.isNotEmpty
                        ? uploadedUrl
                        : (row?.imagemPerfil != null &&
                                row!.imagemPerfil!.isNotEmpty)
                            ? row.imagemPerfil!
                            : _avatarFallback;

                    return SingleChildScrollView(
                      primary: false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          responsivePadding(context),
                          responsivePadding(context),
                          responsivePadding(context),
                          responsivePadding(context) + 24.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _Header(
                              isWide: isWide,
                              saving: _saving,
                              onMenu: () =>
                                  scaffoldKey.currentState?.openDrawer(),
                              onSave: () => _save(row),
                            ),
                            const SizedBox(height: 20.0),
                            _IdentityCard(
                              imageUrl: imageUrl,
                              initial: initial,
                              fullName: fullName,
                              email: row?.email ?? currentUserEmail,
                              isUploading: _model
                                  .isDataUploading_uploadSubsFotoPerfilFranquia,
                              onPick: _pickPhoto,
                            ),
                            const SizedBox(height: 16.0),
                            _Section(
                              icon: Icons.badge_outlined,
                              title: 'Dados pessoais',
                              subtitle:
                                  'Suas informações de contato e identificação.',
                              child: _FieldGrid(
                                fields: [
                                  _FieldSpec(
                                    label: 'Nome',
                                    hint: 'Seu nome completo',
                                    controller: _model
                                        .textFieldNomeTextController!,
                                    focusNode: _model.textFieldNomeFocusNode,
                                    span: 2,
                                  ),
                                  _FieldSpec(
                                    label: 'E-mail',
                                    hint: 'voce@exemplo.com',
                                    controller: _model
                                        .textFieldEmail1TextController!,
                                    focusNode:
                                        _model.textFieldEmail1FocusNode,
                                    keyboardType:
                                        TextInputType.emailAddress,
                                    span: 2,
                                  ),
                                  _FieldSpec(
                                    label: 'Telefone',
                                    hint: '(00) 00000-0000',
                                    controller: _model
                                        .textFieldTelefoneTextController!,
                                    focusNode:
                                        _model.textFieldTelefoneFocusNode,
                                    keyboardType: TextInputType.phone,
                                    formatters: [
                                      _model.textFieldTelefoneMask
                                    ],
                                  ),
                                  _FieldSpec(
                                    label: 'CPF',
                                    hint: '000.000.000-00',
                                    controller: _model
                                        .textFieldCPFTextController!,
                                    focusNode: _model.textFieldCPFFocusNode,
                                    keyboardType: TextInputType.number,
                                    formatters: [_model.textFieldCPFMask],
                                  ),
                                  _FieldSpec(
                                    label: 'Data de nascimento',
                                    hint: 'DD/MM/AAAA',
                                    controller: _model
                                        .textFieldDNascTextController!,
                                    focusNode:
                                        _model.textFieldDNascFocusNode,
                                    keyboardType: TextInputType.datetime,
                                    formatters: [_model.textFieldDNascMask],
                                  ),
                                  _FieldSpec(
                                    label: 'Nacionalidade',
                                    hint: 'Ex.: Brasileiro(a)',
                                    controller: _model
                                        .textFieldNocionTextController!,
                                    focusNode:
                                        _model.textFieldNocionFocusNode,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            _Section(
                              icon: Icons.location_on_outlined,
                              title: 'Endereço',
                              subtitle:
                                  'O CEP preenche o endereço automaticamente.',
                              child: _FieldGrid(
                                fields: [
                                  _FieldSpec(
                                    label: 'CEP',
                                    hint: '00000-000',
                                    controller: _model.textController7!,
                                    focusNode: _model.textFieldFocusNode,
                                    keyboardType: TextInputType.number,
                                    formatters: [_model.textFieldMask],
                                    suffixIcon: Icons.search_rounded,
                                    onChanged: () {
                                      EasyDebounce.debounce(
                                        '_model.textController7',
                                        const Duration(milliseconds: 600),
                                        _runCepLookup,
                                      );
                                    },
                                  ),
                                  _FieldSpec(
                                    label: 'País',
                                    hint: 'Brasil',
                                    controller: _model
                                        .textFieldPaisTextController!,
                                    focusNode:
                                        _model.textFieldPaisFocusNode,
                                  ),
                                  _FieldSpec(
                                    label: 'Endereço',
                                    hint: 'Rua, avenida…',
                                    controller: _model
                                        .textFieldEnderecoTextController!,
                                    focusNode:
                                        _model.textFieldEnderecoFocusNode,
                                    span: 2,
                                  ),
                                  _FieldSpec(
                                    label: 'Bairro',
                                    hint: 'Seu bairro',
                                    controller: _model
                                        .textFieldBairroTextController!,
                                    focusNode:
                                        _model.textFieldBairroFocusNode,
                                  ),
                                  _FieldSpec(
                                    label: 'Número',
                                    hint: '123',
                                    controller: _model
                                        .textFieldNumeroTextController!,
                                    focusNode:
                                        _model.textFieldNumeroFocusNode,
                                    keyboardType: TextInputType.number,
                                  ),
                                  _FieldSpec(
                                    label: 'Complemento',
                                    hint: 'Apto, bloco, sala…',
                                    controller: _model
                                        .textFieldCompleTextController!,
                                    focusNode:
                                        _model.textFieldCompleFocusNode,
                                    span: 2,
                                  ),
                                  _FieldSpec(
                                    label: 'Cidade',
                                    hint: 'Sua cidade',
                                    controller: _model
                                        .textFieldCidadeTextController!,
                                    focusNode:
                                        _model.textFieldCidadeFocusNode,
                                  ),
                                  _FieldSpec(
                                    label: 'UF',
                                    hint: 'PR',
                                    controller: _model
                                        .textFieldUFTextController!,
                                    focusNode: _model.textFieldUFFocusNode,
                                    keyboardType: TextInputType.text,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24.0),
                            _SaveButton(
                              onTap: () => _save(row),
                              loading: _saving,
                              block: !isWide,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.isWide,
    required this.saving,
    required this.onMenu,
    required this.onSave,
  });

  final bool isWide;
  final bool saving;
  final VoidCallback onMenu;
  final VoidCallback onSave;

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
          child: Icon(Icons.account_circle_rounded,
              color: theme.primary, size: 28.0),
        ),
        const SizedBox(width: 14.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Meu perfil',
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
                'Atualize seus dados pessoais e endereço.',
                style: theme.bodyMedium.override(
                  font: GoogleFonts.inter(),
                  fontSize: 14.0,
                  color: theme.secondaryText,
                  letterSpacing: 0.0,
                ),
              ),
            ],
          ),
        ),
        if (!isWide)
          _IconAction(icon: Icons.menu_open_rounded, filled: true, onTap: onMenu)
        else
          _SaveButton(onTap: onSave, loading: saving, block: false),
      ],
    );
  }
}

class _IdentityCard extends StatelessWidget {
  const _IdentityCard({
    required this.imageUrl,
    required this.initial,
    required this.fullName,
    required this.email,
    required this.isUploading,
    required this.onPick,
  });

  final String imageUrl;
  final String initial;
  final String fullName;
  final String email;
  final bool isUploading;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: theme.alternate),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 84.0,
                height: 84.0,
                decoration: BoxDecoration(
                  color: theme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(imageUrl),
                  ),
                  border: Border.all(
                    color: theme.alternate,
                    width: 1.0,
                  ),
                ),
              ),
              if (isUploading)
                Container(
                  width: 84.0,
                  height: 84.0,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 18.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  fullName.isNotEmpty ? fullName : 'Sem nome',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.titleMedium.override(
                    font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: theme.primaryText,
                    letterSpacing: 0.0,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.bodyMedium.override(
                    font: GoogleFonts.inter(),
                    fontSize: 14.0,
                    color: theme.secondaryText,
                    letterSpacing: 0.0,
                  ),
                ),
                const SizedBox(height: 12.0),
                _SecondaryButton(
                  icon: Icons.photo_camera_outlined,
                  label: 'Trocar foto',
                  onTap: onPick,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: theme.alternate),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 36.0,
                height: 36.0,
                decoration: BoxDecoration(
                  color: theme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: theme.primary, size: 20.0),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: theme.titleMedium.override(
                        font: GoogleFonts.interTight(
                            fontWeight: FontWeight.w700),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: theme.primaryText,
                        letterSpacing: 0.0,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      subtitle,
                      style: theme.bodySmall.override(
                        font: GoogleFonts.inter(),
                        fontSize: 13.0,
                        color: theme.secondaryText,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18.0),
          child,
        ],
      ),
    );
  }
}

class _FieldSpec {
  _FieldSpec({
    required this.label,
    required this.hint,
    required this.controller,
    this.focusNode,
    this.formatters,
    this.keyboardType,
    this.span = 1,
    this.suffixIcon,
    this.onChanged,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final List<MaskTextInputFormatter>? formatters;
  final TextInputType? keyboardType;
  final int span; // 1 = half, 2 = full
  final IconData? suffixIcon;
  final VoidCallback? onChanged;
}

class _FieldGrid extends StatelessWidget {
  const _FieldGrid({required this.fields});
  final List<_FieldSpec> fields;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= kBreakpointMedium ? 2 : 1;
    const gap = 14.0;

    final rows = <Widget>[];
    int i = 0;
    while (i < fields.length) {
      final f = fields[i];
      if (columns == 1 || f.span >= 2 || i == fields.length - 1) {
        rows.add(_Field(spec: f));
        i += 1;
      } else {
        final next = fields[i + 1];
        if (next.span >= 2) {
          rows.add(_Field(spec: f));
          i += 1;
        } else {
          rows.add(
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _Field(spec: f)),
                const SizedBox(width: gap),
                Expanded(child: _Field(spec: next)),
              ],
            ),
          );
          i += 2;
        }
      }
      if (i < fields.length) {
        rows.add(const SizedBox(height: gap));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.spec});
  final _FieldSpec spec;

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
            spec.label,
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
          controller: spec.controller,
          focusNode: spec.focusNode,
          keyboardType: spec.keyboardType,
          inputFormatters: spec.formatters,
          onChanged: spec.onChanged == null ? null : (_) => spec.onChanged!(),
          style: theme.bodyMedium.override(
            font: GoogleFonts.inter(),
            fontSize: 15.0,
            color: theme.primaryText,
            letterSpacing: 0.0,
          ),
          cursorColor: theme.primary,
          decoration: InputDecoration(
            isDense: true,
            hintText: spec.hint,
            hintStyle: theme.bodyMedium.override(
              font: GoogleFonts.inter(),
              fontSize: 15.0,
              color: theme.secondaryText,
              letterSpacing: 0.0,
            ),
            filled: true,
            fillColor: theme.secondaryBackground,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: spec.suffixIcon != null ? 12.0 : 14.0,
            ),
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
            suffixIcon: spec.suffixIcon == null
                ? null
                : Icon(spec.suffixIcon, color: theme.secondaryText, size: 18.0),
          ),
        ),
      ],
    );
  }
}

class _SaveButton extends StatefulWidget {
  const _SaveButton({
    required this.onTap,
    required this.loading,
    required this.block,
  });

  final VoidCallback onTap;
  final bool loading;
  final bool block;

  @override
  State<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<_SaveButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final base = theme.primary;
    final bg = (_hovered || _pressed) ? base.withOpacity(0.88) : base;

    final content = Row(
      mainAxisSize: widget.block ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.loading)
          const SizedBox(
            width: 18.0,
            height: 18.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        else
          Icon(Icons.check_rounded, size: 18.0, color: theme.info),
        const SizedBox(width: 8.0),
        Text(
          widget.loading ? 'Salvando…' : 'Salvar alterações',
          style: theme.titleSmall.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.w700),
            fontSize: 14.0,
            fontWeight: FontWeight.w700,
            color: theme.info,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );

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
            height: 48.0,
            padding: EdgeInsets.symmetric(
              horizontal: widget.block ? 0.0 : 22.0,
            ),
            constraints: BoxConstraints(
              minWidth: widget.block ? double.infinity : 0,
            ),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12.0),
            ),
            alignment: Alignment.center,
            child: content,
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatefulWidget {
  const _SecondaryButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  State<_SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<_SecondaryButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final accent = theme.primary;
    final bg = _hovered ? accent.withOpacity(0.08) : Colors.transparent;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          height: 40.0,
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999.0),
            border: Border.all(color: accent, width: 1.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 16.0, color: accent),
              const SizedBox(width: 6.0),
              Text(
                widget.label,
                style: theme.titleSmall.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                  color: accent,
                  letterSpacing: 0.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconAction extends StatefulWidget {
  const _IconAction({
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  @override
  State<_IconAction> createState() => _IconActionState();
}

class _IconActionState extends State<_IconAction> {
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
            color: bg,
            borderRadius: BorderRadius.circular(10.0),
          ),
          alignment: Alignment.center,
          child: Icon(widget.icon, color: fg, size: 22.0),
        ),
      ),
    );
  }
}
