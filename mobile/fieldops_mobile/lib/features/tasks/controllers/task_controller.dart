import 'dart:io';

import 'package:fieldops_api/fieldops_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../../core/api/api_failure.dart';
import '../../../core/api/api_service.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/outbox/outbox.dart';
import '../../../core/outbox/outbox_service.dart';

/// My tasks (`GET /tasks`) and the two assignee actions, START and SUBMIT,
/// which go through the outbox so they survive a dead network.
class TaskController extends GetxController {
  static const _uuid = Uuid();

  ApiService get _api => Get.find<ApiService>();
  AuthController get _auth => Get.find<AuthController>();

  final isLoading = false.obs;
  final tasks = <TaskDto>[].obs;
  final filter = 'ALL'.obs;
  final Rx<ApiFailure?> failure = Rx(null);

  /// Tasks with an update still in the outbox, and the status it will set.
  final queued = <String, TaskDtoStatusEnum>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  Future<void> loadTasks() async {
    isLoading.value = true;
    try {
      final page = (await _api.tasks.tasksControllerList(
        assignedToId: _auth.staffId,
        status: filter.value == 'ALL' ? null : filter.value,
        pageSize: 100,
      ))
          .data!;
      tasks.assignAll(page.items);
      failure.value = null;
    } catch (e) {
      failure.value = ApiFailure.from(e);
    } finally {
      isLoading.value = false;
    }
  }

  TaskDtoStatusEnum statusOf(TaskDto t) => queued[t.id] ?? t.status;

  Future<void> startTask(TaskDto task) => _update(task, AssigneeUpdateDtoActionEnum.START,
      TaskDtoStatusEnum.IN_PROGRESS);

  Future<void> submitTask(TaskDto task, {required String note, File? photo}) async {
    String? kept;
    if (photo != null) {
      // Move the photo where the outbox can find it after a restart.
      final dir = await OutboxService.photoDir();
      kept = p.join(dir.path, '${_uuid.v4()}${p.extension(photo.path)}');
      await photo.copy(kept);
    }
    await _update(task, AssigneeUpdateDtoActionEnum.SUBMIT, TaskDtoStatusEnum.SUBMITTED,
        note: note, photoPath: kept);
  }

  Future<void> _update(
    TaskDto task,
    AssigneeUpdateDtoActionEnum action,
    TaskDtoStatusEnum next, {
    String? note,
    String? photoPath,
  }) async {
    final pos = await Geolocator.getLastKnownPosition();
    final update = AssigneeUpdateDto((b) => b
      ..clientUuid = _uuid.v4()
      ..action = action
      ..note = (note == null || note.isEmpty) ? null : note
      ..lat = pos?.latitude
      ..lng = pos?.longitude);
    queued[task.id] = next;
    final outbox = Get.find<OutboxService>();
    await outbox.addTaskUpdate(task.id, update, photoPath: photoPath);
    await outbox.flush();
    // Sent if online: show the server's state.
    if (await outbox.outbox.pending(OutboxKind.taskUpdate) == 0) {
      queued.remove(task.id);
      await loadTasks();
    }
  }
}
