import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '/backend/supabase/supabase.dart';
import '../base_auth_user_provider.dart';

export '../base_auth_user_provider.dart';

class StepoutAlunoSupabaseUser extends BaseAuthUser {
  StepoutAlunoSupabaseUser(this.user);
  User? user;
  bool get loggedIn => user != null;

  @override
  AuthUserInfo get authUserInfo => AuthUserInfo(
        uid: user?.id,
        email: user?.email,
        phoneNumber: user?.phone,
      );

  @override
  Future? delete() =>
      throw UnsupportedError('The delete user operation is not yet supported.');

  @override
  Future? updateEmail(String email) async {
    final response =
        await SupaFlow.client.auth.updateUser(UserAttributes(email: email));
    if (response.user != null) {
      user = response.user;
    }
  }

  @override
  Future? updatePassword(String newPassword) async {
    final response = await SupaFlow.client.auth.updateUser(
      UserAttributes(password: newPassword),
    );
    if (response.user != null) {
      user = response.user;
    }
  }

  @override
  Future? sendEmailVerification() => throw UnsupportedError(
      'The send email verification operation is not yet supported.');

  @override
  bool get emailVerified {
    // Não chama refreshSession() aqui — era a causa de token refresh storms.
    // O SDK do Supabase já faz auto-refresh. Verificar emailConfirmedAt apenas
    // com o valor em cache evita chamadas concorrentes que corrompem o refresh token.
    return user?.emailConfirmedAt != null;
  }

  /// Mutex para garantir que apenas um refreshSession() rode por vez.
  /// Evita race condition onde múltiplos refreshes simultâneos rotacionam
  /// o refresh token e invalidam as outras chamadas.
  static Completer<void>? _refreshCompleter;

  @override
  Future refreshUser() async {
    // Se já tem um refresh em andamento, espera ele terminar em vez de duplicar.
    if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
      await _refreshCompleter!.future;
      user = SupaFlow.client.auth.currentUser;
      return;
    }

    _refreshCompleter = Completer<void>();
    try {
      await SupaFlow.client.auth.refreshSession();
      user = SupaFlow.client.auth.currentUser;
    } finally {
      _refreshCompleter!.complete();
    }
  }
}

/// Generates a stream of the authenticated user.
/// [SupaFlow.client.auth.onAuthStateChange] does not yield any values until the
/// user is already authenticated. So we add a default null user to the stream,
/// if we need to interact with the [currentUser] before logging in.
Stream<BaseAuthUser> stepoutAlunoSupabaseUserStream() {
  // Filtra eventos tokenRefreshed para evitar que o GoRouter redirecione
  // para /login durante aulas. O token é atualizado via jwtTokenStream
  // em auth_util.dart independentemente.
  final supabaseAuthStream = SupaFlow.client.auth.onAuthStateChange
      .where((authState) => authState.event != AuthChangeEvent.tokenRefreshed);
  return (!loggedIn
          ? Stream<AuthState?>.value(null).concatWith([supabaseAuthStream])
          : supabaseAuthStream)
      .map<BaseAuthUser>(
    (authState) {
      currentUser = StepoutAlunoSupabaseUser(authState?.session?.user);
      return currentUser!;
    },
  );
}
