import '../database.dart';

class PlanosTable extends SupabaseTable<PlanosRow> {
  @override
  String get tableName => 'planos';

  @override
  PlanosRow createRow(Map<String, dynamic> data) => PlanosRow(data);
}

class PlanosRow extends SupabaseDataRow {
  PlanosRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PlanosTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get nomePlano => getField<String>('nome_plano');
  set nomePlano(String? value) => setField<String>('nome_plano', value);

  double? get precoPlano => getField<double>('preco_plano');
  set precoPlano(double? value) => setField<double>('preco_plano', value);
}
