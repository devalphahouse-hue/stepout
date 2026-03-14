// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ListaAlunosStruct extends BaseStruct {
  ListaAlunosStruct({
    String? nome,
    String? email,
    String? turma,
    String? userId,
    String? telefone,
    String? franquiaId,
    String? alunosTurma,
    String? metaAlunoId,
  })  : _nome = nome,
        _email = email,
        _turma = turma,
        _userId = userId,
        _telefone = telefone,
        _franquiaId = franquiaId,
        _alunosTurma = alunosTurma,
        _metaAlunoId = metaAlunoId;

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

  // "turma" field.
  String? _turma;
  String get turma => _turma ?? '';
  set turma(String? val) => _turma = val;

  bool hasTurma() => _turma != null;

  // "user_id" field.
  String? _userId;
  String get userId => _userId ?? '';
  set userId(String? val) => _userId = val;

  bool hasUserId() => _userId != null;

  // "telefone" field.
  String? _telefone;
  String get telefone => _telefone ?? '';
  set telefone(String? val) => _telefone = val;

  bool hasTelefone() => _telefone != null;

  // "franquia_id" field.
  String? _franquiaId;
  String get franquiaId => _franquiaId ?? '';
  set franquiaId(String? val) => _franquiaId = val;

  bool hasFranquiaId() => _franquiaId != null;

  // "alunos_turma" field.
  String? _alunosTurma;
  String get alunosTurma => _alunosTurma ?? '';
  set alunosTurma(String? val) => _alunosTurma = val;

  bool hasAlunosTurma() => _alunosTurma != null;

  // "meta_aluno_id" field.
  String? _metaAlunoId;
  String get metaAlunoId => _metaAlunoId ?? '';
  set metaAlunoId(String? val) => _metaAlunoId = val;

  bool hasMetaAlunoId() => _metaAlunoId != null;

  static ListaAlunosStruct fromMap(Map<String, dynamic> data) =>
      ListaAlunosStruct(
        nome: data['nome'] as String?,
        email: data['email'] as String?,
        turma: data['turma'] as String?,
        userId: data['user_id'] as String?,
        telefone: data['telefone'] as String?,
        franquiaId: data['franquia_id'] as String?,
        alunosTurma: data['alunos_turma'] as String?,
        metaAlunoId: data['meta_aluno_id'] as String?,
      );

  static ListaAlunosStruct? maybeFromMap(dynamic data) => data is Map
      ? ListaAlunosStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'nome': _nome,
        'email': _email,
        'turma': _turma,
        'user_id': _userId,
        'telefone': _telefone,
        'franquia_id': _franquiaId,
        'alunos_turma': _alunosTurma,
        'meta_aluno_id': _metaAlunoId,
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
        'turma': serializeParam(
          _turma,
          ParamType.String,
        ),
        'user_id': serializeParam(
          _userId,
          ParamType.String,
        ),
        'telefone': serializeParam(
          _telefone,
          ParamType.String,
        ),
        'franquia_id': serializeParam(
          _franquiaId,
          ParamType.String,
        ),
        'alunos_turma': serializeParam(
          _alunosTurma,
          ParamType.String,
        ),
        'meta_aluno_id': serializeParam(
          _metaAlunoId,
          ParamType.String,
        ),
      }.withoutNulls;

  static ListaAlunosStruct fromSerializableMap(Map<String, dynamic> data) =>
      ListaAlunosStruct(
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
        turma: deserializeParam(
          data['turma'],
          ParamType.String,
          false,
        ),
        userId: deserializeParam(
          data['user_id'],
          ParamType.String,
          false,
        ),
        telefone: deserializeParam(
          data['telefone'],
          ParamType.String,
          false,
        ),
        franquiaId: deserializeParam(
          data['franquia_id'],
          ParamType.String,
          false,
        ),
        alunosTurma: deserializeParam(
          data['alunos_turma'],
          ParamType.String,
          false,
        ),
        metaAlunoId: deserializeParam(
          data['meta_aluno_id'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ListaAlunosStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ListaAlunosStruct &&
        nome == other.nome &&
        email == other.email &&
        turma == other.turma &&
        userId == other.userId &&
        telefone == other.telefone &&
        franquiaId == other.franquiaId &&
        alunosTurma == other.alunosTurma &&
        metaAlunoId == other.metaAlunoId;
  }

  @override
  int get hashCode => const ListEquality().hash([
        nome,
        email,
        turma,
        userId,
        telefone,
        franquiaId,
        alunosTurma,
        metaAlunoId
      ]);
}

ListaAlunosStruct createListaAlunosStruct({
  String? nome,
  String? email,
  String? turma,
  String? userId,
  String? telefone,
  String? franquiaId,
  String? alunosTurma,
  String? metaAlunoId,
}) =>
    ListaAlunosStruct(
      nome: nome,
      email: email,
      turma: turma,
      userId: userId,
      telefone: telefone,
      franquiaId: franquiaId,
      alunosTurma: alunosTurma,
      metaAlunoId: metaAlunoId,
    );
