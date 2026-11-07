import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

typedef FakeHandler = Future<(int, Object?)> Function(RequestOptions options);

/// Dio transport that answers from a function, recording every request.
class FakeAdapter implements HttpClientAdapter {
  final FakeHandler handler;
  final List<RequestOptions> requests = [];

  /// `Authorization` as sent on each request (a retry reuses the options object).
  final List<String?> authHeaders = [];

  FakeAdapter(this.handler);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    authHeaders.add(options.headers['Authorization'] as String?);
    final (status, body) = await handler(options);
    return ResponseBody.fromString(
      body == null ? '' : jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [status >= 400 ? 'application/problem+json' : 'application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Map<String, Object?> profileJson({String id = '00000000-0000-0000-0000-000000000001'}) => {
      'id': id,
      'employeeCode': 'SMK-0001',
      'fullName': 'Test Worker',
      'fullNameMr': 'चाचणी कामगार',
      'phone': '9800000001',
      'role': 'WORKER',
      'department': 'SANITATION',
      'shiftStart': '06:00',
      'shiftEnd': '14:00',
      'isActive': true,
      'hasPassword': false,
      'version': 1,
      'createdAt': '2026-11-01T00:00:00.000Z',
      'updatedAt': '2026-11-01T00:00:00.000Z',
    };

Map<String, Object?> tokensJson(String access, String refresh) => {
      'accessToken': access,
      'tokenType': 'Bearer',
      'expiresInSeconds': 900,
      'refreshToken': refresh,
      'refreshExpiresAt': '2026-12-31T00:00:00.000Z',
      'staff': profileJson(),
    };
