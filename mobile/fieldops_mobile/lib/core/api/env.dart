/// Build-time configuration, passed with `--dart-define` (no URLs or keys in source).
///
/// ```
/// flutter run --dart-define=API_BASE_URL=https://fieldops.smkmc.gov.in
/// ```
class Env {
  Env._();

  /// Server origin without `/api/v1` (the generated client adds the path).
  static const String _apiBaseUrl = String.fromEnvironment('API_BASE_URL');

  /// Android `versionCode`, compared with the server's minimum version.
  static const int versionCode =
      int.fromEnvironment('APP_VERSION_CODE', defaultValue: 1);

  static bool get isConfigured => _apiBaseUrl.isNotEmpty;

  static String get apiBaseUrl => _apiBaseUrl.replaceAll(RegExp(r'/+$'), '');
}
