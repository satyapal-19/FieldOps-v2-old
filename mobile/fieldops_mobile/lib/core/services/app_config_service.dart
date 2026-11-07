import 'package:fieldops_api/fieldops_api.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../api/api_service.dart';
import '../api/env.dart';

/// `GET /public/app-config` at start: forced update below the minimum
/// version, and a warning when the phone clock is far off (the server stamps
/// every punch, but a wrong clock misplaces offline pings).
class AppConfigService {
  static const clockSkewLimit = Duration(minutes: 5);

  /// Pure rule: this build must be replaced.
  static bool mustUpdate(int versionCode, num minVersionCode) => versionCode < minVersionCode;

  static bool clockIsOff(DateTime phoneUtc, DateTime serverUtc) =>
      phoneUtc.difference(serverUtc).abs() > clockSkewLimit;

  /// Null when the server cannot be reached (the app then works offline).
  static Future<AppInfoDto?> fetch() async {
    try {
      return (await Get.find<ApiService>().public.appInfoControllerGet()).data;
    } catch (e) {
      debugPrint('App config: $e');
      return null;
    }
  }

  static bool needsUpdate(AppInfoDto? info) =>
      info != null && mustUpdate(Env.versionCode, info.minVersionCode);
}
