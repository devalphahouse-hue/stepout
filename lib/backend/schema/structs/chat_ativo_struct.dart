// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ChatAtivoStruct extends BaseStruct {
  ChatAtivoStruct({
    String? turma,
    String? chatId,
    String? createdAt,
    OutroUsuarioChatStruct? otherUser,
  })  : _turma = turma,
        _chatId = chatId,
        _createdAt = createdAt,
        _otherUser = otherUser;

  // "turma" field.
  String? _turma;
  String get turma => _turma ?? '';
  set turma(String? val) => _turma = val;

  bool hasTurma() => _turma != null;

  // "chat_id" field.
  String? _chatId;
  String get chatId => _chatId ?? '';
  set chatId(String? val) => _chatId = val;

  bool hasChatId() => _chatId != null;

  // "created_at" field.
  String? _createdAt;
  String get createdAt => _createdAt ?? '';
  set createdAt(String? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "other_user" field.
  OutroUsuarioChatStruct? _otherUser;
  OutroUsuarioChatStruct get otherUser =>
      _otherUser ?? OutroUsuarioChatStruct();
  set otherUser(OutroUsuarioChatStruct? val) => _otherUser = val;

  void updateOtherUser(Function(OutroUsuarioChatStruct) updateFn) {
    updateFn(_otherUser ??= OutroUsuarioChatStruct());
  }

  bool hasOtherUser() => _otherUser != null;

  static ChatAtivoStruct fromMap(Map<String, dynamic> data) => ChatAtivoStruct(
        turma: data['turma'] as String?,
        chatId: data['chat_id'] as String?,
        createdAt: data['created_at'] as String?,
        otherUser: data['other_user'] is OutroUsuarioChatStruct
            ? data['other_user']
            : OutroUsuarioChatStruct.maybeFromMap(data['other_user']),
      );

  static ChatAtivoStruct? maybeFromMap(dynamic data) => data is Map
      ? ChatAtivoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'turma': _turma,
        'chat_id': _chatId,
        'created_at': _createdAt,
        'other_user': _otherUser?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'turma': serializeParam(
          _turma,
          ParamType.String,
        ),
        'chat_id': serializeParam(
          _chatId,
          ParamType.String,
        ),
        'created_at': serializeParam(
          _createdAt,
          ParamType.String,
        ),
        'other_user': serializeParam(
          _otherUser,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static ChatAtivoStruct fromSerializableMap(Map<String, dynamic> data) =>
      ChatAtivoStruct(
        turma: deserializeParam(
          data['turma'],
          ParamType.String,
          false,
        ),
        chatId: deserializeParam(
          data['chat_id'],
          ParamType.String,
          false,
        ),
        createdAt: deserializeParam(
          data['created_at'],
          ParamType.String,
          false,
        ),
        otherUser: deserializeStructParam(
          data['other_user'],
          ParamType.DataStruct,
          false,
          structBuilder: OutroUsuarioChatStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'ChatAtivoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ChatAtivoStruct &&
        turma == other.turma &&
        chatId == other.chatId &&
        createdAt == other.createdAt &&
        otherUser == other.otherUser;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([turma, chatId, createdAt, otherUser]);
}

ChatAtivoStruct createChatAtivoStruct({
  String? turma,
  String? chatId,
  String? createdAt,
  OutroUsuarioChatStruct? otherUser,
}) =>
    ChatAtivoStruct(
      turma: turma,
      chatId: chatId,
      createdAt: createdAt,
      otherUser: otherUser ?? OutroUsuarioChatStruct(),
    );
