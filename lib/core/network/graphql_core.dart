// lib/core/network/graphql_core.dart
import 'dart:async';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:retry/retry.dart';

class GraphQLCoreConfig {
  static const String endpoint = 'http://35.180.38.200:3000/graphql';
  static const String tokenKey = 'auth_token';
  static const Duration callTimeout = Duration(seconds: 10);
  static const int retryAttempts = 3;
  static const Duration retryDelay = Duration(milliseconds: 300);
}

/// Client centralisé GraphQL + gestion du token + helpers query/mutate.
/// - Stocke le JWT de façon sécurisée (Keychain/Keystore).
/// - Ajoute l'entête Authorization si le token est présent.
/// - Retente automatiquement les appels sur erreurs réseau/timeout/5xx.
class GraphQLCore {
  GraphQLCore._();
  static final GraphQLCore I = GraphQLCore._();

  final _storage = const FlutterSecureStorage();
  GraphQLClient? _client;
  String? _token;

  /// À appeler au démarrage de l’app (main()).
  Future<void> init() async {
    _token ??= await _storage.read(key: GraphQLCoreConfig.tokenKey);
    _client = _buildClient(_token);
  }

  /// Remplace le token courant (après login/logout/refresh) et reconstruit le client.
  Future<void> setToken(String? token, {bool persist = true}) async {
    _token = token;
    if (persist) {
      if (token == null) {
        await _storage.delete(key: GraphQLCoreConfig.tokenKey);
      } else {
        await _storage.write(key: GraphQLCoreConfig.tokenKey, value: token);
      }
    }
    _client = _buildClient(_token);
  }

  /// Lit le token courant (en mémoire, pas de lecture disque).
  String? get token => _token;

  /// Indique si un token est présent (ne valide pas côté serveur).
  bool get isAuthenticated => (_token ?? '').isNotEmpty;

  GraphQLClient get client {
    final c = _client;
    if (c == null) {
      throw StateError('GraphQLCore non initialisé. Appelle init() au démarrage.');
    }
    return c;
  }

  /// Helper Query générique.
  Future<QueryResult<Map<String, dynamic>>> query({
    required String document,
    Map<String, dynamic> variables = const {},
    FetchPolicy fetchPolicy = FetchPolicy.cacheAndNetwork,
  }) async {
    final options = QueryOptions<Map<String, dynamic>>(
      document: gql(document),
      variables: variables,
      fetchPolicy: fetchPolicy,
    );

    final r = RetryOptions(
      maxAttempts: GraphQLCoreConfig.retryAttempts,
      delayFactor: GraphQLCoreConfig.retryDelay,
    );

    final res = await r.retry(
          () => client.query(options).timeout(GraphQLCoreConfig.callTimeout),
      retryIf: _shouldRetry,
    );

    _throwIfError(res);
    return res;
  }

  /// Helper Mutation générique.
  Future<QueryResult<Map<String, dynamic>>> mutate({
    required String document,
    Map<String, dynamic> variables = const {},
  }) async {
    final options = MutationOptions<Map<String, dynamic>>(
      document: gql(document),
      variables: variables,
      fetchPolicy: FetchPolicy.noCache,
    );

    final r = RetryOptions(
      maxAttempts: GraphQLCoreConfig.retryAttempts,
      delayFactor: GraphQLCoreConfig.retryDelay,
    );

    final res = await r.retry(
          () => client.mutate(options).timeout(GraphQLCoreConfig.callTimeout),
      retryIf: _shouldRetry,
    );

    _throwIfError(res);
    return res;
  }

  // ------------------ internes ------------------

  GraphQLClient _buildClient(String? token) {
    final httpLink = HttpLink(
      GraphQLCoreConfig.endpoint,
      defaultHeaders: {'Accept': 'application/json'},
    );

    Link link = httpLink;

    // Injecte "Authorization: Bearer <token>" si présent
    if ((token ?? '').isNotEmpty) {
      link = AuthLink(getToken: () async => 'Bearer $token').concat(link);
    }

    return GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: link,
    );
  }

  /// Politique de retry : réseau/timeout/5xx uniquement.
  bool _shouldRetry(Object e) {
    if (e is TimeoutException || e is SocketException) return true;

    if (e is ServerException) {
      final status = e.statusCode;
      if (status != null && status >= 500) {
        return true; // retry possible sur erreur serveur
      }

      final errors = e.parsedResponse?.errors;
      if (errors != null && errors.isNotEmpty) {
        final msg = errors.first.message;
        print('Erreur GraphQL côté serveur : $msg');
      }
    }

    return false;
  }

  void _throwIfError(QueryResult res) {
    if (res.hasException) {
      // Lève une erreur unique (debug rapide dans l’app)
      throw Exception('GraphQL error: ${res.exception}');
    }
  }
}