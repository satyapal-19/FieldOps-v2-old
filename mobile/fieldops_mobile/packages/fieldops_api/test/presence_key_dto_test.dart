import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';

// tests for PresenceKeyDto
void main() {
  final instance = PresenceKeyDtoBuilder();
  // TODO add properties to the builder and call build()

  group(PresenceKeyDto, () {
    // Base64 key: compute TOTP codes offline (HMAC-SHA1, 6 digits)
    // String key
    test('to test the property `key`', () async {
      // TODO
    });

    // num periodSeconds
    test('to test the property `periodSeconds`', () async {
      // TODO
    });

    // num digits
    test('to test the property `digits`', () async {
      // TODO
    });

  });
}
