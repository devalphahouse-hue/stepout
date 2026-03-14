// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ConteudosAulaStruct extends BaseStruct {
  ConteudosAulaStruct({
    String? uuid,
    String? nomeConteudo,
  })  : _uuid = uuid,
        _nomeConteudo = nomeConteudo;

  // "uuid" field.
  String? _uuid;
  String get uuid => _uuid ?? '';
  set uuid(String? val) => _uuid = val;

  bool hasUuid() => _uuid != null;

  // "nome_conteudo" field.
  String? _nomeConteudo;
  String get nomeConteudo => _nomeConteudo ?? '';
  set nomeConteudo(String? val) => _nomeConteudo = val;

  bool hasNomeConteudo() => _nomeConteudo != null;

  static ConteudosAulaStruct fromMap(Map<String, dynamic> data) =>
      ConteudosAulaStruct(
        uuid: data['uuid'] as String?,
        nomeConteudo: data['nome_conteudo'] as String?,
      );

  static ConteudosAulaStruct? maybeFromMap(dynamic data) => data is Map
      ? ConteudosAulaStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'uuid': _uuid,
        'nome_conteudo': _nomeConteudo,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'uuid': serializeParam(
          _uuid,
          ParamType.String,
        ),
        'nome_conteudo': serializeParam(
          _nomeConteudo,
          ParamType.String,
        ),
      }.withoutNulls;

  static ConteudosAulaStruct fromSerializableMap(Map<String, dynamic> data) =>
      ConteudosAulaStruct(
        uuid: deserializeParam(
          data['uuid'],
          ParamType.String,
          false,
        ),
        nomeConteudo: deserializeParam(
          data['nome_conteudo'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ConteudosAulaStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ConteudosAulaStruct &&
        uuid == other.uuid &&
        nomeConteudo == other.nomeConteudo;
  }

  @override
  int get hashCode => const ListEquality().hash([uuid, nomeConteudo]);
}

ConteudosAulaStruct createConteudosAulaStruct({
  String? uuid,
  String? nomeConteudo,
}) =>
    ConteudosAulaStruct(
      uuid: uuid,
      nomeConteudo: nomeConteudo,
    );
