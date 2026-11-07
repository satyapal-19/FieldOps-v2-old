import 'package:fieldops_api/fieldops_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/controllers/auth_controller.dart';
import '../../../core/outbox/outbox_service.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../attendance/controllers/attendance_controller.dart';
import '../../more/screens/attendance_history_screen.dart';
import '../../more/screens/leave_screen.dart';
import 'report_issue_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final att = Get.find<AttendanceController>();
    final outbox = Get.find<OutboxService>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await att.loadToday();
            await outbox.flush();
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Obx(() {
                auth.profile.value;
                auth.homeWard.value;
                return _Header(
                  name: auth.displayName,
                  subtitle: [auth.wardName, auth.department].where((s) => s.isNotEmpty).join(' · '),
                  role: 'role_${auth.staffRole}'.tr,
                );
              }),
              Obx(() => outbox.pending.value == 0
                  ? const SizedBox(height: 12)
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(children: [
                        const Icon(Icons.cloud_upload_outlined, size: 18, color: AppColors.warning),
                        const SizedBox(width: 6),
                        Text('pending_upload'.trParams({'n': '${outbox.pending.value}'}),
                            style: const TextStyle(color: AppColors.warning, fontSize: 13)),
                      ]),
                    )),
              Obx(() => _ShiftStrip(shift: att.shift.value)),
              const SizedBox(height: 12),
              Obx(() => _PunchCard(
                    log: att.todayLog.value,
                    loading: att.isLoading.value,
                    checkedIn: att.isCheckedIn,
                    checkedOut: att.isCheckedOut,
                    hours: att.hoursWorked,
                    failure: att.loadFailure.value?.message(AuthController.lang),
                  )),
              const SizedBox(height: 16),
              Text('quick_actions'.tr, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 8),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [
                  _Action(icon: Icons.event_busy, label: 'leave_and_corrections'.tr,
                      onTap: () => Get.to(() => const LeaveScreen())),
                  _Action(icon: Icons.report_problem_outlined, label: 'report_issue'.tr,
                      onTap: () => Get.to(() => const ReportIssueScreen())),
                  _Action(icon: Icons.history, label: 'attendance_history'.tr,
                      onTap: () => Get.to(() => const AttendanceHistoryScreen())),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String name;
  final String subtitle;
  final String role;
  const _Header({required this.name, required this.subtitle, required this.role});

  @override
  Widget build(BuildContext context) => Row(children: [
        const CircleAvatar(
          radius: 26,
          backgroundColor: AppColors.primarySurface,
          child: Icon(Icons.person, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            Text(role, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
            if (subtitle.isNotEmpty)
              Text(subtitle, style: const TextStyle(color: AppColors.subtle, fontSize: 12)),
          ]),
        ),
      ]);
}

class _ShiftStrip extends StatelessWidget {
  final EffectiveShiftDto? shift;
  const _ShiftStrip({required this.shift});

  @override
  Widget build(BuildContext context) {
    final s = shift;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        const Icon(Icons.schedule, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(s == null ? 'no_shift_today'.tr : '${'shift'.tr}: ${s.startTime} – ${s.endTime}',
            style: const TextStyle(fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class _PunchCard extends StatelessWidget {
  final AttendanceLogDto? log;
  final bool loading;
  final bool checkedIn;
  final bool checkedOut;
  final String hours;
  final String? failure;

  const _PunchCard({
    required this.log,
    required this.loading,
    required this.checkedIn,
    required this.checkedOut,
    required this.hours,
    required this.failure,
  });

  @override
  Widget build(BuildContext context) {
    final t = DateFormat('HH:mm');
    final inAt = log?.checkin?.at.toLocal();
    final outAt = log?.checkout?.at.toLocal();
    final status = log == null ? 'not_checked_in'.tr : 'status_${log!.status.name}'.tr;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Text('today'.tr, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const Spacer(),
          if (loading)
            const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
          else
            Text(status, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
        ]),
        if (failure != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(failure!, style: const TextStyle(color: AppColors.error, fontSize: 12)),
          ),
        const SizedBox(height: 12),
        Row(children: [
          _Stat(label: 'check_in'.tr, value: inAt == null ? '—' : t.format(inAt)),
          _Stat(label: 'check_out'.tr, value: outAt == null ? '—' : t.format(outAt)),
          _Stat(label: 'hours'.tr, value: hours),
        ]),
        if (log?.isLate ?? false)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('${'late_by'.tr} ${log!.lateMinutes} ${'minutes'.tr}',
                style: const TextStyle(color: AppColors.late)),
          ),
        const SizedBox(height: 16),
        if (!checkedOut)
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: checkedIn ? AppColors.error : AppColors.primary,
            ),
            onPressed: () => Get.toNamed(checkedIn ? AppRoutes.checkOutFlow : AppRoutes.checkInFlow),
            icon: Icon(checkedIn ? Icons.logout : Icons.login),
            label: Text(checkedIn ? 'check_out'.tr : 'check_in'.tr,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          )
        else
          Text('day_complete'.tr, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.success)),
      ]),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(children: [
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          Text(label, style: const TextStyle(color: AppColors.subtle, fontSize: 12)),
        ]),
      );
}

class _Action extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _Action({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: 6),
            Text(label, textAlign: TextAlign.center, maxLines: 2, style: const TextStyle(fontSize: 11)),
          ]),
        ),
      );
}
