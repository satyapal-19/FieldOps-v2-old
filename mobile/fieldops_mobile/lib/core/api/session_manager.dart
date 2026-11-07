import 'dart:convert';

import 'session_store.dart';

/// The refresh token was refused (expired, revoked or reused): sign in again.
class SessionExpiredException implements Exception {
  const SessionExpiredException();
  @override
  String toString() => 'SessionExpiredException';
}

/// Exchanges a refresh token for a new session. Throws
/// [SessionExpiredException] when the server refuses it; any other error
/// (no network) leaves the stored session untouched.
typedef RefreshCall = Future<StoredSession> Function(String refreshToken);

/// Holds the tokens and refreshes them, once, however many requests ask at
/// the same time. Refresh tokens rotate and a reused one revokes the whole
/// session on the server, so two parallel refreshes would sign the user out.
class SessionManager {
  static const _key = 'fieldops_session';

  /// Refresh this long before the access token expires.
  static const refreshMargin = Duration(seconds: 60);

  final SecureKeyValue _storage;
  final DateTime Function() _now;

  RefreshCall? refresher;

  /// Called after the session is cleared because the server refused it.
  void Function()? onExpired;

  StoredSession? _current;
  bool _loaded = false;
  Future<StoredSession>? _inFlight;

  SessionManager({
    required SecureKeyValue storage,
    DateTime Function()? now,
    this.refresher,
  })  : _storage = storage,
        _now = now ?? (() => DateTime.now().toUtc());

  Future<StoredSession?> current() async {
    if (!_loaded) {
      _current = StoredSession.tryParse(await _storage.read(_key));
      _loaded = true;
    }
    return _current;
  }

  Future<bool> get hasSession async => (await current()) != null;

  Future<void> save(StoredSession session) async {
    _current = session;
    _loaded = true;
    await _storage.write(_key, jsonEncode(session.toJson()));
  }

  Future<void> clear() async {
    _current = null;
    _loaded = true;
    await _storage.delete(_key);
  }

  /// A usable access token, refreshed first when it is about to expire.
  /// Returns null when nobody is signed in.
  Future<String?> accessToken() async {
    final s = await current();
    if (s == null) return null;
    if (s.accessExpiresAt.isAfter(_now().add(refreshMargin))) {
      return s.accessToken;
    }
    return (await refresh(staleAccessToken: s.accessToken))?.accessToken;
  }

  /// Refreshes the session. When [staleAccessToken] is given and the stored
  /// token already differs, another request refreshed meanwhile: reuse it.
  Future<StoredSession?> refresh({String? staleAccessToken}) async {
    final s = await current();
    if (s == null) return null;
    if (staleAccessToken != null && s.accessToken != staleAccessToken) {
      return s;
    }
    final pending = _inFlight;
    if (pending != null) return pending;

    final call = refresher;
    if (call == null) return s;
    if (!s.refreshExpiresAt.isAfter(_now())) {
      await _expire();
      throw const SessionExpiredException();
    }
    final future = _run(call, s.refreshToken);
    _inFlight = future;
    try {
      return await future;
    } finally {
      _inFlight = null;
    }
  }

  Future<StoredSession> _run(RefreshCall call, String refreshToken) async {
    try {
      final next = await call(refreshToken);
      await save(next);
      return next;
    } on SessionExpiredException {
      await _expire();
      rethrow;
    }
  }

  Future<void> _expire() async {
    await clear();
    onExpired?.call();
  }
}
