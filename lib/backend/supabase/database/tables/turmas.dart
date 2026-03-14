import '../database.dart';

class TurmasTable extends SupabaseTable<TurmasRow> {
  @override
  String get tableName => 'turmas';

  @override
  TurmasRow createRow(Map<String, dynamic> data) => TurmasRow(data);
}

class TurmasRow extends SupabaseDataRow {
  TurmasRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TurmasTable();

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get nomeDaTurma => getField<String>('nome_da_turma');
  set nomeDaTurma(String? value) => setField<String>('nome_da_turma', value);

  DateTime? get dataInicio => getField<DateTime>('data_inicio');
  set dataInicio(DateTime? value) => setField<DateTime>('data_inicio', value);

  String? get moduloNivelTurma => getField<String>('modulo_nivel_turma');
  set moduloNivelTurma(String? value) =>
      setField<String>('modulo_nivel_turma', value);

  List<dynamic> get agendaAulas => getListField<dynamic>('agenda_aulas');
  set agendaAulas(List<dynamic>? value) =>
      setListField<dynamic>('agenda_aulas', value);

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get professorResponsavel => getField<String>('professor_responsavel');
  set professorResponsavel(String? value) =>
      setField<String>('professor_responsavel', value);

  String? get idFranquia => getField<String>('id_franquia');
  set idFranquia(String? value) => setField<String>('id_franquia', value);

  List<String> get alunosTurma => getListField<String>('alunos_turma');
  set alunosTurma(List<String>? value) =>
      setListField<String>('alunos_turma', value);
}
