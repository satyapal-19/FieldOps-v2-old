import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';

// tests for PutShiftDto
void main() {
  final instance = PutShiftDtoBuilder();
  // TODO add properties to the builder and call build()

  group(PutShiftDto, () {
    // String staffId
    test('to test the property `staffId`', () async {
      // TODO
    });

    // IST date, today up to 31 days ahead
    // String date
    test('to test the property `date`', () async {
      // TODO
    });

    // String shiftType
    test('to test the property `shiftType`', () async {
      // TODO
    });

    // IST, 24-hour HH:MM
    // String startTime
    test('to test the property `startTime`', () async {
      // TODO
    });

    // Before startTime only for NIGHT (ends next day)
    // String endTime
    test('to test the property `endTime`', () async {
      // TODO
    });

    // Required when changing an existing override
    // num expectedVersion
    test('to test the property `expectedVersion`', () async {
      // TODO
    });

  });
}
