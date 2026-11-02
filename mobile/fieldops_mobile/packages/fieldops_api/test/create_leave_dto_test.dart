import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';

// tests for CreateLeaveDto
void main() {
  final instance = CreateLeaveDtoBuilder();
  // TODO add properties to the builder and call build()

  group(CreateLeaveDto, () {
    // Idempotency key from the phone; a retry returns the same request
    // String clientUuid
    test('to test the property `clientUuid`', () async {
      // TODO
    });

    // String leaveType
    test('to test the property `leaveType`', () async {
      // TODO
    });

    // IST date; today or later (SICK: up to 7 days back)
    // String fromDate
    test('to test the property `fromDate`', () async {
      // TODO
    });

    // Inclusive; at most 31 days in one request
    // String toDate
    test('to test the property `toDate`', () async {
      // TODO
    });

    // String reason
    test('to test the property `reason`', () async {
      // TODO
    });

  });
}
