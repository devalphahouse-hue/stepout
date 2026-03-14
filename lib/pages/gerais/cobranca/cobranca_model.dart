import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/request_manager.dart';

import '/index.dart';
import 'cobranca_widget.dart' show CobrancaWidget;
import 'dart:async';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class CobrancaModel extends FlutterFlowModel<CobrancaWidget> {
  ///  Local state fields for this page.

  List<VinculacaoTurmasStruct> vincularTurmas = [];
  void addToVincularTurmas(VinculacaoTurmasStruct item) =>
      vincularTurmas.add(item);
  void removeFromVincularTurmas(VinculacaoTurmasStruct item) =>
      vincularTurmas.remove(item);
  void removeAtIndexFromVincularTurmas(int index) =>
      vincularTurmas.removeAt(index);
  void insertAtIndexInVincularTurmas(int index, VinculacaoTurmasStruct item) =>
      vincularTurmas.insert(index, item);
  void updateVincularTurmasAtIndex(
          int index, Function(VinculacaoTurmasStruct) updateFn) =>
      vincularTurmas[index] = updateFn(vincularTurmas[index]);

  ///  State fields for stateful widgets in this page.

  Completer<List<CobrancasRow>>? requestCompleter;
  // State field(s) for TextFieldNome widget.
  FocusNode? textFieldNomeFocusNode;
  TextEditingController? textFieldNomeTextController;
  String? Function(BuildContext, String?)? textFieldNomeTextControllerValidator;
  // State field(s) for TextFieldEmail widget.
  FocusNode? textFieldEmailFocusNode;
  TextEditingController? textFieldEmailTextController;
  String? Function(BuildContext, String?)?
      textFieldEmailTextControllerValidator;
  // State field(s) for TextFieldTelefone widget.
  FocusNode? textFieldTelefoneFocusNode;
  TextEditingController? textFieldTelefoneTextController;
  late MaskTextInputFormatter textFieldTelefoneMask;
  String? Function(BuildContext, String?)?
      textFieldTelefoneTextControllerValidator;
  // State field(s) for TextFieldCPF widget.
  FocusNode? textFieldCPFFocusNode;
  TextEditingController? textFieldCPFTextController;
  late MaskTextInputFormatter textFieldCPFMask;
  String? Function(BuildContext, String?)? textFieldCPFTextControllerValidator;
  // State field(s) for TextFieldDNasc widget.
  FocusNode? textFieldDNascFocusNode;
  TextEditingController? textFieldDNascTextController;
  late MaskTextInputFormatter textFieldDNascMask;
  String? Function(BuildContext, String?)?
      textFieldDNascTextControllerValidator;
  // State field(s) for TextFieldNocion widget.
  FocusNode? textFieldNocionFocusNode;
  TextEditingController? textFieldNocionTextController;
  String? Function(BuildContext, String?)?
      textFieldNocionTextControllerValidator;
  // State field(s) for TextFieldCEP widget.
  FocusNode? textFieldCEPFocusNode1;
  TextEditingController? textFieldCEPTextController1;
  late MaskTextInputFormatter textFieldCEPMask1;
  String? Function(BuildContext, String?)? textFieldCEPTextController1Validator;
  // Stores action output result for [Backend Call - API (BuscarCEP)] action in TextFieldCEP widget.
  ApiCallResponse? resultCEP;
  // State field(s) for TextFieldPais widget.
  FocusNode? textFieldPaisFocusNode1;
  TextEditingController? textFieldPaisTextController1;
  String? Function(BuildContext, String?)?
      textFieldPaisTextController1Validator;
  // State field(s) for TextFieldEndereco widget.
  FocusNode? textFieldEnderecoFocusNode1;
  TextEditingController? textFieldEnderecoTextController1;
  String? Function(BuildContext, String?)?
      textFieldEnderecoTextController1Validator;
  // State field(s) for TextFieldBairro widget.
  FocusNode? textFieldBairroFocusNode1;
  TextEditingController? textFieldBairroTextController1;
  String? Function(BuildContext, String?)?
      textFieldBairroTextController1Validator;
  // State field(s) for TextFieldNumero widget.
  FocusNode? textFieldNumeroFocusNode1;
  TextEditingController? textFieldNumeroTextController1;
  String? Function(BuildContext, String?)?
      textFieldNumeroTextController1Validator;
  // State field(s) for TextFieldComple widget.
  FocusNode? textFieldCompleFocusNode1;
  TextEditingController? textFieldCompleTextController1;
  String? Function(BuildContext, String?)?
      textFieldCompleTextController1Validator;
  // State field(s) for TextFieldCidade widget.
  FocusNode? textFieldCidadeFocusNode1;
  TextEditingController? textFieldCidadeTextController1;
  String? Function(BuildContext, String?)?
      textFieldCidadeTextController1Validator;
  // State field(s) for TextFieldUF widget.
  FocusNode? textFieldUFFocusNode1;
  TextEditingController? textFieldUFTextController1;
  String? Function(BuildContext, String?)? textFieldUFTextController1Validator;
  // State field(s) for TextFieldCEP widget.
  FocusNode? textFieldCEPFocusNode2;
  TextEditingController? textFieldCEPTextController2;
  late MaskTextInputFormatter textFieldCEPMask2;
  String? Function(BuildContext, String?)? textFieldCEPTextController2Validator;
  // Stores action output result for [Backend Call - API (BuscarCEP)] action in TextFieldCEP widget.
  ApiCallResponse? resultCEP2;
  // State field(s) for TextFieldEndereco widget.
  FocusNode? textFieldEnderecoFocusNode2;
  TextEditingController? textFieldEnderecoTextController2;
  String? Function(BuildContext, String?)?
      textFieldEnderecoTextController2Validator;
  // State field(s) for TextFieldNumero widget.
  FocusNode? textFieldNumeroFocusNode2;
  TextEditingController? textFieldNumeroTextController2;
  String? Function(BuildContext, String?)?
      textFieldNumeroTextController2Validator;
  // State field(s) for TextFieldBairro widget.
  FocusNode? textFieldBairroFocusNode2;
  TextEditingController? textFieldBairroTextController2;
  String? Function(BuildContext, String?)?
      textFieldBairroTextController2Validator;
  // State field(s) for TextFieldComple widget.
  FocusNode? textFieldCompleFocusNode2;
  TextEditingController? textFieldCompleTextController2;
  String? Function(BuildContext, String?)?
      textFieldCompleTextController2Validator;
  // State field(s) for TextFieldPais widget.
  FocusNode? textFieldPaisFocusNode2;
  TextEditingController? textFieldPaisTextController2;
  String? Function(BuildContext, String?)?
      textFieldPaisTextController2Validator;
  // State field(s) for TextFieldCidade widget.
  FocusNode? textFieldCidadeFocusNode2;
  TextEditingController? textFieldCidadeTextController2;
  String? Function(BuildContext, String?)?
      textFieldCidadeTextController2Validator;
  // State field(s) for TextFieldUF widget.
  FocusNode? textFieldUFFocusNode2;
  TextEditingController? textFieldUFTextController2;
  String? Function(BuildContext, String?)? textFieldUFTextController2Validator;
  // State field(s) for Checkbox widget.
  bool? checkboxValue;
  // Stores action output result for [Backend Call - Update Row(s)] action in Button widget.
  List<UsersRow>? uptadeuser;
  // Stores action output result for [Backend Call - Query Rows] action in Button widget.
  List<FranquiasRow>? getWallet;

  /// Query cache managers for this widget.

  final _usersManager = FutureRequestManager<List<UsersRow>>();
  Future<List<UsersRow>> users({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<UsersRow>> Function() requestFn,
  }) =>
      _usersManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearUsersCache() => _usersManager.clear();
  void clearUsersCacheKey(String? uniqueKey) =>
      _usersManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldNomeFocusNode?.dispose();
    textFieldNomeTextController?.dispose();

    textFieldEmailFocusNode?.dispose();
    textFieldEmailTextController?.dispose();

    textFieldTelefoneFocusNode?.dispose();
    textFieldTelefoneTextController?.dispose();

    textFieldCPFFocusNode?.dispose();
    textFieldCPFTextController?.dispose();

    textFieldDNascFocusNode?.dispose();
    textFieldDNascTextController?.dispose();

    textFieldNocionFocusNode?.dispose();
    textFieldNocionTextController?.dispose();

    textFieldCEPFocusNode1?.dispose();
    textFieldCEPTextController1?.dispose();

    textFieldPaisFocusNode1?.dispose();
    textFieldPaisTextController1?.dispose();

    textFieldEnderecoFocusNode1?.dispose();
    textFieldEnderecoTextController1?.dispose();

    textFieldBairroFocusNode1?.dispose();
    textFieldBairroTextController1?.dispose();

    textFieldNumeroFocusNode1?.dispose();
    textFieldNumeroTextController1?.dispose();

    textFieldCompleFocusNode1?.dispose();
    textFieldCompleTextController1?.dispose();

    textFieldCidadeFocusNode1?.dispose();
    textFieldCidadeTextController1?.dispose();

    textFieldUFFocusNode1?.dispose();
    textFieldUFTextController1?.dispose();

    textFieldCEPFocusNode2?.dispose();
    textFieldCEPTextController2?.dispose();

    textFieldEnderecoFocusNode2?.dispose();
    textFieldEnderecoTextController2?.dispose();

    textFieldNumeroFocusNode2?.dispose();
    textFieldNumeroTextController2?.dispose();

    textFieldBairroFocusNode2?.dispose();
    textFieldBairroTextController2?.dispose();

    textFieldCompleFocusNode2?.dispose();
    textFieldCompleTextController2?.dispose();

    textFieldPaisFocusNode2?.dispose();
    textFieldPaisTextController2?.dispose();

    textFieldCidadeFocusNode2?.dispose();
    textFieldCidadeTextController2?.dispose();

    textFieldUFFocusNode2?.dispose();
    textFieldUFTextController2?.dispose();

    /// Dispose query cache managers for this widget.

    clearUsersCache();
  }

  /// Additional helper methods.
  Future waitForRequestCompleted({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = requestCompleter?.isCompleted ?? false;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }
}
