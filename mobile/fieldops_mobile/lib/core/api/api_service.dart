import 'dart:convert';

import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';
import 'package:fieldops_api/fieldops_api.dart';
import 'package:get/get.dart';

import 'api_failure.dart';
import 'auth_interceptor.dart';
import 'env.dart';
import 'session_manager.dart';
import 'session_store.dart';

/// The one way the app talks to the backend: the generated client over Dio,
/// with tokens from the keystore. No other HTTP or database access.
class ApiService extends GetxService {
  final SessionManager session;
  late final Dio dio;
  late final FieldopsApi client;

  ApiService({SecureKeyValue? storage, String? baseUrl, Dio? dioOverride})
      : session = SessionManager(storage: storage ?? FlutterSecureKeyValue()) {
    final options = BaseOptions(
      baseUrl: baseUrl ?? Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'X-App-Version': Env.versionCode.toString()},
    );
    dio = dioOverride ?? Dio(options);
    client = FieldopsApi(
      dio: dio,
      interceptors: [AuthInterceptor(session: session, dio: dio)],
    );

    // Refresh through a bare Dio so a failed refresh never re-enters the interceptor.
    final refreshApi = FieldopsApi(dio: Dio(options), interceptors: const []).getAuthApi();
    session.refresher = (refreshToken) async {
      try {
        final res = await refreshApi.authControllerRefresh(
          refreshDto: RefreshDto((b) => b..refreshToken = refreshToken),
        );
        return sessionFromTokens(res.data!);
      } catch (e) {
        final f = ApiFailure.from(e);
        if (f.status == 401 || f.status == 403) throw const SessionExpiredException();
        rethrow;
      }
    };
  }

  AuthApi get auth => client.getAuthApi();
  AttendanceApi get attendance => client.getAttendanceApi();
  FaceApi get face => client.getFaceApi();
  ShiftsApi get shifts => client.getShiftsApi();
  RostersApi get rosters => client.getRostersApi();
  TasksApi get tasks => client.getTasksApi();
  LeaveApi get leave => client.getLeaveApi();
  WardsApi get wards => client.getWardsApi();
  PublicApi get public => client.getPublicApi();
  AlertsApi get alerts => client.getAlertsApi();
  UploadsApi get uploads => client.getUploadsApi();

  static StoredSession sessionFromTokens(SessionTokensDto t, {DateTime? now}) {
    final at = (now ?? DateTime.now()).toUtc();
    return StoredSession(
      accessToken: t.accessToken,
      accessExpiresAt: at.add(Duration(seconds: t.expiresInSeconds.toInt())),
      refreshToken: t.refreshToken,
      refreshExpiresAt: t.refreshExpiresAt.toUtc(),
    );
  }

  /// JSON of a generated model, for the local profile cache.
  String encode<T>(Serializer<T> serializer, T value) =>
      jsonEncode(client.serializers.serializeWith(serializer, value));

  T? decode<T>(Serializer<T> serializer, String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return client.serializers.deserializeWith(serializer, jsonDecode(raw));
    } catch (_) {
      return null;
    }
  }
}
