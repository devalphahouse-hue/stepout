import '../database.dart';

class MuralTable extends SupabaseTable<MuralRow> {
  @override
  String get tableName => 'mural';

  @override
  MuralRow createRow(Map<String, dynamic> data) => MuralRow(data);
}

class MuralRow extends SupabaseDataRow {
  MuralRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MuralTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get conteudo => getField<String>('conteudo');
  set conteudo(String? value) => setField<String>('conteudo', value);

  String? get idaluno => getField<String>('idaluno');
  set idaluno(String? value) => setField<String>('idaluno', value);

  String? get nomeProfessor => getField<String>('nome_professor');
  set nomeProfessor(String? value) => setField<String>('nome_professor', value);
}
