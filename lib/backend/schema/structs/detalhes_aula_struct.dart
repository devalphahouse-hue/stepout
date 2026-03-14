// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DetalhesAulaStruct extends BaseStruct {
  DetalhesAulaStruct({
    String? id,
    String? turma,
    String? nomeTurma,
    String? statusAula,
    String? nivelInicio,
    String? datetimeinicioAula,
    String? datetimeTerminoaula,
    String? anotacoesComentarios,
    String? professorResponsavelNome,
    String? professorResponsavelUuid,
    List<AlunosAulaStruct>? alunosPresentes,
    List<AlunosAulaStruct>? alunosConvidados,
    List<ConteudosAulaStruct>? conteudosUtilizados,
    List<ConteudosAulaStruct>? conteudosVinculados,
  })  : _id = id,
        _turma = turma,
        _nomeTurma = nomeTurma,
        _statusAula = statusAula,
        _nivelInicio = nivelInicio,
        _datetimeinicioAula = datetimeinicioAula,
        _datetimeTerminoaula = datetimeTerminoaula,
        _anotacoesComentarios = anotacoesComentarios,
        _professorResponsavelNome = professorResponsavelNome,
        _professorResponsavelUuid = professorResponsavelUuid,
        _alunosPresentes = alunosPresentes,
        _alunosConvidados = alunosConvidados,
        _conteudosUtilizados = conteudosUtilizados,
        _conteudosVinculados = conteudosVinculados;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "turma" field.
  String? _turma;
  String get turma => _turma ?? '';
  set turma(String? val) => _turma = val;

  bool hasTurma() => _turma != null;

  // "nome_turma" field.
  String? _nomeTurma;
  String get nomeTurma => _nomeTurma ?? '';
  set nomeTurma(String? val) => _nomeTurma = val;

  bool hasNomeTurma() => _nomeTurma != null;

  // "status_aula" field.
  String? _statusAula;
  String get statusAula => _statusAula ?? '';
  set statusAula(String? val) => _statusAula = val;

  bool hasStatusAula() => _statusAula != null;

  // "nivel_inicio" field.
  String? _nivelInicio;
  String get nivelInicio => _nivelInicio ?? '';
  set nivelInicio(String? val) => _nivelInicio = val;

  bool hasNivelInicio() => _nivelInicio != null;

  // "datetimeinicio_aula" field.
  String? _datetimeinicioAula;
  String get datetimeinicioAula => _datetimeinicioAula ?? '';
  set datetimeinicioAula(String? val) => _datetimeinicioAula = val;

  bool hasDatetimeinicioAula() => _datetimeinicioAula != null;

  // "datetime_terminoaula" field.
  String? _datetimeTerminoaula;
  String get datetimeTerminoaula => _datetimeTerminoaula ?? '';
  set datetimeTerminoaula(String? val) => _datetimeTerminoaula = val;

  bool hasDatetimeTerminoaula() => _datetimeTerminoaula != null;

  // "anotacoes_comentarios" field.
  String? _anotacoesComentarios;
  String get anotacoesComentarios => _anotacoesComentarios ?? '';
  set anotacoesComentarios(String? val) => _anotacoesComentarios = val;

  bool hasAnotacoesComentarios() => _anotacoesComentarios != null;

  // "professor_responsavel_nome" field.
  String? _professorResponsavelNome;
  String get professorResponsavelNome => _professorResponsavelNome ?? '';
  set professorResponsavelNome(String? val) => _professorResponsavelNome = val;

  bool hasProfessorResponsavelNome() => _professorResponsavelNome != null;

  // "professor_responsavel_uuid" field.
  String? _professorResponsavelUuid;
  String get professorResponsavelUuid => _professorResponsavelUuid ?? '';
  set professorResponsavelUuid(String? val) => _professorResponsavelUuid = val;

  bool hasProfessorResponsavelUuid() => _professorResponsavelUuid != null;

  // "alunos_presentes" field.
  List<AlunosAulaStruct>? _alunosPresentes;
  List<AlunosAulaStruct> get alunosPresentes => _alunosPresentes ?? const [];
  set alunosPresentes(List<AlunosAulaStruct>? val) => _alunosPresentes = val;

  void updateAlunosPresentes(Function(List<AlunosAulaStruct>) updateFn) {
    updateFn(_alunosPresentes ??= []);
  }

  bool hasAlunosPresentes() => _alunosPresentes != null;

  // "alunos_convidados" field.
  List<AlunosAulaStruct>? _alunosConvidados;
  List<AlunosAulaStruct> get alunosConvidados => _alunosConvidados ?? const [];
  set alunosConvidados(List<AlunosAulaStruct>? val) => _alunosConvidados = val;

  void updateAlunosConvidados(Function(List<AlunosAulaStruct>) updateFn) {
    updateFn(_alunosConvidados ??= []);
  }

  bool hasAlunosConvidados() => _alunosConvidados != null;

  // "conteudos_utilizados" field.
  List<ConteudosAulaStruct>? _conteudosUtilizados;
  List<ConteudosAulaStruct> get conteudosUtilizados =>
      _conteudosUtilizados ?? const [];
  set conteudosUtilizados(List<ConteudosAulaStruct>? val) =>
      _conteudosUtilizados = val;

  void updateConteudosUtilizados(Function(List<ConteudosAulaStruct>) updateFn) {
    updateFn(_conteudosUtilizados ??= []);
  }

  bool hasConteudosUtilizados() => _conteudosUtilizados != null;

  // "conteudos_vinculados" field.
  List<ConteudosAulaStruct>? _conteudosVinculados;
  List<ConteudosAulaStruct> get conteudosVinculados =>
      _conteudosVinculados ?? const [];
  set conteudosVinculados(List<ConteudosAulaStruct>? val) =>
      _conteudosVinculados = val;

  void updateConteudosVinculados(Function(List<ConteudosAulaStruct>) updateFn) {
    updateFn(_conteudosVinculados ??= []);
  }

  bool hasConteudosVinculados() => _conteudosVinculados != null;

  static DetalhesAulaStruct fromMap(Map<String, dynamic> data) =>
      DetalhesAulaStruct(
        id: data['id'] as String?,
        turma: data['turma'] as String?,
        nomeTurma: data['nome_turma'] as String?,
        statusAula: data['status_aula'] as String?,
        nivelInicio: data['nivel_inicio'] as String?,
        datetimeinicioAula: data['datetimeinicio_aula'] as String?,
        datetimeTerminoaula: data['datetime_terminoaula'] as String?,
        anotacoesComentarios: data['anotacoes_comentarios'] as String?,
        professorResponsavelNome: data['professor_responsavel_nome'] as String?,
        professorResponsavelUuid: data['professor_responsavel_uuid'] as String?,
        alunosPresentes: getStructList(
          data['alunos_presentes'],
          AlunosAulaStruct.fromMap,
        ),
        alunosConvidados: getStructList(
          data['alunos_convidados'],
          AlunosAulaStruct.fromMap,
        ),
        conteudosUtilizados: getStructList(
          data['conteudos_utilizados'],
          ConteudosAulaStruct.fromMap,
        ),
        conteudosVinculados: getStructList(
          data['conteudos_vinculados'],
          ConteudosAulaStruct.fromMap,
        ),
      );

  static DetalhesAulaStruct? maybeFromMap(dynamic data) => data is Map
      ? DetalhesAulaStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'turma': _turma,
        'nome_turma': _nomeTurma,
        'status_aula': _statusAula,
        'nivel_inicio': _nivelInicio,
        'datetimeinicio_aula': _datetimeinicioAula,
        'datetime_terminoaula': _datetimeTerminoaula,
        'anotacoes_comentarios': _anotacoesComentarios,
        'professor_responsavel_nome': _professorResponsavelNome,
        'professor_responsavel_uuid': _professorResponsavelUuid,
        'alunos_presentes': _alunosPresentes?.map((e) => e.toMap()).toList(),
        'alunos_convidados': _alunosConvidados?.map((e) => e.toMap()).toList(),
        'conteudos_utilizados':
            _conteudosUtilizados?.map((e) => e.toMap()).toList(),
        'conteudos_vinculados':
            _conteudosVinculados?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'turma': serializeParam(
          _turma,
          ParamType.String,
        ),
        'nome_turma': serializeParam(
          _nomeTurma,
          ParamType.String,
        ),
        'status_aula': serializeParam(
          _statusAula,
          ParamType.String,
        ),
        'nivel_inicio': serializeParam(
          _nivelInicio,
          ParamType.String,
        ),
        'datetimeinicio_aula': serializeParam(
          _datetimeinicioAula,
          ParamType.String,
        ),
        'datetime_terminoaula': serializeParam(
          _datetimeTerminoaula,
          ParamType.String,
        ),
        'anotacoes_comentarios': serializeParam(
          _anotacoesComentarios,
          ParamType.String,
        ),
        'professor_responsavel_nome': serializeParam(
          _professorResponsavelNome,
          ParamType.String,
        ),
        'professor_responsavel_uuid': serializeParam(
          _professorResponsavelUuid,
          ParamType.String,
        ),
        'alunos_presentes': serializeParam(
          _alunosPresentes,
          ParamType.DataStruct,
          isList: true,
        ),
        'alunos_convidados': serializeParam(
          _alunosConvidados,
          ParamType.DataStruct,
          isList: true,
        ),
        'conteudos_utilizados': serializeParam(
          _conteudosUtilizados,
          ParamType.DataStruct,
          isList: true,
        ),
        'conteudos_vinculados': serializeParam(
          _conteudosVinculados,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static DetalhesAulaStruct fromSerializableMap(Map<String, dynamic> data) =>
      DetalhesAulaStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        turma: deserializeParam(
          data['turma'],
          ParamType.String,
          false,
        ),
        nomeTurma: deserializeParam(
          data['nome_turma'],
          ParamType.String,
          false,
        ),
        statusAula: deserializeParam(
          data['status_aula'],
          ParamType.String,
          false,
        ),
        nivelInicio: deserializeParam(
          data['nivel_inicio'],
          ParamType.String,
          false,
        ),
        datetimeinicioAula: deserializeParam(
          data['datetimeinicio_aula'],
          ParamType.String,
          false,
        ),
        datetimeTerminoaula: deserializeParam(
          data['datetime_terminoaula'],
          ParamType.String,
          false,
        ),
        anotacoesComentarios: deserializeParam(
          data['anotacoes_comentarios'],
          ParamType.String,
          false,
        ),
        professorResponsavelNome: deserializeParam(
          data['professor_responsavel_nome'],
          ParamType.String,
          false,
        ),
        professorResponsavelUuid: deserializeParam(
          data['professor_responsavel_uuid'],
          ParamType.String,
          false,
        ),
        alunosPresentes: deserializeStructParam<AlunosAulaStruct>(
          data['alunos_presentes'],
          ParamType.DataStruct,
          true,
          structBuilder: AlunosAulaStruct.fromSerializableMap,
        ),
        alunosConvidados: deserializeStructParam<AlunosAulaStruct>(
          data['alunos_convidados'],
          ParamType.DataStruct,
          true,
          structBuilder: AlunosAulaStruct.fromSerializableMap,
        ),
        conteudosUtilizados: deserializeStructParam<ConteudosAulaStruct>(
          data['conteudos_utilizados'],
          ParamType.DataStruct,
          true,
          structBuilder: ConteudosAulaStruct.fromSerializableMap,
        ),
        conteudosVinculados: deserializeStructParam<ConteudosAulaStruct>(
          data['conteudos_vinculados'],
          ParamType.DataStruct,
          true,
          structBuilder: ConteudosAulaStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'DetalhesAulaStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is DetalhesAulaStruct &&
        id == other.id &&
        turma == other.turma &&
        nomeTurma == other.nomeTurma &&
        statusAula == other.statusAula &&
        nivelInicio == other.nivelInicio &&
        datetimeinicioAula == other.datetimeinicioAula &&
        datetimeTerminoaula == other.datetimeTerminoaula &&
        anotacoesComentarios == other.anotacoesComentarios &&
        professorResponsavelNome == other.professorResponsavelNome &&
        professorResponsavelUuid == other.professorResponsavelUuid &&
        listEquality.equals(alunosPresentes, other.alunosPresentes) &&
        listEquality.equals(alunosConvidados, other.alunosConvidados) &&
        listEquality.equals(conteudosUtilizados, other.conteudosUtilizados) &&
        listEquality.equals(conteudosVinculados, other.conteudosVinculados);
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        turma,
        nomeTurma,
        statusAula,
        nivelInicio,
        datetimeinicioAula,
        datetimeTerminoaula,
        anotacoesComentarios,
        professorResponsavelNome,
        professorResponsavelUuid,
        alunosPresentes,
        alunosConvidados,
        conteudosUtilizados,
        conteudosVinculados
      ]);
}

DetalhesAulaStruct createDetalhesAulaStruct({
  String? id,
  String? turma,
  String? nomeTurma,
  String? statusAula,
  String? nivelInicio,
  String? datetimeinicioAula,
  String? datetimeTerminoaula,
  String? anotacoesComentarios,
  String? professorResponsavelNome,
  String? professorResponsavelUuid,
}) =>
    DetalhesAulaStruct(
      id: id,
      turma: turma,
      nomeTurma: nomeTurma,
      statusAula: statusAula,
      nivelInicio: nivelInicio,
      datetimeinicioAula: datetimeinicioAula,
      datetimeTerminoaula: datetimeTerminoaula,
      anotacoesComentarios: anotacoesComentarios,
      professorResponsavelNome: professorResponsavelNome,
      professorResponsavelUuid: professorResponsavelUuid,
    );
