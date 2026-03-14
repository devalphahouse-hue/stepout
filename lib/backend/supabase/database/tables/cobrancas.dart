import '../database.dart';

class CobrancasTable extends SupabaseTable<CobrancasRow> {
  @override
  String get tableName => 'cobrancas';

  @override
  CobrancasRow createRow(Map<String, dynamic> data) => CobrancasRow(data);
}

class CobrancasRow extends SupabaseDataRow {
  CobrancasRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CobrancasTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get idCobrancaAsaas => getField<String>('id_cobranca_asaas');
  set idCobrancaAsaas(String? value) =>
      setField<String>('id_cobranca_asaas', value);

  double? get valor => getField<double>('valor');
  set valor(double? value) => setField<double>('valor', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get tipoCobranca => getField<String>('tipo_cobranca');
  set tipoCobranca(String? value) => setField<String>('tipo_cobranca', value);

  String? get formaPagamento => getField<String>('forma_pagamento');
  set formaPagamento(String? value) =>
      setField<String>('forma_pagamento', value);

  String? get indicacao => getField<String>('indicacao');
  set indicacao(String? value) => setField<String>('indicacao', value);

  String? get statusCobranca => getField<String>('status_cobranca');
  set statusCobranca(String? value) =>
      setField<String>('status_cobranca', value);

  String? get ifFranquia => getField<String>('if_franquia');
  set ifFranquia(String? value) => setField<String>('if_franquia', value);

  String? get planoAluno => getField<String>('plano_aluno');
  set planoAluno(String? value) => setField<String>('plano_aluno', value);

  int? get numParcelas => getField<int>('num_parcelas');
  set numParcelas(int? value) => setField<int>('num_parcelas', value);

  double? get valorParcelas => getField<double>('valor_parcelas');
  set valorParcelas(double? value) => setField<double>('valor_parcelas', value);

  int? get desconto => getField<int>('desconto');
  set desconto(int? value) => setField<int>('desconto', value);

  String? get statusPlat => getField<String>('status_plat');
  set statusPlat(String? value) => setField<String>('status_plat', value);
}
