import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';

// tests for AppInfoDto
void main() {
  final instance = AppInfoDtoBuilder();
  // TODO add properties to the builder and call build()

  group(AppInfoDto, () {
    // Android versionCode below which the app must update before use
    // num minVersionCode
    test('to test the property `minVersionCode`', () async {
      // TODO
    });

    // Newest versionCode; above the minimum the update is optional
    // num latestVersionCode
    test('to test the property `latestVersionCode`', () async {
      // TODO
    });

    // String updateUrl
    test('to test the property `updateUrl`', () async {
      // TODO
    });

    // Which face capture flow to prepare
    // String faceProvider
    test('to test the property `faceProvider`', () async {
      // TODO
    });

    // Seconds between location pings while on duty
    // num pingIntervalSeconds
    test('to test the property `pingIntervalSeconds`', () async {
      // TODO
    });

    // No ping for this long during a shift raises a silent-gap alert
    // num silentGapMinutes
    test('to test the property `silentGapMinutes`', () async {
      // TODO
    });

    // Server time (UTC): the app shows a wrong phone clock
    // DateTime serverTime
    test('to test the property `serverTime`', () async {
      // TODO
    });

  });
}
