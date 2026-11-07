import 'package:dio/dio.dart';

import 'session_manager.dart';

/// Adds the bearer token to every secured call of the generated client and
/// retries once after a refresh when the server answers 401.
class AuthInterceptor extends Interceptor {
  static const _retried = 'fieldops_retried';

  final SessionManager session;
  final Dio dio;

  AuthInterceptor({required this.session, required this.dio});

  static bool _isSecure(RequestOptions o) {
    final secure = o.extra['secure'];
    return secure is List && secure.isNotEmpty;
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isSecure(options)) return handler.next(options);
    try {
      final token = await session.accessToken();
      if (token != null) options.headers['Authorization'] = 'Bearer $token';
      handler.next(options);
    } on SessionExpiredException {
      handler.reject(DioException(
        requestOptions: options,
        response: Response(
          requestOptions: options,
          statusCode: 401,
          data: {'code': 'UNAUTHENTICATED'},
        ),
        type: DioExceptionType.badResponse,
      ));
    } catch (_) {
      // Refresh failed for lack of network: send with the old token and let
      // the call fail (or succeed) on its own.
      final s = await session.current();
      if (s != null) options.headers['Authorization'] = 'Bearer ${s.accessToken}';
      handler.next(options);
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final o = err.requestOptions;
    if (err.response?.statusCode != 401 || !_isSecure(o) || o.extra[_retried] == true) {
      return handler.next(err);
    }
    try {
      final sent = (o.headers['Authorization'] as String?)?.replaceFirst('Bearer ', '');
      final next = await session.refresh(staleAccessToken: sent);
      if (next == null) return handler.next(err);
      o.extra[_retried] = true;
      o.headers['Authorization'] = 'Bearer ${next.accessToken}';
      handler.resolve(await dio.fetch<dynamic>(o));
    } on DioException catch (e) {
      handler.next(e);
    } catch (_) {
      handler.next(err);
    }
  }
}
