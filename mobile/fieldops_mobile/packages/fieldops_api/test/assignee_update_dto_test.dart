import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';

// tests for AssigneeUpdateDto
void main() {
  final instance = AssigneeUpdateDtoBuilder();
  // TODO add properties to the builder and call build()

  group(AssigneeUpdateDto, () {
    // Idempotency key from the phone; a retry changes nothing
    // String clientUuid
    test('to test the property `clientUuid`', () async {
      // TODO
    });

    // String action
    test('to test the property `action`', () async {
      // TODO
    });

    // Required to SUBMIT unless a photo is attached
    // String note
    test('to test the property `note`', () async {
      // TODO
    });

    // Storage key from the upload endpoint (after-photo on SUBMIT)
    // String photoKey
    test('to test the property `photoKey`', () async {
      // TODO
    });

    // num lat
    test('to test the property `lat`', () async {
      // TODO
    });

    // num lng
    test('to test the property `lng`', () async {
      // TODO
    });

  });
}
