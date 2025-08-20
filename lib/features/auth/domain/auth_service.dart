import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../core/network/gql/mutations/mutations.dart';
import '../../../core/network/graphql_core.dart';
import '../data/user_dto.dart';

class AuthService {
  AuthService._();
  static final AuthService I = AuthService._();

  /// Login → met à jour le token du client et retourne (token, user)
  Future<({String token, UserDto user})> login({
    required String email,
    required String password,
  }) async {
    final res = await GraphQLCore.I.mutate(
      document: GqlMutations.login,
      variables: {
        'data': {'email': email, 'password': password}
      },
    );

    final login = res.data?['login'] as Map<String, dynamic>?;
    if (login == null) {
      throw Exception('Réponse login vide.');
    }
    final token = login['token'] as String?;
    if (token == null || token.isEmpty) {
      throw Exception('Token manquant dans la réponse login.');
    }

    await GraphQLCore.I.setToken(token, persist: true);
    final user = UserDto.fromJson(login['user'] as Map<String, dynamic>);
    return (token: token, user: user);
  }

  /// Signup → identique à login côté résultat (token + user)
  Future<({String token, UserDto user})> signup({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final res = await GraphQLCore.I.mutate(
      document: GqlMutations.signup,
      variables: {
        'data': {
          'email': email,
          'password': password,
          if (fullName != null) 'fullName': fullName,
        }
      },
    );

    final signup = res.data?['signup'] as Map<String, dynamic>?;
    if (signup == null) throw Exception('Réponse signup vide.');

    final token = signup['token'] as String?;
    if (token == null || token.isEmpty) {
      throw Exception('Token manquant dans la réponse signup.');
    }

    await GraphQLCore.I.setToken(token, persist: true);
    final user = UserDto.fromJson(signup['user'] as Map<String, dynamic>);
    return (token: token, user: user);
  }

  Future<void> logout() => GraphQLCore.I.setToken(null, persist: true);

  // Future<bool> isAuthenticated() async {
  //   // Si un token est en storage, GraphQLCore l'aura chargé à init().
  //   // On considère “auth” si le client courant contient un AuthLink (token non vide).
  //   try {
  //     // Petite query ping possible (ex: me) si tu veux vérifier côté serveur.
  //     return true;
  //   } catch (_) {
  //     return false;
  //   }
  // }
}
