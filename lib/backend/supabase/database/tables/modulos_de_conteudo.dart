import '../database.dart';

class ModulosDeConteudoTable extends SupabaseTable<ModulosDeConteudoRow> {
  @override
  String get tableName => 'modulos_de_conteudo';

  @override
  ModulosDeConteudoRow createRow(Map<String, dynamic> data) =>
      ModulosDeConteudoRow(data);
}

class ModulosDeConteudoRow extends SupabaseDataRow {
  ModulosDeConteudoRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ModulosDeConteudoTable();

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get nomeModulo => getField<String>('nome_modulo');
  set nomeModulo(String? value) => setField<String>('nome_modulo', value);

  bool? get statusModulo => getField<bool>('status_modulo');
  set statusModulo(bool? value) => setField<bool>('status_modulo', value);

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  List<String> get categoriasVinculadas =>
      getListField<String>('categorias_vinculadas');
  set categoriasVinculadas(List<String>? value) =>
      setListField<String>('categorias_vinculadas', value);

  String? get nivelModulo => getField<String>('nivel_modulo');
  set nivelModulo(String? value) => setField<String>('nivel_modulo', value);
}
