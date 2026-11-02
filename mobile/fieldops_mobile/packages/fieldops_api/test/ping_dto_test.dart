import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';

// tests for PingDto
void main() {
  final instance = PingDtoBuilder();
  // TODO add properties to the builder and call build()

  group(PingDto, () {
    // Idempotency key from the phone outbox
    // String clientUuid
    test('to test the property `clientUuid`', () async {
      // TODO
    });

    // num latitude
    test('to test the property `latitude`', () async {
      // TODO
    });

    // num longitude
    test('to test the property `longitude`', () async {
      // TODO
    });

    // num accuracyM
    test('to test the property `accuracyM`', () async {
      // TODO
    });

    // num batteryPct
    test('to test the property `batteryPct`', () async {
      // TODO
    });

    // bool isMocked
    test('to test the property `isMocked`', () async {
      // TODO
    });

    // Sent from the offline buffer
    // bool fromOffline
    test('to test the property `fromOffline`', () async {
      // TODO
    });

    // Phone time of the fix (UTC)
    // DateTime recordedAt
    test('to test the property `recordedAt`', () async {
      // TODO
    });

  });
}
