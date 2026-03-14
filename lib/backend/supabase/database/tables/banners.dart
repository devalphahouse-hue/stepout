import '../database.dart';

class BannersTable extends SupabaseTable<BannersRow> {
  @override
  String get tableName => 'banners';

  @override
  BannersRow createRow(Map<String, dynamic> data) => BannersRow(data);
}

class BannersRow extends SupabaseDataRow {
  BannersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BannersTable();

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get tituloBanner => getField<String>('titulo_banner');
  set tituloBanner(String? value) => setField<String>('titulo_banner', value);

  bool? get statusBanner => getField<bool>('status_banner');
  set statusBanner(bool? value) => setField<bool>('status_banner', value);

  String? get imagemPc => getField<String>('imagem_pc');
  set imagemPc(String? value) => setField<String>('imagem_pc', value);

  String? get imagemMobile => getField<String>('imagem_mobile');
  set imagemMobile(String? value) => setField<String>('imagem_mobile', value);

  bool? get bannerFranqueado => getField<bool>('banner_franqueado');
  set bannerFranqueado(bool? value) =>
      setField<bool>('banner_franqueado', value);

  bool? get bannerProfessor => getField<bool>('banner_professor');
  set bannerProfessor(bool? value) => setField<bool>('banner_professor', value);

  bool? get bannerAluno => getField<bool>('banner_aluno');
  set bannerAluno(bool? value) => setField<bool>('banner_aluno', value);

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);
}
