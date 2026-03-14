import '../database.dart';

class MensagensChatsTable extends SupabaseTable<MensagensChatsRow> {
  @override
  String get tableName => 'mensagens_chats';

  @override
  MensagensChatsRow createRow(Map<String, dynamic> data) =>
      MensagensChatsRow(data);
}

class MensagensChatsRow extends SupabaseDataRow {
  MensagensChatsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MensagensChatsTable();

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get conteudo => getField<String>('conteudo');
  set conteudo(String? value) => setField<String>('conteudo', value);

  bool? get lida => getField<bool>('lida');
  set lida(bool? value) => setField<bool>('lida', value);

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get chatId => getField<String>('chat_id');
  set chatId(String? value) => setField<String>('chat_id', value);

  String? get senderId => getField<String>('sender_id');
  set senderId(String? value) => setField<String>('sender_id', value);
}
