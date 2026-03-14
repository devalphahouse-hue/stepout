import '../database.dart';

class ConteudosTable extends SupabaseTable<ConteudosRow> {
  @override
  String get tableName => 'conteudos';

  @override
  ConteudosRow createRow(Map<String, dynamic> data) => ConteudosRow(data);
}

class ConteudosRow extends SupabaseDataRow {
  ConteudosRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ConteudosTable();

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get nomeConteudo => getField<String>('nome_conteudo');
  set nomeConteudo(String? value) => setField<String>('nome_conteudo', value);

  String? get linkConteudo => getField<String>('link_conteudo');
  set linkConteudo(String? value) => setField<String>('link_conteudo', value);

  bool? get statusConteudo => getField<bool>('status_conteudo');
  set statusConteudo(bool? value) => setField<bool>('status_conteudo', value);

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get moduloConteudo => getField<String>('modulo_conteudo');
  set moduloConteudo(String? value) =>
      setField<String>('modulo_conteudo', value);

  String? get categoriaConteudo => getField<String>('categoria_conteudo');
  set categoriaConteudo(String? value) =>
      setField<String>('categoria_conteudo', value);
}
