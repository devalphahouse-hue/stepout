// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ListaTurmasStruct extends BaseStruct {
  ListaTurmasStruct({
    String? id,
    String? professor,
    List<AgendaAulasStruct>? agendaAulas,
    String? alunosTurma,
    int? totalAlunos,
    String? nomeDaTurma,
    String? moduloNivelTurma,
    String? professorId,
  })  : _id = id,
        _professor = professor,
        _agendaAulas = agendaAulas,
        _alunosTurma = alunosTurma,
        _totalAlunos = totalAlunos,
        _nomeDaTurma = nomeDaTurma,
        _moduloNivelTurma = moduloNivelTurma,
        _professorId = professorId;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "professor" field.
  String? _professor;
  String get professor => _professor ?? '';
  set professor(String? val) => _professor = val;

  bool hasProfessor() => _professor != null;

  // "agenda_aulas" field.
  List<AgendaAulasStruct>? _agendaAulas;
  List<AgendaAulasStruct> get agendaAulas => _agendaAulas ?? const [];
  set agendaAulas(List<AgendaAulasStruct>? val) => _agendaAulas = val;

  void updateAgendaAulas(Function(List<AgendaAulasStruct>) updateFn) {
    updateFn(_agendaAulas ??= []);
  }

  bool hasAgendaAulas() => _agendaAulas != null;

  // "alunos_turma" field.
  String? _alunosTurma;
  String get alunosTurma => _alunosTurma ?? '';
  set alunosTurma(String? val) => _alunosTurma = val;

  bool hasAlunosTurma() => _alunosTurma != null;

  // "total_alunos" field.
  int? _totalAlunos;
  int get totalAlunos => _totalAlunos ?? 0;
  set totalAlunos(int? val) => _totalAlunos = val;

  void incrementTotalAlunos(int amount) => totalAlunos = totalAlunos + amount;

  bool hasTotalAlunos() => _totalAlunos != null;

  // "nome_da_turma" field.
  String? _nomeDaTurma;
  String get nomeDaTurma => _nomeDaTurma ?? '';
  set nomeDaTurma(String? val) => _nomeDaTurma = val;

  bool hasNomeDaTurma() => _nomeDaTurma != null;

  // "modulo_nivel_turma" field.
  String? _moduloNivelTurma;
  String get moduloNivelTurma => _moduloNivelTurma ?? '';
  set moduloNivelTurma(String? val) => _moduloNivelTurma = val;

  bool hasModuloNivelTurma() => _moduloNivelTurma != null;

  // "professor_id" field.
  String? _professorId;
  String get professorId => _professorId ?? '';
  set professorId(String? val) => _professorId = val;

  bool hasProfessorId() => _professorId != null;

  static ListaTurmasStruct fromMap(Map<String, dynamic> data) =>
      ListaTurmasStruct(
        id: data['id'] as String?,
        professor: data['professor'] as String?,
        agendaAulas: getStructList(
          data['agenda_aulas'],
          AgendaAulasStruct.fromMap,
        ),
        alunosTurma: data['alunos_turma'] as String?,
        totalAlunos: castToType<int>(data['total_alunos']),
        nomeDaTurma: data['nome_da_turma'] as String?,
        moduloNivelTurma: data['modulo_nivel_turma'] as String?,
        professorId: data['professor_id'] as String?,
      );

  static ListaTurmasStruct? maybeFromMap(dynamic data) => data is Map
      ? ListaTurmasStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'professor': _professor,
        'agenda_aulas': _agendaAulas?.map((e) => e.toMap()).toList(),
        'alunos_turma': _alunosTurma,
        'total_alunos': _totalAlunos,
        'nome_da_turma': _nomeDaTurma,
        'modulo_nivel_turma': _moduloNivelTurma,
        'professor_id': _professorId,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'professor': serializeParam(
          _professor,
          ParamType.String,
        ),
        'agenda_aulas': serializeParam(
          _agendaAulas,
          ParamType.DataStruct,
          isList: true,
        ),
        'alunos_turma': serializeParam(
          _alunosTurma,
          ParamType.String,
        ),
        'total_alunos': serializeParam(
          _totalAlunos,
          ParamType.int,
        ),
        'nome_da_turma': serializeParam(
          _nomeDaTurma,
          ParamType.String,
        ),
        'modulo_nivel_turma': serializeParam(
          _moduloNivelTurma,
          ParamType.String,
        ),
        'professor_id': serializeParam(
          _professorId,
          ParamType.String,
        ),
      }.withoutNulls;

  static ListaTurmasStruct fromSerializableMap(Map<String, dynamic> data) =>
      ListaTurmasStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        professor: deserializeParam(
          data['professor'],
          ParamType.String,
          false,
        ),
        agendaAulas: deserializeStructParam<AgendaAulasStruct>(
          data['agenda_aulas'],
          ParamType.DataStruct,
          true,
          structBuilder: AgendaAulasStruct.fromSerializableMap,
        ),
        alunosTurma: deserializeParam(
          data['alunos_turma'],
          ParamType.String,
          false,
        ),
        totalAlunos: deserializeParam(
          data['total_alunos'],
          ParamType.int,
          false,
        ),
        nomeDaTurma: deserializeParam(
          data['nome_da_turma'],
          ParamType.String,
          false,
        ),
        moduloNivelTurma: deserializeParam(
          data['modulo_nivel_turma'],
          ParamType.String,
          false,
        ),
        professorId: deserializeParam(
          data['professor_id'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ListaTurmasStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ListaTurmasStruct &&
        id == other.id &&
        professor == other.professor &&
        listEquality.equals(agendaAulas, other.agendaAulas) &&
        alunosTurma == other.alunosTurma &&
        totalAlunos == other.totalAlunos &&
        nomeDaTurma == other.nomeDaTurma &&
        moduloNivelTurma == other.moduloNivelTurma &&
        professorId == other.professorId;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        professor,
        agendaAulas,
        alunosTurma,
        totalAlunos,
        nomeDaTurma,
        moduloNivelTurma,
        professorId
      ]);
}

ListaTurmasStruct createListaTurmasStruct({
  String? id,
  String? professor,
  String? alunosTurma,
  int? totalAlunos,
  String? nomeDaTurma,
  String? moduloNivelTurma,
  String? professorId,
}) =>
    ListaTurmasStruct(
      id: id,
      professor: professor,
      alunosTurma: alunosTurma,
      totalAlunos: totalAlunos,
      nomeDaTurma: nomeDaTurma,
      moduloNivelTurma: moduloNivelTurma,
      professorId: professorId,
    );
