import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/controllers/navigation_controller.dart';
import '../controllers/task_controller.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(TaskController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('माझी कार्ये (Tasks)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: ctrl.loadTasks,
          ),
        ],
      ),
      body: Column(children: [
        // Filter chips
        Container(
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Obx(() => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: ['ALL', 'OPEN', 'IN_PROGRESS', 'SUBMITTED'].map((f) {
              final active = ctrl.filter.value == f;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(_filterLabel(f),
                    style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500,
                      color: active ? Colors.white : AppColors.primary,
                    )),
                  selected: active,
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.primarySurface,
                  checkmarkColor: Colors.white,
                  side: BorderSide(color: active ? AppColors.primary : AppColors.primaryTonal),
                  onSelected: (_) {
                    ctrl.filter.value = f;
                    ctrl.loadTasks();
                  },
                ),
              );
            }).toList()),
          )),
        ),

        // Task list
        Expanded(
          child: Obx(() {
            if (ctrl.isLoading.value) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }
            if (ctrl.tasks.isEmpty) {
              return const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.task_alt, size: 64, color: AppColors.border),
                SizedBox(height: 12),
                Text('कोणतेही कार्य नाही', style: TextStyle(fontFamily: 'NotoSansDevanagari', color: AppColors.subtle)),
              ]));
            }
            return RefreshIndicator(
              onRefresh: ctrl.loadTasks,
              color: AppColors.primary,
              child: ListView.separated(
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

  String _filterLabel(String f) => switch (f) {
    'ALL'         => 'सर्व',
    'OPEN'        => 'नवीन',
    'IN_PROGRESS' => 'सुरू',
    'SUBMITTED'   => 'पाठवलेले',
    _             => f,
  };
}

class _TaskCard extends StatefulWidget {
  final Map<String, dynamic> task;
  final TaskController ctrl;

  const _TaskCard({required this.task, required this.ctrl});

  @override
  State<_TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<_TaskCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final ctrl = widget.ctrl;
    final priority = task['priority'] as String? ?? 'NORMAL';
    final status   = task['status']   as String? ?? 'OPEN';
    final dueAt    = task['due_at']   as String?;

    final latNum = (task['location_lat'] as num?)?.toDouble() ?? 16.8524;
    final lngNum = (task['location_lng'] as num?)?.toDouble() ?? 74.5815;
    final locationLabel = task['location_label'] as String? ?? 'सांगली कार्यक्षेत्र (Sangli)';

    Color priorityColor = switch (priority) {
      'URGENT' => const Color(0xFFC62828),
      'NORMAL' => const Color(0xFFF57F17),
      _        => AppColors.subtle,
    };

    return InkWell(
      onTap: () {
        setState(() => _expanded = !_expanded);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _expanded ? AppColors.primary : AppColors.border,
            width: _expanded ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _expanded ? 0.08 : 0.04),
              blurRadius: _expanded ? 10 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // Priority bar
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: priorityColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _PriorityBadge(priority: priority, color: priorityColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          task['title'] ?? 'Task',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _StatusChip(status: status),
                    ],
                  ),
                  if (task['description'] != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      task['description'],
                      style: const TextStyle(fontSize: 12, color: AppColors.subtle),
                      maxLines: _expanded ? 10 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 10),

                  // Location and Due time summary row
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          locationLabel,
                          style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (dueAt != null) ...[
                        const Icon(Icons.access_time, size: 14, color: AppColors.subtle),
                        const SizedBox(width: 4),
                        Text(
                          _formatDue(dueAt),
                          style: TextStyle(
                            fontSize: 11,
                            color: _isOverdue(dueAt) ? const Color(0xFFC62828) : AppColors.subtle,
                            fontWeight: _isOverdue(dueAt) ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                      const SizedBox(width: 6),
                      Icon(
                        _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        size: 18,
                        color: AppColors.subtle,
                      ),
                    ],
                  ),

                  // ── EXPANDED LOCATION CARD & MINI MAP ──
                  if (_expanded) ...[
                    const SizedBox(height: 12),
                    Container(
                      height: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            FlutterMap(
                              options: MapOptions(
                                initialCenter: LatLng(latNum, lngNum),
                                initialZoom: 15,
                                interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.smkmc.fieldops',
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: LatLng(latNum, lngNum),
                                      width: 40,
                                      height: 40,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade700,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 2),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.3),
                                              blurRadius: 6,
                                            ),
                                          ],
                                        ),
                                        child: const Icon(Icons.work, color: Colors.white, size: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Positioned(
                              top: 8,
                              left: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.94),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.pin_drop, size: 16, color: Colors.red),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        '$locationLabel (${latNum.toStringAsFixed(4)}, ${lngNum.toStringAsFixed(4)})',
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: FilledButton.tonalIcon(
                                onPressed: () {
                                  Get.find<NavigationController>().navigateTo(1); // Beat Map tab
                                },
                                style: FilledButton.styleFrom(
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor: Colors.white,
                                  elevation: 2,
                                ),
                                icon: const Icon(Icons.open_in_new, size: 14, color: AppColors.primary),
                                label: const Text('बीट नकाशावर पहा', style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // Action buttons
                  if (status == 'OPEN') ...[
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: () => ctrl.startTask(task['id']),
                      icon: const Icon(Icons.play_arrow, size: 16),
                      label: const Text('सुरू करा', style: TextStyle(fontFamily: 'NotoSansDevanagari', fontSize: 13)),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(38),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                  if (status == 'IN_PROGRESS') ...[
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: () => _showSubmitDialog(context),
                      icon: const Icon(Icons.camera_alt, size: 16),
                      label: const Text('Photo घेऊन Submit करा', style: TextStyle(fontFamily: 'NotoSansDevanagari', fontSize: 13)),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        minimumSize: const Size.fromHeight(38),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSubmitDialog(BuildContext context) {
    File? pickedPhoto;
    final noteCtrl = TextEditingController(text: 'काम पूर्ण झाले (Live Photo Proof)');
    final isUploading = false.obs;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (ctx, setState) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.camera_alt, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'कार्य पूर्णतेचा थेट फोटो व पुरावा',
                        style: TextStyle(
                          fontFamily: 'NotoSansDevanagari',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'अँटी-फ्रॉड सुरक्षा: गॅलरी फोटो बंद असून फक्त थेट कॅमेरा फोटो स्वीकारला जातो.',
                    style: TextStyle(fontSize: 11, color: AppColors.subtle),
                  ),
                  const SizedBox(height: 14),
                  if (pickedPhoto != null)
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          pickedPhoto!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton.icon(
                        onPressed: () async {
                          final picker = ImagePicker();
                          final xFile = await picker.pickImage(
                            source: ImageSource.camera,
                            maxWidth: 1024,
                            imageQuality: 85,
                          );
                          if (xFile != null) {
                            setState(() => pickedPhoto = File(xFile.path));
                          }
                        },
                        style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('थेट कॅमेरा फोटो घ्या (Live Photo)'),
                      ),
                    ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: noteCtrl,
                    decoration: const InputDecoration(
                      labelText: 'पूर्णतेची नोंद (Completion Note)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(() => SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                      onPressed: isUploading.value
                          ? null
                          : () async {
                              isUploading.value = true;
                              String photoUrl = '';
                              if (pickedPhoto != null && pickedPhoto!.existsSync()) {
                                try {
                                  final bytes = await pickedPhoto!.readAsBytes();
                                  final fileName = 'tasks/after_${DateTime.now().millisecondsSinceEpoch}.jpg';
                                  await Supabase.instance.client.storage
                                      .from('attendance-photos')
                                      .uploadBinary(
                                        fileName,
                                        bytes,
                                        fileOptions: const FileOptions(
                                          contentType: 'image/jpeg',
                                          upsert: true,
                                        ),
                                      );
                                  photoUrl = Supabase.instance.client.storage
                                      .from('attendance-photos')
                                      .getPublicUrl(fileName);
                                } catch (e) {
                                  debugPrint('Task photo upload note: $e');
                                }
                              }

                              await widget.ctrl.submitTask(
                                taskId: widget.task['id'],
                                afterPhotoUrl: photoUrl,
                                note: noteCtrl.text.trim(),
                              );
                              isUploading.value = false;
                              Get.back();
                            },
                      child: isUploading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Submit करा'),
                    ),
                  )),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  String _formatDue(String dueAt) {
    try {
      final dt = DateTime.parse(dueAt).toLocal();
      final now = DateTime.now();
      final diff = dt.difference(now);
      if (diff.isNegative) return 'मुदत संपली (${diff.inHours.abs()}h आधी)';
      if (diff.inHours < 1) return '${diff.inMinutes}m शिल्लक';
      return '${diff.inHours}h शिल्लक';
    } catch (_) {
      return dueAt;
    }
  }

  bool _isOverdue(String dueAt) {
    try {
      return DateTime.parse(dueAt).isBefore(DateTime.now());
    } catch (_) {
      return false;
    }
  }
}

class _PriorityBadge extends StatelessWidget {
  final String priority;
  final Color color;

  const _PriorityBadge({required this.priority, required this.color});

  @override
  Widget build(BuildContext context) {
    String label = switch (priority) {
      'URGENT' => 'तातडीचे',
      'NORMAL' => 'सामान्य',
      _        => priority,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case 'OPEN':
        bg = Colors.grey.shade100;
        fg = AppColors.subtle;
        label = 'नवीन';
      case 'IN_PROGRESS':
        bg = const Color(0xFFE3F2FD);
        fg = const Color(0xFF1565C0);
        label = 'सुरू';
      case 'SUBMITTED':
        bg = AppColors.primarySurface;
        fg = AppColors.primary;
        label = 'पाठवले';
      case 'APPROVED':
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF2E7D32);
        label = 'मंजूर';
      default:
        bg = Colors.grey.shade100;
        fg = AppColors.subtle;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}
