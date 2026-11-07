import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';


/// tests for ReportsApi
void main() {
  final instance = FieldopsApi().getReportsApi();

  group(ReportsApi, () {
    // Who is checked in on a field shift right now, with their latest position
    //
    // Admin all wards (or one), ward inspector their ward, inspector their team and placements. Poll every 30 s; state ACTIVE / STALE / SILENT / NO_SIGNAL from the last ping.
    //
    //Future<LiveDto> reportsControllerLive({ String wardId }) async
    test('test reportsControllerLive', () async {
      // TODO
    });

    // Citizens: staff placed and present in a ward over the last week (counts only)
    //
    //Future<PublicWardAttendanceDto> reportsControllerPublicWard(String id) async
    test('test reportsControllerPublicWard', () async {
      // TODO
    });

    // Per-person late marks, absences, leave and corrections over a range
    //
    //Future<StaffReportDto> reportsControllerStaffDays(String from, String to, { String wardId, int page, int pageSize }) async
    test('test reportsControllerStaffDays', () async {
      // TODO
    });

    // Daily attendance per ward from the nightly summaries (up to 92 days)
    //
    //Future<WardDaysDto> reportsControllerWardDays(String from, String to, { String wardId }) async
    test('test reportsControllerWardDays', () async {
      // TODO
    });

  });
}
