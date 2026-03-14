// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OutroUsuarioChatStruct extends BaseStruct {
  OutroUsuarioChatStruct({
    String? id,
    String? nome,
    String? role,
    String? email,
    String? telefone,
    String? imagemPerfil,
  })  : _id = id,
        _nome = nome,
        _role = role,
        _email = email,
        _telefone = telefone,
        _imagemPerfil = imagemPerfil;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "role" field.
  String? _role;
  String get role => _role ?? '';
  set role(String? val) => _role = val;

  bool hasRole() => _role != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "telefone" field.
  String? _telefone;
  String get telefone => _telefone ?? '';
  set telefone(String? val) => _telefone = val;

  bool hasTelefone() => _telefone != null;

  // "imagem_perfil" field.
  String? _imagemPerfil;
  String get imagemPerfil => _imagemPerfil ?? '';
  set imagemPerfil(String? val) => _imagemPerfil = val;

  bool hasImagemPerfil() => _imagemPerfil != null;

  static OutroUsuarioChatStruct fromMap(Map<String, dynamic> data) =>
      OutroUsuarioChatStruct(
        id: data['id'] as String?,
        nome: data['nome'] as String?,
        role: data['role'] as String?,
        email: data['email'] as String?,
        telefone: data['telefone'] as String?,
        imagemPerfil: data['imagem_perfil'] as String?,
      );

  static OutroUsuarioChatStruct? maybeFromMap(dynamic data) => data is Map
      ? OutroUsuarioChatStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'nome': _nome,
        'role': _role,
        'email': _email,
        'telefone': _telefone,
        'imagem_perfil': _imagemPerfil,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'role': serializeParam(
          _role,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'telefone': serializeParam(
          _telefone,
          ParamType.String,
        ),
        'imagem_perfil': serializeParam(
          _imagemPerfil,
          ParamType.String,
        ),
      }.withoutNulls;

  static OutroUsuarioChatStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      OutroUsuarioChatStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        role: deserializeParam(
          data['role'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        telefone: deserializeParam(
          data['telefone'],
          ParamType.String,
          false,
        ),
        imagemPerfil: deserializeParam(
          data['imagem_perfil'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'OutroUsuarioChatStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is OutroUsuarioChatStruct &&
        id == other.id &&
        nome == other.nome &&
        role == other.role &&
        email == other.email &&
        telefone == other.telefone &&
        imagemPerfil == other.imagemPerfil;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([id, nome, role, email, telefone, imagemPerfil]);
}

OutroUsuarioChatStruct createOutroUsuarioChatStruct({
  String? id,
  String? nome,
  String? role,
  String? email,
  String? telefone,
  String? imagemPerfil,
}) =>
    OutroUsuarioChatStruct(
      id: id,
      nome: nome,
      role: role,
      email: email,
      telefone: telefone,
      imagemPerfil: imagemPerfil,
    );
