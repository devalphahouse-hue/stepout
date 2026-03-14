import '../database.dart';

class MetaProfessorTable extends SupabaseTable<MetaProfessorRow> {
  @override
  String get tableName => 'meta_professor';

  @override
  MetaProfessorRow createRow(Map<String, dynamic> data) =>
      MetaProfessorRow(data);
}

class MetaProfessorRow extends SupabaseDataRow {
  MetaProfessorRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MetaProfessorTable();

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get sobreOProfessor => getField<String>('sobre_o_professor');
  set sobreOProfessor(String? value) =>
      setField<String>('sobre_o_professor', value);

  String? get curriculoProfessor => getField<String>('curriculo_professor');
  set curriculoProfessor(String? value) =>
      setField<String>('curriculo_professor', value);

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get franquia => getField<String>('franquia');
  set franquia(String? value) => setField<String>('franquia', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  List<String> get turmasDoProfessor =>
      getListField<String>('turmas_do_professor');
  set turmasDoProfessor(List<String>? value) =>
      setListField<String>('turmas_do_professor', value);
}
