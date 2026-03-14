// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ItemCalendarioAulasStruct extends BaseStruct {
  ItemCalendarioAulasStruct({
    String? nomeTurma,
    String? nomeProfessor,
    int? quantidadeAlunosConvidados,
    String? statusAula,
    String? datetimeInicioAula,
    String? datetimeTerminoAula,
    String? uuidAula,
    String? idProfessor,
  })  : _nomeTurma = nomeTurma,
        _nomeProfessor = nomeProfessor,
        _quantidadeAlunosConvidados = quantidadeAlunosConvidados,
        _statusAula = statusAula,
        _datetimeInicioAula = datetimeInicioAula,
        _datetimeTerminoAula = datetimeTerminoAula,
        _uuidAula = uuidAula,
        _idProfessor = idProfessor;

  // "nome_turma" field.
  String? _nomeTurma;
  String get nomeTurma => _nomeTurma ?? '';
  set nomeTurma(String? val) => _nomeTurma = val;

  bool hasNomeTurma() => _nomeTurma != null;

  // "nome_professor" field.
  String? _nomeProfessor;
  String get nomeProfessor => _nomeProfessor ?? '';
  set nomeProfessor(String? val) => _nomeProfessor = val;

  bool hasNomeProfessor() => _nomeProfessor != null;

  // "quantidade_alunos_convidados" field.
  int? _quantidadeAlunosConvidados;
  int get quantidadeAlunosConvidados => _quantidadeAlunosConvidados ?? 0;
  set quantidadeAlunosConvidados(int? val) => _quantidadeAlunosConvidados = val;

  void incrementQuantidadeAlunosConvidados(int amount) =>
      quantidadeAlunosConvidados = quantidadeAlunosConvidados + amount;

  bool hasQuantidadeAlunosConvidados() => _quantidadeAlunosConvidados != null;

  // "status_aula" field.
  String? _statusAula;
  String get statusAula => _statusAula ?? '';
  set statusAula(String? val) => _statusAula = val;

  bool hasStatusAula() => _statusAula != null;

  // "datetime_inicio_aula" field.
  String? _datetimeInicioAula;
  String get datetimeInicioAula => _datetimeInicioAula ?? '';
  set datetimeInicioAula(String? val) => _datetimeInicioAula = val;

  bool hasDatetimeInicioAula() => _datetimeInicioAula != null;

  // "datetime_termino_aula" field.
  String? _datetimeTerminoAula;
  String get datetimeTerminoAula => _datetimeTerminoAula ?? '';
  set datetimeTerminoAula(String? val) => _datetimeTerminoAula = val;

  bool hasDatetimeTerminoAula() => _datetimeTerminoAula != null;

  // "uuid_aula" field.
  String? _uuidAula;
  String get uuidAula => _uuidAula ?? '';
  set uuidAula(String? val) => _uuidAula = val;

  bool hasUuidAula() => _uuidAula != null;

  // "id_professor" field.
  String? _idProfessor;
  String get idProfessor => _idProfessor ?? '';
  set idProfessor(String? val) => _idProfessor = val;

  bool hasIdProfessor() => _idProfessor != null;

  static ItemCalendarioAulasStruct fromMap(Map<String, dynamic> data) =>
      ItemCalendarioAulasStruct(
        nomeTurma: data['nome_turma'] as String?,
        nomeProfessor: data['nome_professor'] as String?,
        quantidadeAlunosConvidados:
            castToType<int>(data['quantidade_alunos_convidados']),
        statusAula: data['status_aula'] as String?,
        datetimeInicioAula: data['datetime_inicio_aula'] as String?,
        datetimeTerminoAula: data['datetime_termino_aula'] as String?,
        uuidAula: data['uuid_aula'] as String?,
        idProfessor: data['id_professor'] as String?,
      );

  static ItemCalendarioAulasStruct? maybeFromMap(dynamic data) => data is Map
      ? ItemCalendarioAulasStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'nome_turma': _nomeTurma,
        'nome_professor': _nomeProfessor,
        'quantidade_alunos_convidados': _quantidadeAlunosConvidados,
        'status_aula': _statusAula,
        'datetime_inicio_aula': _datetimeInicioAula,
        'datetime_termino_aula': _datetimeTerminoAula,
        'uuid_aula': _uuidAula,
        'id_professor': _idProfessor,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'nome_turma': serializeParam(
          _nomeTurma,
          ParamType.String,
        ),
        'nome_professor': serializeParam(
          _nomeProfessor,
          ParamType.String,
        ),
        'quantidade_alunos_convidados': serializeParam(
          _quantidadeAlunosConvidados,
          ParamType.int,
        ),
        'status_aula': serializeParam(
          _statusAula,
          ParamType.String,
        ),
        'datetime_inicio_aula': serializeParam(
          _datetimeInicioAula,
          ParamType.String,
        ),
        'datetime_termino_aula': serializeParam(
          _datetimeTerminoAula,
          ParamType.String,
        ),
        'uuid_aula': serializeParam(
          _uuidAula,
          ParamType.String,
        ),
        'id_professor': serializeParam(
          _idProfessor,
          ParamType.String,
        ),
      }.withoutNulls;

  static ItemCalendarioAulasStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      ItemCalendarioAulasStruct(
        nomeTurma: deserializeParam(
          data['nome_turma'],
          ParamType.String,
          false,
        ),
        nomeProfessor: deserializeParam(
          data['nome_professor'],
          ParamType.String,
          false,
        ),
        quantidadeAlunosConvidados: deserializeParam(
          data['quantidade_alunos_convidados'],
          ParamType.int,
          false,
        ),
        statusAula: deserializeParam(
          data['status_aula'],
          ParamType.String,
          false,
        ),
        datetimeInicioAula: deserializeParam(
          data['datetime_inicio_aula'],
          ParamType.String,
          false,
        ),
        datetimeTerminoAula: deserializeParam(
          data['datetime_termino_aula'],
          ParamType.String,
          false,
        ),
        uuidAula: deserializeParam(
          data['uuid_aula'],
          ParamType.String,
          false,
        ),
        idProfessor: deserializeParam(
          data['id_professor'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ItemCalendarioAulasStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ItemCalendarioAulasStruct &&
        nomeTurma == other.nomeTurma &&
        nomeProfessor == other.nomeProfessor &&
        quantidadeAlunosConvidados == other.quantidadeAlunosConvidados &&
        statusAula == other.statusAula &&
        datetimeInicioAula == other.datetimeInicioAula &&
        datetimeTerminoAula == other.datetimeTerminoAula &&
        uuidAula == other.uuidAula &&
        idProfessor == other.idProfessor;
  }

  @override
  int get hashCode => const ListEquality().hash([
        nomeTurma,
        nomeProfessor,
        quantidadeAlunosConvidados,
        statusAula,
        datetimeInicioAula,
        datetimeTerminoAula,
        uuidAula,
        idProfessor
      ]);
}

ItemCalendarioAulasStruct createItemCalendarioAulasStruct({
  String? nomeTurma,
  String? nomeProfessor,
  int? quantidadeAlunosConvidados,
  String? statusAula,
  String? datetimeInicioAula,
  String? datetimeTerminoAula,
  String? uuidAula,
  String? idProfessor,
}) =>
    ItemCalendarioAulasStruct(
      nomeTurma: nomeTurma,
      nomeProfessor: nomeProfessor,
      quantidadeAlunosConvidados: quantidadeAlunosConvidados,
      statusAula: statusAula,
      datetimeInicioAula: datetimeInicioAula,
      datetimeTerminoAula: datetimeTerminoAula,
      uuidAula: uuidAula,
      idProfessor: idProfessor,
    );
