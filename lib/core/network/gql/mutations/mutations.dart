/// Centralise les mutations (string GraphQL).
/// NB: Garde ce fichier "pur" (pas d'import Flutter ici).
class GqlMutations {
  // Auth de base (Tickets API)
  static const String login = r'''
    mutation Login($data: LoginInput!) {
      login(data: $data) {
        token
        user {
          id
          email
          fullName
          isEmailVerified
          createdAt
          deletedAt
        }
      }
    }
  ''';

  static const String signup = r'''
    mutation Signup($data: SignupInput!) {
      signup(data: $data) {
        token
        user {
          id
          email
          fullName
          isEmailVerified
          createdAt
          deletedAt
        }
      }
    }
    ''';
}