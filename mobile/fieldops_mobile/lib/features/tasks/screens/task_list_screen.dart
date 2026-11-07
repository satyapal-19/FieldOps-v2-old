import 'dart:io';

import 'package:fieldops_api/fieldops_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/controllers/auth_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/notify.dart';
import '../controllers/task_controller.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  static const filters = ['ALL', 'OPEN', 'IN_PROGRESS', 'SUBMITTED', 'REJECTED'];

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(TaskController());
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('my_tasks'.tr),
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: ctrl.loadTasks),
        ],
      ),
      body: Column(children: [
        Container(
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filters.map((f) {
                    final active = ctrl.filter.value == f;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(f == 'ALL' ? 'all'.tr : 'task_$f'.tr),
                        selected: active,
                        onSelected: (_) {
                          ctrl.filter.value = f;
                          ctrl.loadTasks();
                        },
                      ),
                    );
                  }).toList(),
                ),
              )),
        ),
        Expanded(
          child: Obx(() {
            if (ctrl.isLoading.value && ctrl.tasks.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            final failure = ctrl.failure.value;
            return RefreshIndicator(
              onRefresh: ctrl.loadTasks,
              child: ctrl.tasks.isEmpty
                  ? ListView(children: [
                      const SizedBox(height: 80),
                      const Icon(Icons.task_alt, size: 64, color: AppColors.border),
                      const SizedBox(height: 12),
                      Text(
                        failure != null ? failure.message(AuthController.lang) : 'no_tasks'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.subtle),
                      ),
                    ])
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: ctrl.tasks.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => _TaskCard(task: ctrl.tasks[i], ctrl: ctrl),
                    ),
            );
          }),
        ),
      ]),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final TaskDto task;
  final TaskController ctrl;
  const _TaskCard({required this.task, required this.ctrl});

  static Color _priorityColor(TaskDtoPriorityEnum p) => switch (p.name) {
        'URGENT' => AppColors.error,
        'LOW' => AppColors.subtle,
        _ => AppColors.warning,
      };

  @override
  Widget build(BuildContext context) {
    final mr = AuthController.lang == 'mr';
    final title = mr && (task.titleMr?.isNotEmpty ?? false) ? task.titleMr! : task.title;
    return Obx(() {
      final status = ctrl.statusOf(task);
      final waiting = ctrl.queued.containsKey(task.id);
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.flag, size: 16, color: _priorityColor(task.priority)),
              const SizedBox(width: 6),
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15))),
              Chip(label: Text('task_${status.name}'.tr, style: const TextStyle(fontSize: 11))),
            ]),
            if (task.description?.isNotEmpty ?? false)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(task.description!, style: const TextStyle(color: AppColors.subtle)),
              ),
            if (task.locationLabel?.isNotEmpty ?? false)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(children: [
                  const Icon(Icons.place, size: 14, color: AppColors.subtle),
                  const SizedBox(width: 4),
                  Expanded(child: Text(task.locationLabel!, style: const TextStyle(fontSize: 12))),
                ]),
              ),
            if (task.dueAt != null)
              Text('${'due'.tr}: ${DateFormat('dd MMM, HH:mm').format(task.dueAt!.toLocal())}',
                  style: const TextStyle(fontSize: 12, color: AppColors.subtle)),
            if (status == TaskDtoStatusEnum.REJECTED && (task.rejectionReason?.isNotEmpty ?? false))
              Text('${'rejected_because'.tr}: ${task.rejectionReason}',
                  style: const TextStyle(fontSize: 12, color: AppColors.error)),
            if (waiting)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text('waiting_to_send'.tr, style: const TextStyle(fontSize: 12, color: AppColors.warning)),
              ),
            const SizedBox(height: 8),
            if (!waiting && (status == TaskDtoStatusEnum.OPEN || status == TaskDtoStatusEnum.REJECTED))
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () => ctrl.startTask(task),
                  icon: const Icon(Icons.play_arrow),
                  label: Text('start'.tr),
                ),
              ),
            if (!waiting && status == TaskDtoStatusEnum.IN_PROGRESS)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () => _submitDialog(context),
                  icon: const Icon(Icons.check),
                  label: Text('submit_work'.tr),
                ),
              ),
          ],
        ),
      );
    });
  }

  Future<void> _submitDialog(BuildContext context) async {
    final note = TextEditingController();
    File? photo;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(ctx).viewInsets.bottom + 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('submit_work'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              TextField(
                controller: note,
                maxLines: 3,
                maxLength: 1000,
                decoration: InputDecoration(labelText: 'completion_note'.tr),
              ),
              if (photo != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(photo!, height: 160, fit: BoxFit.cover),
                ),
              OutlinedButton.icon(
                onPressed: () async {
                  final x = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                    maxWidth: 1600,
                    imageQuality: 70,
                  );
                  if (x != null) setState(() => photo = File(x.path));
                },
                icon: const Icon(Icons.photo_camera),
                label: Text(photo == null ? 'add_photo'.tr : 'retake_photo'.tr),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  try {
                    await ctrl.submitTask(task, note: note.text.trim(), photo: photo);
                  } catch (e) {
                    Notify.failure(e);
                  }
                },
                child: Text('submit'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
