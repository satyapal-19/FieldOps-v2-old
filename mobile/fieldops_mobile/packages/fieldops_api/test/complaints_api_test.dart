import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';


/// tests for ComplaintsApi
void main() {
  final instance = FieldopsApi().getComplaintsApi();

  group(ComplaintsApi, () {
    // Route a complaint by raising a task (admin; ward inspector of its ward)
    //
    //Future<ComplaintDto> complaintsControllerAssign(String id, AssignComplaintDto assignComplaintDto) async
    test('test complaintsControllerAssign', () async {
      // TODO
    });

    // RESOLVE (after an approved task), REJECT (from RECEIVED) or CLOSE a complaint
    //
    //Future<ComplaintDto> complaintsControllerChangeStatus(String id, ComplaintStatusDto complaintStatusDto) async
    test('test complaintsControllerChangeStatus', () async {
      // TODO
    });

    // One complaint with its linked tasks
    //
    //Future<ComplaintDto> complaintsControllerGet(String id) async
    test('test complaintsControllerGet', () async {
      // TODO
    });

    // Complaints in your scope (admin and office staff: all; ward supervisors: ward)
    //
    //Future<ComplaintPageDto> complaintsControllerList({ String status, String wardId, bool unrouted, int page, int pageSize }) async
    test('test complaintsControllerList', () async {
      // TODO
    });

  });
}
