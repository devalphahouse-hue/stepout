// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AlunosPorTurmaStruct extends BaseStruct {
  AlunosPorTurmaStruct({
    String? nome,
    String? id,
  })  : _nome = nome,
        _id = id;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  static AlunosPorTurmaStruct fromMap(Map<String, dynamic> data) =>
      AlunosPorTurmaStruct(
        nome: data['nome'] as String?,
        id: data['id'] as String?,
      );

  static AlunosPorTurmaStruct? maybeFromMap(dynamic data) => data is Map
      ? AlunosPorTurmaStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'nome': _nome,
        'id': _id,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
      }.withoutNulls;

  static AlunosPorTurmaStruct fromSerializableMap(Map<String, dynamic> data) =>
      AlunosPorTurmaStruct(
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AlunosPorTurmaStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AlunosPorTurmaStruct &&
        nome == other.nome &&
        id == other.id;
  }

  @override
  int get hashCode => const ListEquality().hash([nome, id]);
}

AlunosPorTurmaStruct createAlunosPorTurmaStruct({
  String? nome,
  String? id,
}) =>
    AlunosPorTurmaStruct(
      nome: nome,
      id: id,
    );
