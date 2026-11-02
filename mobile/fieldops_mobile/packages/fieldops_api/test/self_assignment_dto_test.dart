import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';

// tests for SelfAssignmentDto
void main() {
  final instance = SelfAssignmentDtoBuilder();
  // TODO add properties to the builder and call build()

  group(SelfAssignmentDto, () {
    // Idempotency key from the phone; a retry returns the same row
    // String clientUuid
    test('to test the property `clientUuid`', () async {
      // TODO
    });

    // IST date: today or tomorrow
    // String date
    test('to test the property `date`', () async {
      // TODO
    });

    // INSPECTOR self-pick: the ward
    // String wardId
    test('to test the property `wardId`', () async {
      // TODO
    });

    // WORKER self-join: the inspector whose team to join
    // String inspectorId
    test('to test the property `inspectorId`', () async {
      // TODO
    });

  });
}
