import '../database.dart';

class MetaAlunosTable extends SupabaseTable<MetaAlunosRow> {
  @override
  String get tableName => 'meta_alunos';

  @override
  MetaAlunosRow createRow(Map<String, dynamic> data) => MetaAlunosRow(data);
}

class MetaAlunosRow extends SupabaseDataRow {
  MetaAlunosRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MetaAlunosTable();

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get planoVigente => getField<String>('plano_vigente');
  set planoVigente(String? value) => setField<String>('plano_vigente', value);

  String? get descontoVigente => getField<String>('desconto_vigente');
  set descontoVigente(String? value) =>
      setField<String>('desconto_vigente', value);

  String? get comoConheceu => getField<String>('como_conheceu');
  set comoConheceu(String? value) => setField<String>('como_conheceu', value);

  String? get dataAulaExperimental =>
      getField<String>('data_aula_experimental');
  set dataAulaExperimental(String? value) =>
      setField<String>('data_aula_experimental', value);

  String? get objetivoDoAluno => getField<String>('objetivo_do_aluno');
  set objetivoDoAluno(String? value) =>
      setField<String>('objetivo_do_aluno', value);

  String? get experienciasDoAluno => getField<String>('experiencias_do_aluno');
  set experienciasDoAluno(String? value) =>
      setField<String>('experiencias_do_aluno', value);

  String? get disponilidadeEPreferencias =>
      getField<String>('disponilidade_e_preferencias');
  set disponilidadeEPreferencias(String? value) =>
      setField<String>('disponilidade_e_preferencias', value);

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get franquiaId => getField<String>('franquia_id');
  set franquiaId(String? value) => setField<String>('franquia_id', value);

  String? get turma => getField<String>('turma');
  set turma(String? value) => setField<String>('turma', value);
}
