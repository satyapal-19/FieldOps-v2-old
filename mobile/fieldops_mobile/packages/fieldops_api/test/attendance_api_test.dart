import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';


/// tests for AttendanceApi
void main() {
  final instance = FieldopsApi().getAttendanceApi();

  group(AttendanceApi, () {
    // One-time liveness challenge for the next punch (yourself, or a team member)
    //
    //Future<ChallengeDto> attendanceControllerChallenge(CreateChallengeDto createChallengeDto) async
    test('test attendanceControllerChallenge', () async {
      // TODO
    });

    // One attendance record
    //
    //Future<AttendanceLogDto> attendanceControllerGet(String id) async
    test('test attendanceControllerGet', () async {
      // TODO
    });

    // Attendance in your scope (self, team, ward, or all)
    //
    //Future<AttendancePageDto> attendanceControllerList({ String from, String to, String staffId, String status, int page, int pageSize }) async
    test('test attendanceControllerList', () async {
      // TODO
    });

    // Your location breadcrumbs (live or from the offline buffer), up to 200 per call
    //
    // Idempotent by clientUuid. Fixes older than 48 h or more than 2 minutes ahead of server time are rejected. Two outside pings in a row during a ward shift raise OUT_OF_ZONE.
    //
    //Future<PingBatchResultDto> attendanceControllerPings(PingBatchDto pingBatchDto) async
    test('test attendanceControllerPings', () async {
      // TODO
    });

    // Check in or out (self or proxy): server time, geofence, hierarchy and face checks
    //
    // Idempotent by clientUuid: a retry returns the accepted punch with replayed = true. Errors: NO_ASSIGNMENT, ASSIGNMENT_NOT_APPROVED, OUTSIDE_GEOFENCE, LOCATION_TOO_INACCURATE, OUTSIDE_SHIFT_WINDOW, ON_LEAVE, NOT_CHECKED_IN, CHALLENGE_INVALID, CHALLENGE_EXPIRED, FACE_MISMATCH, FACE_NOT_ENROLLED (422); ALREADY_CHECKED_IN, ALREADY_CHECKED_OUT (409); FACE_PROVIDER_UNAVAILABLE (503).
    //
    //Future<PunchResultDto> attendanceControllerPunch(CreatePunchDto createPunchDto) async
    test('test attendanceControllerPunch', () async {
      // TODO
    });

    // Tamper signals from your phone watchdog (GPS off, mock location, ...)
    //
    // Idempotent by clientUuid; resend an event with resolvedAt when it ends.
    //
    //Future<TamperBatchResultDto> attendanceControllerTamper(TamperBatchDto tamperBatchDto) async
    test('test attendanceControllerTamper', () async {
      // TODO
    });

    // A person's route on an IST date: points, distance, gaps and tamper events
    //
    // Raw points while they are kept (PING_RETENTION_DAYS), then only the nightly summary. Supervisors see their scope; everyone else only their own route for today's shift.
    //
    //Future<RouteDto> routeControllerRoute(String id, String date) async
    test('test routeControllerRoute', () async {
      // TODO
    });

  });
}
