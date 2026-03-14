// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DiaCalendarioAulasStruct extends BaseStruct {
  DiaCalendarioAulasStruct({
    DateTime? diaHoraInicio,
    DateTime? diaHoraTermino,
  })  : _diaHoraInicio = diaHoraInicio,
        _diaHoraTermino = diaHoraTermino;

  // "dia_hora_inicio" field.
  DateTime? _diaHoraInicio;
  DateTime? get diaHoraInicio => _diaHoraInicio;
  set diaHoraInicio(DateTime? val) => _diaHoraInicio = val;

  bool hasDiaHoraInicio() => _diaHoraInicio != null;

  // "dia_hora_termino" field.
  DateTime? _diaHoraTermino;
  DateTime? get diaHoraTermino => _diaHoraTermino;
  set diaHoraTermino(DateTime? val) => _diaHoraTermino = val;

  bool hasDiaHoraTermino() => _diaHoraTermino != null;

  static DiaCalendarioAulasStruct fromMap(Map<String, dynamic> data) =>
      DiaCalendarioAulasStruct(
        diaHoraInicio: data['dia_hora_inicio'] as DateTime?,
        diaHoraTermino: data['dia_hora_termino'] as DateTime?,
      );

  static DiaCalendarioAulasStruct? maybeFromMap(dynamic data) => data is Map
      ? DiaCalendarioAulasStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'dia_hora_inicio': _diaHoraInicio,
        'dia_hora_termino': _diaHoraTermino,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'dia_hora_inicio': serializeParam(
          _diaHoraInicio,
          ParamType.DateTime,
        ),
        'dia_hora_termino': serializeParam(
          _diaHoraTermino,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static DiaCalendarioAulasStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      DiaCalendarioAulasStruct(
        diaHoraInicio: deserializeParam(
          data['dia_hora_inicio'],
          ParamType.DateTime,
          false,
        ),
        diaHoraTermino: deserializeParam(
          data['dia_hora_termino'],
          ParamType.DateTime,
          false,
        ),
      );

  @override
  String toString() => 'DiaCalendarioAulasStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DiaCalendarioAulasStruct &&
        diaHoraInicio == other.diaHoraInicio &&
        diaHoraTermino == other.diaHoraTermino;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([diaHoraInicio, diaHoraTermino]);
}

DiaCalendarioAulasStruct createDiaCalendarioAulasStruct({
  DateTime? diaHoraInicio,
  DateTime? diaHoraTermino,
}) =>
    DiaCalendarioAulasStruct(
      diaHoraInicio: diaHoraInicio,
      diaHoraTermino: diaHoraTermino,
    );
