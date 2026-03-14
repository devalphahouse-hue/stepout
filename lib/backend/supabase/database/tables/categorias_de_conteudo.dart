import '../database.dart';

class CategoriasDeConteudoTable extends SupabaseTable<CategoriasDeConteudoRow> {
  @override
  String get tableName => 'categorias_de_conteudo';

  @override
  CategoriasDeConteudoRow createRow(Map<String, dynamic> data) =>
      CategoriasDeConteudoRow(data);
}

class CategoriasDeConteudoRow extends SupabaseDataRow {
  CategoriasDeConteudoRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CategoriasDeConteudoTable();

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get nomeCategoria => getField<String>('nome_categoria');
  set nomeCategoria(String? value) => setField<String>('nome_categoria', value);

  String? get imagemCategoria => getField<String>('imagem_categoria');
  set imagemCategoria(String? value) =>
      setField<String>('imagem_categoria', value);

  bool? get statusCategoria => getField<bool>('status_categoria');
  set statusCategoria(bool? value) => setField<bool>('status_categoria', value);

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);
}
