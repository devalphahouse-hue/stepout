import '../database.dart';

class DescontosTable extends SupabaseTable<DescontosRow> {
  @override
  String get tableName => 'descontos';

  @override
  DescontosRow createRow(Map<String, dynamic> data) => DescontosRow(data);
}

class DescontosRow extends SupabaseDataRow {
  DescontosRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DescontosTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get nomeDesconto => getField<String>('nome_desconto');
  set nomeDesconto(String? value) => setField<String>('nome_desconto', value);

  int? get valorDesconto => getField<int>('valor_desconto');
  set valorDesconto(int? value) => setField<int>('valor_desconto', value);
}
