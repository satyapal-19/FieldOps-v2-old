import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';


/// tests for TasksApi
void main() {
  final instance = FieldopsApi().getTasksApi();

  group(TasksApi, () {
    // START or SUBMIT your task from the phone (retry-safe with clientUuid)
    //
    //Future<TaskDto> tasksControllerAssigneeUpdate(String id, AssigneeUpdateDto assigneeUpdateDto) async
    test('test tasksControllerAssigneeUpdate', () async {
      // TODO
    });

    // Assign a task down the hierarchy
    //
    //Future<TaskDto> tasksControllerCreate(CreateTaskDto createTaskDto) async
    test('test tasksControllerCreate', () async {
      // TODO
    });

    // One task
    //
    //Future<TaskDto> tasksControllerGet(String id) async
    test('test tasksControllerGet', () async {
      // TODO
    });

    // A task's status changes, oldest first
    //
    //Future<BuiltList<TaskUpdateDto>> tasksControllerHistory(String id) async
    test('test tasksControllerHistory', () async {
      // TODO
    });

    // Tasks in your scope (assigned to you, your team, your ward, or all)
    //
    //Future<TaskPageDto> tasksControllerList({ String status, String assignedToId, int page, int pageSize }) async
    test('test tasksControllerList', () async {
      // TODO
    });

    // Give an unfinished task to someone else; it restarts as OPEN
    //
    //Future<TaskDto> tasksControllerReassign(String id, ReassignTaskDto reassignTaskDto) async
    test('test tasksControllerReassign', () async {
      // TODO
    });

    // APPROVE, REJECT (with reason), ESCALATE or CLOSE a task you supervise
    //
    //Future<TaskDto> tasksControllerSupervise(String id, SupervisorActionDto supervisorActionDto) async
    test('test tasksControllerSupervise', () async {
      // TODO
    });

  });
}
