import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';


/// tests for RostersApi
void main() {
  final instance = FieldopsApi().getRostersApi();

  group(RostersApi, () {
    // Approve a self-service assignment (never your own)
    //
    //Future<AssignmentDto> rostersControllerApprove(String id, ApproveAssignmentDto approveAssignmentDto) async
    test('test rostersControllerApprove', () async {
      // TODO
    });

    // Place an inspector in a ward or a worker in a team for a day (approved at once)
    //
    //Future<AssignmentDto> rostersControllerAssign(CreateAssignmentDto createAssignmentDto) async
    test('test rostersControllerAssign', () async {
      // TODO
    });

    // Put a worker in an inspector's standing squad (ward from the inspector)
    //
    //Future<StandingRosterDto> rostersControllerCreateRoster(CreateStandingRosterDto createStandingRosterDto) async
    test('test rostersControllerCreateRoster', () async {
      // TODO
    });

    // Create a day's assignments from the standing squads (safe to repeat)
    //
    //Future<GenerateAssignmentsResultDto> rostersControllerGenerate(GenerateAssignmentsDto generateAssignmentsDto) async
    test('test rostersControllerGenerate', () async {
      // TODO
    });

    // A day's assignments (ADMIN all, ward inspector own ward, inspector own team, worker self)
    //
    //Future<AssignmentPageDto> rostersControllerListAssignments(String date, { int page, int pageSize, String wardId, String inspectorId, bool isApproved }) async
    test('test rostersControllerListAssignments', () async {
      // TODO
    });

    // List standing squads (ADMIN all, ward inspector own ward, inspector own squad)
    //
    //Future<StandingRosterPageDto> rostersControllerListRosters({ int page, int pageSize, String wardId, String inspectorId, bool isActive }) async
    test('test rostersControllerListRosters', () async {
      // TODO
    });

    // Self-pick a ward (inspector) or self-join a team (worker); starts unapproved
    //
    // Retry-safe: the same clientUuid returns the row it created.
    //
    //Future<AssignmentDto> rostersControllerSelfAssign(SelfAssignmentDto selfAssignmentDto) async
    test('test rostersControllerSelfAssign', () async {
      // TODO
    });

    // Move a worker to another inspector, or (de)activate the row
    //
    //Future<StandingRosterDto> rostersControllerUpdateRoster(String id, UpdateStandingRosterDto updateStandingRosterDto) async
    test('test rostersControllerUpdateRoster', () async {
      // TODO
    });

  });
}
