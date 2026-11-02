import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';

// tests for CreateAssignmentDto
void main() {
  final instance = CreateAssignmentDtoBuilder();
  // TODO add properties to the builder and call build()

  group(CreateAssignmentDto, () {
    // IST date, today up to 31 days ahead
    // String date
    test('to test the property `date`', () async {
      // TODO
    });

    // The INSPECTOR or WORKER being placed
    // String staffId
    test('to test the property `staffId`', () async {
      // TODO
    });

    // Required when placing an INSPECTOR
    // String wardId
    test('to test the property `wardId`', () async {
      // TODO
    });

    // Required when placing a WORKER: an inspector already placed that day
    // String inspectorId
    test('to test the property `inspectorId`', () async {
      // TODO
    });

  });
}
