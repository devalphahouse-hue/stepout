// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AlunosAulaStruct extends BaseStruct {
  AlunosAulaStruct({
    String? nome,
    String? uuid,
  })  : _nome = nome,
        _uuid = uuid;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "uuid" field.
  String? _uuid;
  String get uuid => _uuid ?? '';
  set uuid(String? val) => _uuid = val;

  bool hasUuid() => _uuid != null;

  static AlunosAulaStruct fromMap(Map<String, dynamic> data) =>
      AlunosAulaStruct(
        nome: data['nome'] as String?,
        uuid: data['uuid'] as String?,
      );

  static AlunosAulaStruct? maybeFromMap(dynamic data) => data is Map
      ? AlunosAulaStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'nome': _nome,
        'uuid': _uuid,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'uuid': serializeParam(
          _uuid,
          ParamType.String,
        ),
      }.withoutNulls;

  static AlunosAulaStruct fromSerializableMap(Map<String, dynamic> data) =>
      AlunosAulaStruct(
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        uuid: deserializeParam(
          data['uuid'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AlunosAulaStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AlunosAulaStruct &&
        nome == other.nome &&
        uuid == other.uuid;
  }

  @override
  int get hashCode => const ListEquality().hash([nome, uuid]);
}

AlunosAulaStruct createAlunosAulaStruct({
  String? nome,
  String? uuid,
}) =>
    AlunosAulaStruct(
      nome: nome,
      uuid: uuid,
    );
