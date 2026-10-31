import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/controllers/auth_controller.dart';

class TaskController extends GetxController {
  final _supabase = Supabase.instance.client;
  final tasks     = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final filter    = 'ALL'.obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  Future<void> loadTasks() async {
    isLoading.value = true;
    try {
      final auth = Get.find<AuthController>();
      final staffId = auth.currentStaff.value?['id'];
      final wardId = auth.currentStaff.value?['ward_id'];
      final isSupervisor = auth.isSupervisor;

      List<dynamic> data = [];

      // 1. Try loading tasks specifically assigned to this staff member
      if (staffId != null) {
        var query = _supabase.from('tasks').select();
        if (filter.value != 'ALL') {
          query = query.eq('status', filter.value);
        }
        if (isSupervisor) {
          // Supervisors see all tasks in their zone / system
          data = await query.order('created_at', ascending: false).limit(30);
        } else {
          // Field staff see their tasks or tasks in their ward
          data = await query
              .or('assigned_to.eq.$staffId,ward_id.eq.$wardId')
              .order('created_at', ascending: false)
              .limit(30);
          
          // If no specific tasks assigned, load open field tasks for this ward
          if (data.isEmpty && wardId != null) {
            var fallbackQuery = _supabase.from('tasks').select().eq('ward_id', wardId);
            if (filter.value != 'ALL') {
              fallbackQuery = fallbackQuery.eq('status', filter.value);
            }
            data = await fallbackQuery.order('created_at', ascending: false).limit(20);
          }
        }
      }

      tasks.value = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      Get.log('Error loading tasks: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startTask(String taskId) async {
    await _supabase.from('tasks').update({
      'status':     'IN_PROGRESS',
      'started_at': DateTime.now().toIso8601String(),
    }).eq('id', taskId);
    await loadTasks();
  }

  Future<void> submitTask({
    required String taskId,
    required String afterPhotoUrl,
    required String note,
  }) async {
    await _supabase.from('tasks').update({
      'status':          'SUBMITTED',
      'after_photo_url': afterPhotoUrl,
      'completion_note': note,
      'completed_at':    DateTime.now().toIso8601String(),
    }).eq('id', taskId);
    await loadTasks();
  }
}
