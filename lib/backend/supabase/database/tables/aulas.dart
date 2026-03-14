import '../database.dart';

class AulasTable extends SupabaseTable<AulasRow> {
  @override
  String get tableName => 'Aulas';

  @override
  AulasRow createRow(Map<String, dynamic> data) => AulasRow(data);
}

class AulasRow extends SupabaseDataRow {
  AulasRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AulasTable();

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get nivelInicio => getField<String>('nivel_inicio');
  set nivelInicio(String? value) => setField<String>('nivel_inicio', value);

  DateTime? get datetimeinicioAula => getField<DateTime>('datetimeinicio_aula');
  set datetimeinicioAula(DateTime? value) =>
      setField<DateTime>('datetimeinicio_aula', value);

  String? get statusAula => getField<String>('status_aula');
  set statusAula(String? value) => setField<String>('status_aula', value);

  String? get anotacoesComentarios => getField<String>('anotacoes_comentarios');
  set anotacoesComentarios(String? value) =>
      setField<String>('anotacoes_comentarios', value);

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get professorResponsavel => getField<String>('professor_responsavel');
  set professorResponsavel(String? value) =>
      setField<String>('professor_responsavel', value);

  String? get turma => getField<String>('turma');
  set turma(String? value) => setField<String>('turma', value);

  List<String> get conteudosVinculados =>
      getListField<String>('conteudos_vinculados');
  set conteudosVinculados(List<String>? value) =>
      setListField<String>('conteudos_vinculados', value);

  List<String> get conteudosUtilizados =>
      getListField<String>('conteudos_utilizados');
  set conteudosUtilizados(List<String>? value) =>
      setListField<String>('conteudos_utilizados', value);

  String? get franquia => getField<String>('franquia');
  set franquia(String? value) => setField<String>('franquia', value);

  DateTime? get datetimeTerminoaula =>
      getField<DateTime>('datetime_terminoaula');
  set datetimeTerminoaula(DateTime? value) =>
      setField<DateTime>('datetime_terminoaula', value);

  List<String> get alunosConvidados =>
      getListField<String>('alunos_convidados');
  set alunosConvidados(List<String>? value) =>
      setListField<String>('alunos_convidados', value);

  List<String> get alunosPresentes => getListField<String>('alunos_presentes');
  set alunosPresentes(List<String>? value) =>
      setListField<String>('alunos_presentes', value);

  bool? get checkinProfessor => getField<bool>('checkin_professor');
  set checkinProfessor(bool? value) =>
      setField<bool>('checkin_professor', value);

  String? get muralAula => getField<String>('mural_aula');
  set muralAula(String? value) => setField<String>('mural_aula', value);
}
