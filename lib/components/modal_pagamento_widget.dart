import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'modal_pagamento_model.dart';
export 'modal_pagamento_model.dart';

class ModalPagamentoWidget extends StatefulWidget {
  const ModalPagamentoWidget({
    super.key,
    required this.items,
  });

  final dynamic items;

  @override
  State<ModalPagamentoWidget> createState() => _ModalPagamentoWidgetState();
}

class _ModalPagamentoWidgetState extends State<ModalPagamentoWidget> {
  late ModalPagamentoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModalPagamentoModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  String _str(String path) {
    final v = getJsonField(widget!.items, path);
    if (v == null) return '';
    return v.toString();
  }

  num? _num(String path) {
    final v = getJsonField(widget!.items, path);
    if (v == null) return null;
    if (v is num) return v;
    return num.tryParse(v.toString());
  }

  Future<void> _copyToClipboard(String value) async {
    if (value.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Copiado para a área de transferência'),
        duration: const Duration(seconds: 2),
        backgroundColor: FlutterFlowTheme.of(context).primary,
      ),
    );
  }

  Widget _sectionTitle(String label) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
      child: Text(
        label,
        style: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              fontWeight: FontWeight.w600,
              color: FlutterFlowTheme.of(context).secondaryText,
              letterSpacing: 0.4,
              fontSize: 11,
            ),
      ),
    );
  }

  Widget _infoCard({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  Widget _kvRow({
    required IconData icon,
    required String label,
    required String value,
    bool emphasize = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 2, 12, 0),
          child: Icon(
            icon,
            size: 18,
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: FlutterFlowTheme.of(context).labelSmall.override(
                      font: GoogleFonts.inter(),
                      letterSpacing: 0.0,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 11,
                    ),
              ),
              const SizedBox(height: 2),
              SelectionArea(
                child: Text(
                  value.isEmpty ? '—' : value,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: emphasize
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            emphasize ? FontWeight.w600 : FontWeight.w500,
                        color: value.isEmpty
                            ? FlutterFlowTheme.of(context).secondaryText
                            : FlutterFlowTheme.of(context).primaryText,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _idTile({required String label, required String value}) {
    final hasValue = value.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: FlutterFlowTheme.of(context).labelSmall.override(
                font: GoogleFonts.inter(),
                letterSpacing: 0.0,
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 11,
              ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: FlutterFlowTheme.of(context).alternate,
              width: 1,
            ),
          ),
          padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 4, 8),
          child: Row(
            children: [
              Expanded(
                child: SelectionArea(
                  child: Text(
                    hasValue ? value : 'Não gerada',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.robotoMono(),
                          letterSpacing: 0.0,
                          fontSize: 12,
                          color: hasValue
                              ? FlutterFlowTheme.of(context).primaryText
                              : FlutterFlowTheme.of(context).secondaryText,
                        ),
                  ),
                  // overflow handled by SelectableText behavior
                ),
              ),
              if (hasValue)
                Tooltip(
                  message: 'Copiar',
                  child: InkWell(
                    onTap: () => _copyToClipboard(value),
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        Icons.copy_rounded,
                        size: 16,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final isCompact = viewportWidth < kBreakpointSmall;
    final modalWidth = isCompact
        ? viewportWidth * 0.95
        : viewportWidth < kBreakpointMedium
            ? viewportWidth * 0.85
            : 600.0;

    final statusRaw = _str(r'''$.status_cobranca''');
    final statusLabel = functions.cobrancaStatusLabel(statusRaw);
    final statusBg = functions.cobrancaStatusColorBg(statusRaw);
    final statusFg = functions.cobrancaStatusColorFg(statusRaw);

    final valor = _num(r'''$.valor''') ?? 0;
    final numParcelasRaw = _num(r'''$.num_parcelas''')?.toInt() ?? 1;
    final numParcelas = numParcelasRaw < 1 ? 1 : numParcelasRaw;
    final valorParcela = _num(r'''$.valor_parcelas''') ?? valor / numParcelas;

    final cliente = _str(r'''$.user_nome''');
    final email = _str(r'''$.user_email''');
    final formaPagamento = _str(r'''$.forma_pagamento''');
    final createdAt = _str(r'''$.created_at''');
    final tipoCobranca = _str(r'''$.tipo_cobranca''');

    final asaasId = _str(r'''$.id_cobranca_asaas''');
    final internalId = _str(r'''$.id''');

    final formattedCreatedAt = dateTimeFormat(
      "dd/MM/yyyy 'às' HH:mm",
      functions.stringToDatetime(createdAt),
      locale: FFLocalizations.of(context).languageCode,
    );

    return Align(
      alignment: AlignmentDirectional.center,
      child: Container(
        width: modalWidth,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.92,
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              blurRadius: 24,
              color: Color(0x33000000),
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .primary
                                .withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.receipt_long_rounded,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Detalhes da cobrança',
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      font: GoogleFonts.interTight(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              if (tipoCobranca.isNotEmpty)
                                Padding(
                                  padding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          0, 2, 0, 0),
                                  child: Text(
                                    tipoCobranca[0].toUpperCase() +
                                        tipoCobranca.substring(1),
                                    style: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .override(
                                          font: GoogleFonts.inter(),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          fontSize: 11,
                                        ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 4, 10, 4),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      statusLabel,
                      style: FlutterFlowTheme.of(context).labelSmall.override(
                            font: GoogleFonts.inter(
                                fontWeight: FontWeight.w600),
                            color: statusFg,
                            letterSpacing: 0.0,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  FlutterFlowIconButton(
                    borderRadius: 999,
                    buttonSize: 36,
                    icon: Icon(
                      Icons.close_rounded,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: FlutterFlowTheme.of(context).alternate,
            ),

            // ── Body (scrollable) ─────────────────────────────────
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero – valor
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            FlutterFlowTheme.of(context)
                                .primary
                                .withOpacity(0.06),
                            FlutterFlowTheme.of(context)
                                .primary
                                .withOpacity(0.02),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context)
                              .primary
                              .withOpacity(0.18),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Valor total',
                            style:
                                FlutterFlowTheme.of(context).labelMedium.override(
                                      font: GoogleFonts.inter(),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.4,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            functions.formatCurrencyBr(valor),
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.w700,
                                  ),
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.0,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            numParcelas > 1
                                ? '$numParcelas× de ${functions.formatCurrencyBr(valorParcela)}'
                                : 'Pagamento à vista',
                            style:
                                FlutterFlowTheme.of(context).bodyMedium.override(
                                      font: GoogleFonts.inter(),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Cliente ──
                    _sectionTitle('CLIENTE'),
                    _infoCard(
                      child: Column(
                        children: [
                          _kvRow(
                            icon: Icons.person_outline_rounded,
                            label: 'Nome',
                            value: cliente,
                            emphasize: true,
                          ),
                          if (email.isNotEmpty) const SizedBox(height: 14),
                          if (email.isNotEmpty)
                            _kvRow(
                              icon: Icons.alternate_email_rounded,
                              label: 'E-mail',
                              value: email,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Pagamento ──
                    _sectionTitle('PAGAMENTO'),
                    _infoCard(
                      child: Column(
                        children: [
                          _kvRow(
                            icon: Icons.event_available_rounded,
                            label: 'Criada em',
                            value: formattedCreatedAt,
                          ),
                          const SizedBox(height: 14),
                          _kvRow(
                            icon: Icons.credit_card_rounded,
                            label: 'Forma de pagamento',
                            value: formaPagamento,
                          ),
                          const SizedBox(height: 14),
                          _kvRow(
                            icon: Icons.account_balance_wallet_outlined,
                            label: 'Parcelamento',
                            value: numParcelas > 1
                                ? '$numParcelas× de ${functions.formatCurrencyBr(valorParcela)}'
                                : 'À vista',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── IDs ──
                    _sectionTitle('IDENTIFICADORES'),
                    _infoCard(
                      child: Column(
                        children: [
                          _idTile(label: 'ID Asaas', value: asaasId),
                          const SizedBox(height: 14),
                          _idTile(label: 'ID interno', value: internalId),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
