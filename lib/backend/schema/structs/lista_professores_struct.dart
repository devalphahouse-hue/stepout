// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ListaProfessoresStruct extends BaseStruct {
  ListaProfessoresStruct({
    String? nome,
    String? email,
    String? userId,
    double? alunoCount,
    int? turmaCount,
    String? professorMetaId,
    String? telefone,
  })  : _nome = nome,
        _email = email,
        _userId = userId,
        _alunoCount = alunoCount,
        _turmaCount = turmaCount,
        _professorMetaId = professorMetaId,
        _telefone = telefone;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "user_id" field.
  String? _userId;
  String get userId => _userId ?? '';
  set userId(String? val) => _userId = val;

  bool hasUserId() => _userId != null;

  // "aluno_count" field.
  double? _alunoCount;
  double get alunoCount => _alunoCount ?? 0.0;
  set alunoCount(double? val) => _alunoCount = val;

  void incrementAlunoCount(double amount) => alunoCount = alunoCount + amount;

  bool hasAlunoCount() => _alunoCount != null;

  // "turma_count" field.
  int? _turmaCount;
  int get turmaCount => _turmaCount ?? 0;
  set turmaCount(int? val) => _turmaCount = val;

  void incrementTurmaCount(int amount) => turmaCount = turmaCount + amount;

  bool hasTurmaCount() => _turmaCount != null;

  // "professor_meta_id" field.
  String? _professorMetaId;
  String get professorMetaId => _professorMetaId ?? '';
  set professorMetaId(String? val) => _professorMetaId = val;

  bool hasProfessorMetaId() => _professorMetaId != null;

  // "telefone" field.
  String? _telefone;
  String get telefone => _telefone ?? '';
  set telefone(String? val) => _telefone = val;

  bool hasTelefone() => _telefone != null;

  static ListaProfessoresStruct fromMap(Map<String, dynamic> data) =>
      ListaProfessoresStruct(
        nome: data['nome'] as String?,
        email: data['email'] as String?,
        userId: data['user_id'] as String?,
        alunoCount: castToType<double>(data['aluno_count']),
        turmaCount: castToType<int>(data['turma_count']),
        professorMetaId: data['professor_meta_id'] as String?,
        telefone: data['telefone'] as String?,
      );

  static ListaProfessoresStruct? maybeFromMap(dynamic data) => data is Map
      ? ListaProfessoresStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'nome': _nome,
        'email': _email,
        'user_id': _userId,
        'aluno_count': _alunoCount,
        'turma_count': _turmaCount,
        'professor_meta_id': _professorMetaId,
        'telefone': _telefone,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'user_id': serializeParam(
          _userId,
          ParamType.String,
        ),
        'aluno_count': serializeParam(
          _alunoCount,
          ParamType.double,
        ),
        'turma_count': serializeParam(
          _turmaCount,
          ParamType.int,
        ),
        'professor_meta_id': serializeParam(
          _professorMetaId,
          ParamType.String,
        ),
        'telefone': serializeParam(
          _telefone,
          ParamType.String,
        ),
      }.withoutNulls;

  static ListaProfessoresStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      ListaProfessoresStruct(
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        userId: deserializeParam(
          data['user_id'],
          ParamType.String,
          false,
        ),
        alunoCount: deserializeParam(
          data['aluno_count'],
          ParamType.double,
          false,
        ),
        turmaCount: deserializeParam(
          data['turma_count'],
          ParamType.int,
          false,
        ),
        professorMetaId: deserializeParam(
          data['professor_meta_id'],
          ParamType.String,
          false,
        ),
        telefone: deserializeParam(
          data['telefone'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ListaProfessoresStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ListaProfessoresStruct &&
        nome == other.nome &&
        email == other.email &&
        userId == other.userId &&
        alunoCount == other.alunoCount &&
        turmaCount == other.turmaCount &&
        professorMetaId == other.professorMetaId &&
        telefone == other.telefone;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [nome, email, userId, alunoCount, turmaCount, professorMetaId, telefone]);
}

ListaProfessoresStruct createListaProfessoresStruct({
  String? nome,
  String? email,
  String? userId,
  double? alunoCount,
  int? turmaCount,
  String? professorMetaId,
  String? telefone,
}) =>
    ListaProfessoresStruct(
      nome: nome,
      email: email,
      userId: userId,
      alunoCount: alunoCount,
      turmaCount: turmaCount,
      professorMetaId: professorMetaId,
      telefone: telefone,
    );
