import 'package:fieldops_api/fieldops_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/api/api_failure.dart';
import '../../../core/api/api_service.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../attendance/attendance_rules.dart';

/// My last 31 days from `GET /attendance` (marks come from the server).
class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  final _auth = Get.find<AuthController>();
  bool _loading = true;
  ApiFailure? _failure;
  List<AttendanceLogDto> _logs = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _failure = null;
    });
    final now = DateTime.now().toUtc();
    try {
      final page = (await Get.find<ApiService>().attendance.attendanceControllerList(
        staffId: _auth.staffId,
        from: AttendanceRules.istDate(now.subtract(const Duration(days: 30))),
        to: AttendanceRules.istDate(now),
        pageSize: 50,
      ))
          .data!;
      _logs = page.items.toList()..sort((a, b) => b.date.compareTo(a.date));
    } catch (e) {
      _failure = ApiFailure.from(e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  static Color statusColor(AttendanceLogDtoStatusEnum s) => switch (s.name) {
        'PRESENT' || 'REGULARIZED' => AppColors.present,
        'LATE' || 'HALF_DAY' => AppColors.late,
        'ABSENT' => AppColors.absent,
        'ON_LEAVE' || 'HOLIDAY_OFF' => AppColors.holiday,
        _ => AppColors.subtle,
      };

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('HH:mm');
    final day = DateFormat('EEE, dd MMM');
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('attendance_history'.tr)),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _failure != null
                ? ListView(children: [
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(_failure!.message(AuthController.lang), textAlign: TextAlign.center),
                    ),
                  ])
                : _logs.isEmpty
                    ? ListView(children: [
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text('no_records'.tr, textAlign: TextAlign.center),
                        ),
                      ])
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _logs.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, i) {
                          final l = _logs[i];
                          final inAt = l.checkin?.at.toLocal();
                          final outAt = l.checkout?.at.toLocal();
                          final color = statusColor(l.status);
                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(day.format(DateTime.parse(l.date)),
                                          style: const TextStyle(fontWeight: FontWeight.w700)),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${inAt == null ? '—' : time.format(inAt)}  →  ${outAt == null ? '—' : time.format(outAt)}'
                                        '${l.workedMinutes == null ? '' : '   ${AttendanceRules.hoursLabel(l.workedMinutes!.toInt())}'}',
                                        style: const TextStyle(color: AppColors.subtle),
                                      ),
                                      if (l.isSuspicious)
                                        Text('flagged_for_review'.tr,
                                            style: const TextStyle(color: AppColors.warning, fontSize: 12)),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text('status_${l.status.name}'.tr,
                                      style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
