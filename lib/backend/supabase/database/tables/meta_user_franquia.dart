import '../database.dart';

class MetaUserFranquiaTable extends SupabaseTable<MetaUserFranquiaRow> {
  @override
  String get tableName => 'meta_user_franquia';

  @override
  MetaUserFranquiaRow createRow(Map<String, dynamic> data) =>
      MetaUserFranquiaRow(data);
}

class MetaUserFranquiaRow extends SupabaseDataRow {
  MetaUserFranquiaRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MetaUserFranquiaTable();

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get level => getField<String>('level');
  set level(String? value) => setField<String>('level', value);

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get idFranquia => getField<String>('id_franquia');
  set idFranquia(String? value) => setField<String>('id_franquia', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);
}
