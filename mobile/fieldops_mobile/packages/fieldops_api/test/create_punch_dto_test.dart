import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';

// tests for CreatePunchDto
void main() {
  final instance = CreatePunchDtoBuilder();
  // TODO add properties to the builder and call build()

  group(CreatePunchDto, () {
    // Idempotency key from the phone outbox; a retry returns the same result
    // String clientUuid
    test('to test the property `clientUuid`', () async {
      // TODO
    });

    // String type
    test('to test the property `type`', () async {
      // TODO
    });

    // Omit for yourself; set for a proxy punch
    // String staffId
    test('to test the property `staffId`', () async {
      // TODO
    });

    // From POST /attendance/challenges
    // String challengeId
    test('to test the property `challengeId`', () async {
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

    // GPS accuracy in metres (field ≤ 25, office ≤ 100)
    // num accuracyM
    test('to test the property `accuracyM`', () async {
      // TODO
    });

    // The phone reported a mock location (recorded, flagged)
    // bool isMocked
    test('to test the property `isMocked`', () async {
      // TODO
    });

    // Local face provider: base64 JPEG face crop (≤ 96000 chars); never stored
    // String faceImageBase64
    test('to test the property `faceImageBase64`', () async {
      // TODO
    });

    // Aadhaar face provider: PidData XML from FaceRD
    // String aadhaarPidXml
    test('to test the property `aadhaarPidXml`', () async {
      // TODO
    });

    // Aadhaar face provider: the txn from capture-options
    // String aadhaarTxn
    test('to test the property `aadhaarTxn`', () async {
      // TODO
    });

  });
}
