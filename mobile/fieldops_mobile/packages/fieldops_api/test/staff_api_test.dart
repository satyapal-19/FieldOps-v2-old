import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';


/// tests for StaffApi
void main() {
  final instance = FieldopsApi().getStaffApi();

  group(StaffApi, () {
    // Create a staff member (ADMIN)
    //
    //Future<StaffProfileDto> staffAdminControllerCreate(CreateStaffDto createStaffDto) async
    test('test staffAdminControllerCreate', () async {
      // TODO
    });

    // Get one staff member (yourself, or someone in your scope)
    //
    //Future<StaffProfileDto> staffAdminControllerGet(String id) async
    test('test staffAdminControllerGet', () async {
      // TODO
    });

    // List staff in your scope (paged, by employee code)
    //
    //Future<StaffPageDto> staffAdminControllerList({ String role, String wardId, String officeId, bool isActive, String q, int page, int pageSize }) async
    test('test staffAdminControllerList', () async {
      // TODO
    });

    // Update or deactivate a staff member (ADMIN, optimistic locking via expectedVersion)
    //
    // Changing role, ward, office or phone, or deactivating, signs the person out everywhere.
    //
    //Future<StaffProfileDto> staffAdminControllerUpdate(String id, UpdateStaffDto updateStaffDto) async
    test('test staffAdminControllerUpdate', () async {
      // TODO
    });

  });
}
