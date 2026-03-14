// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class VinculacaoTurmasStruct extends BaseStruct {
  VinculacaoTurmasStruct({
    String? nomeTurma,
    String? idTurma,
  })  : _nomeTurma = nomeTurma,
        _idTurma = idTurma;

  // "nomeTurma" field.
  String? _nomeTurma;
  String get nomeTurma => _nomeTurma ?? '';
  set nomeTurma(String? val) => _nomeTurma = val;

  bool hasNomeTurma() => _nomeTurma != null;

  // "id_turma" field.
  String? _idTurma;
  String get idTurma => _idTurma ?? '';
  set idTurma(String? val) => _idTurma = val;

  bool hasIdTurma() => _idTurma != null;

  static VinculacaoTurmasStruct fromMap(Map<String, dynamic> data) =>
      VinculacaoTurmasStruct(
        nomeTurma: data['nomeTurma'] as String?,
        idTurma: data['id_turma'] as String?,
      );

  static VinculacaoTurmasStruct? maybeFromMap(dynamic data) => data is Map
      ? VinculacaoTurmasStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'nomeTurma': _nomeTurma,
        'id_turma': _idTurma,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'nomeTurma': serializeParam(
          _nomeTurma,
          ParamType.String,
        ),
        'id_turma': serializeParam(
          _idTurma,
          ParamType.String,
        ),
      }.withoutNulls;

  static VinculacaoTurmasStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      VinculacaoTurmasStruct(
        nomeTurma: deserializeParam(
          data['nomeTurma'],
          ParamType.String,
          false,
        ),
        idTurma: deserializeParam(
          data['id_turma'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'VinculacaoTurmasStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is VinculacaoTurmasStruct &&
        nomeTurma == other.nomeTurma &&
        idTurma == other.idTurma;
  }

  @override
  int get hashCode => const ListEquality().hash([nomeTurma, idTurma]);
}

VinculacaoTurmasStruct createVinculacaoTurmasStruct({
  String? nomeTurma,
  String? idTurma,
}) =>
    VinculacaoTurmasStruct(
      nomeTurma: nomeTurma,
      idTurma: idTurma,
    );
