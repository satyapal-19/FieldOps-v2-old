import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Error codes the app reacts to (the full list is `ErrorCode` in the
/// generated client; text for every code is in `assets/error_messages.json`).
class ApiCodes {
  static const unauthenticated = 'UNAUTHENTICATED';
  static const network = 'NETWORK';
  static const unknown = 'UNKNOWN';

  // Phone-side problems (not sent by the API), shown through the same table.
  static const gpsDisabled = 'PHONE_GPS_DISABLED';
  static const locationPermission = 'PHONE_LOCATION_PERMISSION';
  static const cameraUnavailable = 'PHONE_CAMERA_UNAVAILABLE';
  static const faceCaptureFailed = 'PHONE_FACE_CAPTURE_FAILED';
}

/// One failed API call, from `application/problem+json` or the network.
class ApiFailure implements Exception {
  final String code;
  final int? status;
  final String? requestId;
  final Map<String, dynamic>? details;

  const ApiFailure({
    required this.code,
    this.status,
    this.requestId,
    this.details,
  });

  /// No answer from the server: worth retrying later.
  bool get isNetwork => code == ApiCodes.network;

  /// Retrying the same request can succeed (network or server trouble).
  bool get isRetryable =>
      isNetwork || (status != null && (status! >= 500 || status == 429));

  factory ApiFailure.from(Object error) {
    if (error is ApiFailure) return error;
    if (error is DioException) {
      final res = error.response;
      if (res == null) {
        final network = error.type != DioExceptionType.badCertificate &&
            error.type != DioExceptionType.cancel &&
            (error.type != DioExceptionType.unknown ||
                error.error is SocketException ||
                error.error is HttpException);
        return ApiFailure(code: network ? ApiCodes.network : ApiCodes.unknown);
      }
      var body = res.data;
      if (body is String && body.isNotEmpty) {
        try {
          body = jsonDecode(body);
        } catch (_) {}
      }
      if (body is Map) {
        final details = body['details'];
        return ApiFailure(
          code: (body['code'] as String?) ?? ApiCodes.unknown,
          status: res.statusCode,
          requestId: body['requestId'] as String?,
          details: details is Map ? Map<String, dynamic>.from(details) : null,
        );
      }
      return ApiFailure(code: ApiCodes.unknown, status: res.statusCode);
    }
    if (error is SocketException) return const ApiFailure(code: ApiCodes.network);
    return const ApiFailure(code: ApiCodes.unknown);
  }

  /// Text for the user in [lang] ('mr' or 'en'), with the request ID.
  String message(String lang) {
    final text = ErrorMessages.text(code, lang);
    return requestId == null ? text : '$text ($requestId)';
  }

  @override
  String toString() => 'ApiFailure($code, $status, $requestId)';
}

/// The shared Marathi / English table, copied from `openapi/error-messages.json`.
class ErrorMessages {
  static Map<String, Map<String, String>> _table = {};

  static const _fallback = {
    ApiCodes.network: {
      'en': 'No connection to the server. Check the internet and try again',
      'mr': 'सर्व्हरशी संपर्क नाही. इंटरनेट तपासून पुन्हा प्रयत्न करा',
    },
    ApiCodes.unknown: {
      'en': 'Something went wrong. Please try again',
      'mr': 'काहीतरी चुकले. कृपया पुन्हा प्रयत्न करा',
    },
    ApiCodes.gpsDisabled: {
      'en': 'Location (GPS) is off. Turn it on and try again',
      'mr': 'लोकेशन (GPS) बंद आहे. ते चालू करून पुन्हा प्रयत्न करा',
    },
    ApiCodes.locationPermission: {
      'en': 'Allow location access for FieldOps in the phone settings',
      'mr': 'फोनच्या सेटिंग्जमध्ये FieldOps ला लोकेशनची परवानगी द्या',
    },
    ApiCodes.cameraUnavailable: {
      'en': 'The camera could not be opened. Allow camera access and try again',
      'mr': 'कॅमेरा उघडता आला नाही. कॅमेऱ्याची परवानगी देऊन पुन्हा प्रयत्न करा',
    },
    ApiCodes.faceCaptureFailed: {
      'en': 'Your face could not be captured. Face the camera in good light and try again',
      'mr': 'चेहरा टिपता आला नाही. चांगल्या प्रकाशात कॅमेऱ्याकडे पाहून पुन्हा प्रयत्न करा',
    },
  };

  static Future<void> load() async {
    try {
      final raw = await rootBundle.loadString('assets/error_messages.json');
      loadFromJson(raw);
    } catch (_) {
      // Fallback text still covers network and unknown errors.
    }
  }

  static void loadFromJson(String raw) {
    final messages = (jsonDecode(raw) as Map<String, dynamic>)['messages']
        as Map<String, dynamic>;
    _table = messages.map((code, v) => MapEntry(
          code,
          Map<String, String>.from(v as Map),
        ));
  }

  static String text(String code, String lang) {
    final entry = _table[code] ?? _fallback[code] ?? _fallback[ApiCodes.unknown]!;
    return entry[lang == 'mr' ? 'mr' : 'en'] ?? entry['en']!;
  }
}
