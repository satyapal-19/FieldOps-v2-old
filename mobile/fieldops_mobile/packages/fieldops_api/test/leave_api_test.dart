import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';


/// tests for LeaveApi
void main() {
  final instance = FieldopsApi().getLeaveApi();

  group(LeaveApi, () {
    // Withdraw your leave request (pending, or approved and not started)
    //
    //Future<LeaveRequestDto> leaveControllerCancelLeave(String id, CancelRequestDto cancelRequestDto) async
    test('test leaveControllerCancelLeave', () async {
      // TODO
    });

    // Withdraw your pending regularization request
    //
    //Future<RegularizationRequestDto> leaveControllerCancelRegularization(String id, CancelRequestDto cancelRequestDto) async
    test('test leaveControllerCancelRegularization', () async {
      // TODO
    });

    // One leave request
    //
    //Future<LeaveRequestDto> leaveControllerGetLeave(String id) async
    test('test leaveControllerGetLeave', () async {
      // TODO
    });

    // One regularization request
    //
    //Future<RegularizationRequestDto> leaveControllerGetRegularization(String id) async
    test('test leaveControllerGetRegularization', () async {
      // TODO
    });

    // Leave requests: your own, plus those you review
    //
    //Future<LeavePageDto> leaveControllerListLeave({ String status, String staffId, String from, String to, int page, int pageSize }) async
    test('test leaveControllerListLeave', () async {
      // TODO
    });

    // Attendance regularization requests: your own, plus those you review
    //
    //Future<RegularizationPageDto> leaveControllerListRegularizations({ String status, String staffId, String from, String to, int page, int pageSize }) async
    test('test leaveControllerListRegularizations', () async {
      // TODO
    });

    // Ask for leave (for yourself; retry-safe with clientUuid)
    //
    //Future<LeaveRequestDto> leaveControllerRequestLeave(CreateLeaveDto createLeaveDto) async
    test('test leaveControllerRequestLeave', () async {
      // TODO
    });

    // Ask to correct one of the last 7 days (for yourself; retry-safe with clientUuid)
    //
    //Future<RegularizationRequestDto> leaveControllerRequestRegularization(CreateRegularizationDto createRegularizationDto) async
    test('test leaveControllerRequestRegularization', () async {
      // TODO
    });

    // Approve or reject a pending leave request (line manager; never your own)
    //
    //Future<LeaveRequestDto> leaveControllerReviewLeave(String id, ReviewRequestDto reviewRequestDto) async
    test('test leaveControllerReviewLeave', () async {
      // TODO
    });

    // Approve or reject a pending regularization (line manager; never your own)
    //
    //Future<RegularizationRequestDto> leaveControllerReviewRegularization(String id, ReviewRequestDto reviewRequestDto) async
    test('test leaveControllerReviewRegularization', () async {
      // TODO
    });

  });
}
