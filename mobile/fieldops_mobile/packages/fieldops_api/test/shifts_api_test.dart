import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';


/// tests for ShiftsApi
void main() {
  final instance = FieldopsApi().getShiftsApi();

  group(ShiftsApi, () {
    // The shift that applies on a day: the override, else the staff defaults
    //
    //Future<EffectiveShiftDto> shiftsControllerEffective(String staffId, String date) async
    test('test shiftsControllerEffective', () async {
      // TODO
    });

    // A person's shift overrides in a date range (yourself, or staff in your scope)
    //
    //Future<BuiltList<ShiftDto>> shiftsControllerList(String staffId, String from, String to) async
    test('test shiftsControllerList', () async {
      // TODO
    });

    // Set a person's shift for a day (ADMIN; ward inspector for their ward's staff)
    //
    //Future<ShiftDto> shiftsControllerPut(PutShiftDto putShiftDto) async
    test('test shiftsControllerPut', () async {
      // TODO
    });

    // Remove an override for today or a coming day (defaults apply again)
    //
    //Future shiftsControllerRemove(String id) async
    test('test shiftsControllerRemove', () async {
      // TODO
    });

  });
}
