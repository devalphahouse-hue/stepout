import '../database.dart';

class AvisosTable extends SupabaseTable<AvisosRow> {
  @override
  String get tableName => 'avisos';

  @override
  AvisosRow createRow(Map<String, dynamic> data) => AvisosRow(data);
}

class AvisosRow extends SupabaseDataRow {
  AvisosRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AvisosTable();

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get tituloAviso => getField<String>('titulo_aviso');
  set tituloAviso(String? value) => setField<String>('titulo_aviso', value);

  String? get conteudoAviso => getField<String>('conteudo_aviso');
  set conteudoAviso(String? value) => setField<String>('conteudo_aviso', value);

  bool? get statusAviso => getField<bool>('status_aviso');
  set statusAviso(bool? value) => setField<bool>('status_aviso', value);

  bool? get avisoFranqueado => getField<bool>('aviso_franqueado');
  set avisoFranqueado(bool? value) => setField<bool>('aviso_franqueado', value);

  bool? get avisoProfessor => getField<bool>('aviso_professor');
  set avisoProfessor(bool? value) => setField<bool>('aviso_professor', value);

  bool? get avisoAluno => getField<bool>('aviso_aluno');
  set avisoAluno(bool? value) => setField<bool>('aviso_aluno', value);

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);
}
