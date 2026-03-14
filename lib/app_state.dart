import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import '/backend/api_requests/api_manager.dart';
import 'backend/supabase/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _idfranquia = prefs.getString('ff_idfranquia') ?? _idfranquia;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _idfranquia = '';
  String get idfranquia => _idfranquia;
  set idfranquia(String value) {
    _idfranquia = value;
    prefs.setString('ff_idfranquia', value);
  }

  bool _AlterarTurmaVisibility = false;
  bool get AlterarTurmaVisibility => _AlterarTurmaVisibility;
  set AlterarTurmaVisibility(bool value) {
    _AlterarTurmaVisibility = value;
  }

  List<AgendaAulasStruct> _AgendasTurma = [];
  List<AgendaAulasStruct> get AgendasTurma => _AgendasTurma;
  set AgendasTurma(List<AgendaAulasStruct> value) {
    _AgendasTurma = value;
  }

  void addToAgendasTurma(AgendaAulasStruct value) {
    AgendasTurma.add(value);
  }

  void removeFromAgendasTurma(AgendaAulasStruct value) {
    AgendasTurma.remove(value);
  }

  void removeAtIndexFromAgendasTurma(int index) {
    AgendasTurma.removeAt(index);
  }

  void updateAgendasTurmaAtIndex(
    int index,
    AgendaAulasStruct Function(AgendaAulasStruct) updateFn,
  ) {
    AgendasTurma[index] = updateFn(_AgendasTurma[index]);
  }

  void insertAtIndexInAgendasTurma(int index, AgendaAulasStruct value) {
    AgendasTurma.insert(index, value);
  }

  List<ListaAlunosStruct> _ListaAlunos = [];
  List<ListaAlunosStruct> get ListaAlunos => _ListaAlunos;
  set ListaAlunos(List<ListaAlunosStruct> value) {
    _ListaAlunos = value;
  }

  void addToListaAlunos(ListaAlunosStruct value) {
    ListaAlunos.add(value);
  }

  void removeFromListaAlunos(ListaAlunosStruct value) {
    ListaAlunos.remove(value);
  }

  void removeAtIndexFromListaAlunos(int index) {
    ListaAlunos.removeAt(index);
  }

  void updateListaAlunosAtIndex(
    int index,
    ListaAlunosStruct Function(ListaAlunosStruct) updateFn,
  ) {
    ListaAlunos[index] = updateFn(_ListaAlunos[index]);
  }

  void insertAtIndexInListaAlunos(int index, ListaAlunosStruct value) {
    ListaAlunos.insert(index, value);
  }

  bool _AlterarProfessorVisibility = false;
  bool get AlterarProfessorVisibility => _AlterarProfessorVisibility;
  set AlterarProfessorVisibility(bool value) {
    _AlterarProfessorVisibility = value;
  }

  List<DiaCalendarioAulasStruct> _ListaDiasCalendarioAulas = [];
  List<DiaCalendarioAulasStruct> get ListaDiasCalendarioAulas =>
      _ListaDiasCalendarioAulas;
  set ListaDiasCalendarioAulas(List<DiaCalendarioAulasStruct> value) {
    _ListaDiasCalendarioAulas = value;
  }

  void addToListaDiasCalendarioAulas(DiaCalendarioAulasStruct value) {
    ListaDiasCalendarioAulas.add(value);
  }

  void removeFromListaDiasCalendarioAulas(DiaCalendarioAulasStruct value) {
    ListaDiasCalendarioAulas.remove(value);
  }

  void removeAtIndexFromListaDiasCalendarioAulas(int index) {
    ListaDiasCalendarioAulas.removeAt(index);
  }

  void updateListaDiasCalendarioAulasAtIndex(
    int index,
    DiaCalendarioAulasStruct Function(DiaCalendarioAulasStruct) updateFn,
  ) {
    ListaDiasCalendarioAulas[index] =
        updateFn(_ListaDiasCalendarioAulas[index]);
  }

  void insertAtIndexInListaDiasCalendarioAulas(
      int index, DiaCalendarioAulasStruct value) {
    ListaDiasCalendarioAulas.insert(index, value);
  }

  DateTime? _dataParamentroCalendario;
  DateTime? get dataParamentroCalendario => _dataParamentroCalendario;
  set dataParamentroCalendario(DateTime? value) {
    _dataParamentroCalendario = value;
  }

  List<ItemCalendarioAulasStruct> _ListaAulasDoDiaCalendario = [];
  List<ItemCalendarioAulasStruct> get ListaAulasDoDiaCalendario =>
      _ListaAulasDoDiaCalendario;
  set ListaAulasDoDiaCalendario(List<ItemCalendarioAulasStruct> value) {
    _ListaAulasDoDiaCalendario = value;
  }

  void addToListaAulasDoDiaCalendario(ItemCalendarioAulasStruct value) {
    ListaAulasDoDiaCalendario.add(value);
  }

  void removeFromListaAulasDoDiaCalendario(ItemCalendarioAulasStruct value) {
    ListaAulasDoDiaCalendario.remove(value);
  }

  void removeAtIndexFromListaAulasDoDiaCalendario(int index) {
    ListaAulasDoDiaCalendario.removeAt(index);
  }

  void updateListaAulasDoDiaCalendarioAtIndex(
    int index,
    ItemCalendarioAulasStruct Function(ItemCalendarioAulasStruct) updateFn,
  ) {
    ListaAulasDoDiaCalendario[index] =
        updateFn(_ListaAulasDoDiaCalendario[index]);
  }

  void insertAtIndexInListaAulasDoDiaCalendario(
      int index, ItemCalendarioAulasStruct value) {
    ListaAulasDoDiaCalendario.insert(index, value);
  }

  String _linkconteudo = '';
  String get linkconteudo => _linkconteudo;
  set linkconteudo(String value) {
    _linkconteudo = value;
  }

  String _chatId = '';
  String get chatId => _chatId;
  set chatId(String value) {
    _chatId = value;
  }

  PagamentoCobrancaStruct _pagamentoCobranca = PagamentoCobrancaStruct();
  PagamentoCobrancaStruct get pagamentoCobranca => _pagamentoCobranca;
  set pagamentoCobranca(PagamentoCobrancaStruct value) {
    _pagamentoCobranca = value;
  }

  void updatePagamentoCobrancaStruct(
      Function(PagamentoCobrancaStruct) updateFn) {
    updateFn(_pagamentoCobranca);
  }

  String _jaasJWT = '';
  String get jaasJWT => _jaasJWT;
  set jaasJWT(String value) {
    _jaasJWT = value;
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
