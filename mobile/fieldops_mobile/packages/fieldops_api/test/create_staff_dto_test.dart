import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';

// tests for CreateStaffDto
void main() {
  final instance = CreateStaffDtoBuilder();
  // TODO add properties to the builder and call build()

  group(CreateStaffDto, () {
    // 2-20 letters, digits or hyphens; stored upper-case
    // String employeeCode
    test('to test the property `employeeCode`', () async {
      // TODO
    });

    // String fullName
    test('to test the property `fullName`', () async {
      // TODO
    });

    // String fullNameMr
    test('to test the property `fullNameMr`', () async {
      // TODO
    });

    // Indian mobile; +91 / 0 prefixes accepted
    // String phone
    test('to test the property `phone`', () async {
      // TODO
    });

    // String role
    test('to test the property `role`', () async {
      // TODO
    });

    // Required for WARD_INSPECTOR, INSPECTOR, WORKER
    // String homeWardId
    test('to test the property `homeWardId`', () async {
      // TODO
    });

    // Required for OFFICE_STAFF
    // String officeId
    test('to test the property `officeId`', () async {
      // TODO
    });

    // Line manager: exactly the next rank up
    // String reportsToId
    test('to test the property `reportsToId`', () async {
      // TODO
    });

    // String department
    test('to test the property `department`', () async {
      // TODO
    });

    // IST, 24-hour HH:MM
    // String shiftStart (default value: '06:00')
    test('to test the property `shiftStart`', () async {
      // TODO
    });

    // String shiftEnd (default value: '14:00')
    test('to test the property `shiftEnd`', () async {
      // TODO
    });

    // Only for ADMIN, WARD_INSPECTOR and OFFICE_STAFF (web sign-in). 10-72 characters.
    // String initialPassword
    test('to test the property `initialPassword`', () async {
      // TODO
    });

  });
}
