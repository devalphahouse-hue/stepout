// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AgendaAulasStruct extends BaseStruct {
  AgendaAulasStruct({
    String? dia,
    String? horarioFinal,
    String? horarioInicio,
  })  : _dia = dia,
        _horarioFinal = horarioFinal,
        _horarioInicio = horarioInicio;

  // "dia" field.
  String? _dia;
  String get dia => _dia ?? '';
  set dia(String? val) => _dia = val;

  bool hasDia() => _dia != null;

  // "horarioFinal" field.
  String? _horarioFinal;
  String get horarioFinal => _horarioFinal ?? '';
  set horarioFinal(String? val) => _horarioFinal = val;

  bool hasHorarioFinal() => _horarioFinal != null;

  // "horarioInicio" field.
  String? _horarioInicio;
  String get horarioInicio => _horarioInicio ?? '';
  set horarioInicio(String? val) => _horarioInicio = val;

  bool hasHorarioInicio() => _horarioInicio != null;

  static AgendaAulasStruct fromMap(Map<String, dynamic> data) =>
      AgendaAulasStruct(
        dia: data['dia'] as String?,
        horarioFinal: data['horarioFinal'] as String?,
        horarioInicio: data['horarioInicio'] as String?,
      );

  static AgendaAulasStruct? maybeFromMap(dynamic data) => data is Map
      ? AgendaAulasStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'dia': _dia,
        'horarioFinal': _horarioFinal,
        'horarioInicio': _horarioInicio,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'dia': serializeParam(
          _dia,
          ParamType.String,
        ),
        'horarioFinal': serializeParam(
          _horarioFinal,
          ParamType.String,
        ),
        'horarioInicio': serializeParam(
          _horarioInicio,
          ParamType.String,
        ),
      }.withoutNulls;

  static AgendaAulasStruct fromSerializableMap(Map<String, dynamic> data) =>
      AgendaAulasStruct(
        dia: deserializeParam(
          data['dia'],
          ParamType.String,
          false,
        ),
        horarioFinal: deserializeParam(
          data['horarioFinal'],
          ParamType.String,
          false,
        ),
        horarioInicio: deserializeParam(
          data['horarioInicio'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AgendaAulasStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AgendaAulasStruct &&
        dia == other.dia &&
        horarioFinal == other.horarioFinal &&
        horarioInicio == other.horarioInicio;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([dia, horarioFinal, horarioInicio]);
}

AgendaAulasStruct createAgendaAulasStruct({
  String? dia,
  String? horarioFinal,
  String? horarioInicio,
}) =>
    AgendaAulasStruct(
      dia: dia,
      horarioFinal: horarioFinal,
      horarioInicio: horarioInicio,
    );
