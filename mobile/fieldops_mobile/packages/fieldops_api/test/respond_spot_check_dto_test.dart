import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';

// tests for RespondSpotCheckDto
void main() {
  final instance = RespondSpotCheckDtoBuilder();
  // TODO add properties to the builder and call build()

  group(RespondSpotCheckDto, () {
    // Retry-safe: the same one answers once
    // String clientUuid
    test('to test the property `clientUuid`', () async {
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

    // GPS accuracy, metres
    // num accuracyM
    test('to test the property `accuracyM`', () async {
      // TODO
    });

    // JPEG face crop (FACE_PROVIDER=local)
    // String faceImageBase64
    test('to test the property `faceImageBase64`', () async {
      // TODO
    });

    // Aadhaar FaceRD PID block (FACE_PROVIDER=aadhaar)
    // String aadhaarPidXml
    test('to test the property `aadhaarPidXml`', () async {
      // TODO
    });

    // String aadhaarTxn
    test('to test the property `aadhaarTxn`', () async {
      // TODO
    });

  });
}
