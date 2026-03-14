import '../database.dart';

class TreinamentosTable extends SupabaseTable<TreinamentosRow> {
  @override
  String get tableName => 'treinamentos';

  @override
  TreinamentosRow createRow(Map<String, dynamic> data) => TreinamentosRow(data);
}

class TreinamentosRow extends SupabaseDataRow {
  TreinamentosRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TreinamentosTable();

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get tituloTreinamento => getField<String>('titulo_treinamento');
  set tituloTreinamento(String? value) =>
      setField<String>('titulo_treinamento', value);

  String? get linkTreinamento => getField<String>('link_treinamento');
  set linkTreinamento(String? value) =>
      setField<String>('link_treinamento', value);

  bool? get statusTreinamento => getField<bool>('status_treinamento');
  set statusTreinamento(bool? value) =>
      setField<bool>('status_treinamento', value);

  bool? get treinamentoFranqueado => getField<bool>('treinamento_franqueado');
  set treinamentoFranqueado(bool? value) =>
      setField<bool>('treinamento_franqueado', value);

  bool? get professorTreinamento => getField<bool>('professor_treinamento');
  set professorTreinamento(bool? value) =>
      setField<bool>('professor_treinamento', value);

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);
}
