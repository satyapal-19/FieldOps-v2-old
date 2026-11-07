//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:dio/dio.dart';
import 'package:built_value/serializer.dart';
import 'package:fieldops_api/src/serializers.dart';
import 'package:fieldops_api/src/auth/api_key_auth.dart';
import 'package:fieldops_api/src/auth/basic_auth.dart';
import 'package:fieldops_api/src/auth/bearer_auth.dart';
import 'package:fieldops_api/src/auth/oauth.dart';
import 'package:fieldops_api/src/api/alerts_api.dart';
import 'package:fieldops_api/src/api/attendance_api.dart';
import 'package:fieldops_api/src/api/auth_api.dart';
import 'package:fieldops_api/src/api/chat_api.dart';
import 'package:fieldops_api/src/api/complaints_api.dart';
import 'package:fieldops_api/src/api/face_api.dart';
import 'package:fieldops_api/src/api/health_api.dart';
import 'package:fieldops_api/src/api/holidays_api.dart';
import 'package:fieldops_api/src/api/leave_api.dart';
import 'package:fieldops_api/src/api/notifications_api.dart';
import 'package:fieldops_api/src/api/offices_api.dart';
import 'package:fieldops_api/src/api/public_api.dart';
import 'package:fieldops_api/src/api/reports_api.dart';
import 'package:fieldops_api/src/api/rosters_api.dart';
import 'package:fieldops_api/src/api/shifts_api.dart';
import 'package:fieldops_api/src/api/spot_checks_api.dart';
import 'package:fieldops_api/src/api/staff_api.dart';
import 'package:fieldops_api/src/api/tasks_api.dart';
import 'package:fieldops_api/src/api/tiles_api.dart';
import 'package:fieldops_api/src/api/uploads_api.dart';
import 'package:fieldops_api/src/api/wards_api.dart';

class FieldopsApi {
  static const String basePath = r'http://localhost';

  final Dio dio;
  final Serializers serializers;

  FieldopsApi({
    Dio? dio,
    Serializers? serializers,
    String? basePathOverride,
    List<Interceptor>? interceptors,
  })  : this.serializers = serializers ?? standardSerializers,
        this.dio = dio ??
            Dio(BaseOptions(
              baseUrl: basePathOverride ?? basePath,
              connectTimeout: const Duration(milliseconds: 5000),
              receiveTimeout: const Duration(milliseconds: 3000),
            )) {
    if (interceptors == null) {
      this.dio.interceptors.addAll([
        OAuthInterceptor(),
        BasicAuthInterceptor(),
        BearerAuthInterceptor(),
        ApiKeyAuthInterceptor(),
      ]);
    } else {
      this.dio.interceptors.addAll(interceptors);
    }
  }

  void setOAuthToken(String name, String token) {
    if (this.dio.interceptors.any((i) => i is OAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is OAuthInterceptor) as OAuthInterceptor).tokens[name] = token;
    }
  }

  void setBearerAuth(String name, String token) {
    if (this.dio.interceptors.any((i) => i is BearerAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BearerAuthInterceptor) as BearerAuthInterceptor).tokens[name] = token;
    }
  }

  void setBasicAuth(String name, String username, String password) {
    if (this.dio.interceptors.any((i) => i is BasicAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BasicAuthInterceptor) as BasicAuthInterceptor).authInfo[name] = BasicAuthInfo(username, password);
    }
  }

  void setApiKey(String name, String apiKey) {
    if (this.dio.interceptors.any((i) => i is ApiKeyAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((element) => element is ApiKeyAuthInterceptor) as ApiKeyAuthInterceptor).apiKeys[name] = apiKey;
    }
  }

  /// Get AlertsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AlertsApi getAlertsApi() {
    return AlertsApi(dio, serializers);
  }

  /// Get AttendanceApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AttendanceApi getAttendanceApi() {
    return AttendanceApi(dio, serializers);
  }

  /// Get AuthApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AuthApi getAuthApi() {
    return AuthApi(dio, serializers);
  }

  /// Get ChatApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ChatApi getChatApi() {
    return ChatApi(dio, serializers);
  }

  /// Get ComplaintsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ComplaintsApi getComplaintsApi() {
    return ComplaintsApi(dio, serializers);
  }

  /// Get FaceApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  FaceApi getFaceApi() {
    return FaceApi(dio, serializers);
  }

  /// Get HealthApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  HealthApi getHealthApi() {
    return HealthApi(dio, serializers);
  }

  /// Get HolidaysApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  HolidaysApi getHolidaysApi() {
    return HolidaysApi(dio, serializers);
  }

  /// Get LeaveApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  LeaveApi getLeaveApi() {
    return LeaveApi(dio, serializers);
  }

  /// Get NotificationsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  NotificationsApi getNotificationsApi() {
    return NotificationsApi(dio, serializers);
  }

  /// Get OfficesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  OfficesApi getOfficesApi() {
    return OfficesApi(dio, serializers);
  }

  /// Get PublicApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  PublicApi getPublicApi() {
    return PublicApi(dio, serializers);
  }

  /// Get ReportsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ReportsApi getReportsApi() {
    return ReportsApi(dio, serializers);
  }

  /// Get RostersApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  RostersApi getRostersApi() {
    return RostersApi(dio, serializers);
  }

  /// Get ShiftsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ShiftsApi getShiftsApi() {
    return ShiftsApi(dio, serializers);
  }

  /// Get SpotChecksApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  SpotChecksApi getSpotChecksApi() {
    return SpotChecksApi(dio, serializers);
  }

  /// Get StaffApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  StaffApi getStaffApi() {
    return StaffApi(dio, serializers);
  }

  /// Get TasksApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  TasksApi getTasksApi() {
    return TasksApi(dio, serializers);
  }

  /// Get TilesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  TilesApi getTilesApi() {
    return TilesApi(dio, serializers);
  }

  /// Get UploadsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  UploadsApi getUploadsApi() {
    return UploadsApi(dio, serializers);
  }

  /// Get WardsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  WardsApi getWardsApi() {
    return WardsApi(dio, serializers);
  }
}
