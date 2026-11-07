import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Tokens of the signed-in user. Times are UTC.
class StoredSession {
  final String accessToken;
  final DateTime accessExpiresAt;
  final String refreshToken;
  final DateTime refreshExpiresAt;

  const StoredSession({
    required this.accessToken,
    required this.accessExpiresAt,
    required this.refreshToken,
    required this.refreshExpiresAt,
  });

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'accessExpiresAt': accessExpiresAt.toUtc().toIso8601String(),
        'refreshToken': refreshToken,
        'refreshExpiresAt': refreshExpiresAt.toUtc().toIso8601String(),
      };

  static StoredSession? tryParse(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final m = jsonDecode(raw) as Map<String, dynamic>;
      return StoredSession(
        accessToken: m['accessToken'] as String,
        accessExpiresAt: DateTime.parse(m['accessExpiresAt'] as String),
        refreshToken: m['refreshToken'] as String,
        refreshExpiresAt: DateTime.parse(m['refreshExpiresAt'] as String),
      );
    } catch (_) {
      return null;
    }
  }
}

/// Small key-value port so tests can swap the platform keystore for memory.
abstract class SecureKeyValue {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

/// Android Keystore-backed storage (tokens never go to SharedPreferences).
class FlutterSecureKeyValue implements SecureKeyValue {
  final FlutterSecureStorage _storage;

  FlutterSecureKeyValue([FlutterSecureStorage? storage])
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

class MemoryKeyValue implements SecureKeyValue {
  final Map<String, String> values = {};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;

  @override
  Future<void> delete(String key) async => values.remove(key);
}
