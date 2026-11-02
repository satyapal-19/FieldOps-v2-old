import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';


/// tests for HolidaysApi
void main() {
  final instance = FieldopsApi().getHolidaysApi();

  group(HolidaysApi, () {
    // Add a holiday (ADMIN, today or later)
    //
    //Future<HolidayDto> holidaysControllerCreate(CreateHolidayDto createHolidayDto) async
    test('test holidaysControllerCreate', () async {
      // TODO
    });

    // Holidays in a calendar year, by date
    //
    //Future<BuiltList<HolidayDto>> holidaysControllerList(num year) async
    test('test holidaysControllerList', () async {
      // TODO
    });

    // Remove a coming holiday (ADMIN)
    //
    //Future holidaysControllerRemove(String id) async
    test('test holidaysControllerRemove', () async {
      // TODO
    });

    // Change a coming holiday (ADMIN, optimistic locking via expectedVersion)
    //
    //Future<HolidayDto> holidaysControllerUpdate(String id, UpdateHolidayDto updateHolidayDto) async
    test('test holidaysControllerUpdate', () async {
      // TODO
    });

  });
}
