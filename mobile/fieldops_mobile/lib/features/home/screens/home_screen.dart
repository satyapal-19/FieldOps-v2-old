import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/controllers/locale_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../attendance/controllers/attendance_controller.dart';
import '../../attendance/screens/checkin_flow_screen.dart';
import '../../map/screens/qr_scanner_screen.dart';
import '../../more/screens/leave_screen.dart';
import 'report_issue_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth       = Get.find<AuthController>();
    final attendance = Get.find<AttendanceController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Green Header ────────────────────────────────────
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.account_balance, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            const Text('SMKMC FieldOps',
                              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            Obx(() => attendance.isOffline.value
                              ? Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade700,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                                    Icon(Icons.wifi_off, color: Colors.white, size: 12),
                                    SizedBox(width: 4),
                                    Text('Offline', style: TextStyle(color: Colors.white, fontSize: 11)),
                                  ]),
                                )
                              : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Obx(() {
                          final _ = Get.find<LocaleController>().currentLocale.value;
                          final isEn = Get.find<LocaleController>().currentLocale.value.languageCode == 'en';
                          final name = isEn
                              ? (auth.staffName.isNotEmpty ? auth.staffName : auth.staffNameMr)
                              : (auth.staffNameMr.isNotEmpty ? auth.staffNameMr : auth.staffName);
                          return Text(
                            '${'greeting_prefix'.tr}, $name 🙏',
                            style: const TextStyle(
                              fontFamily: 'NotoSansDevanagari',
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        }),
                        const SizedBox(height: 4),
                        Obx(() {
                          final dept = auth.department;
                          final ward = auth.wardName;
                          return Text(
                            '$dept · $ward',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                onPressed: () => _showNotificationsSheet(context),
              ),
            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // ── Pending sync banner ──────────────────────
                Obx(() => attendance.hasPendingSync.value
                  ? Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: const Row(children: [
                        Icon(Icons.sync, color: Colors.orange, size: 16),
                        SizedBox(width: 8),
                        Expanded(child: Text(
                          'Offline डेटा pending — Network मिळताच sync होईल',
                          style: TextStyle(fontFamily: 'NotoSansDevanagari', fontSize: 12, color: Colors.orange),
                        )),
                      ]),
                    )
                  : const SizedBox.shrink(),
                ),

                // ── Shift info strip ─────────────────────────
                _ShiftInfoStrip(),
                const SizedBox(height: 16),

                // ── CHECK-IN CARD ────────────────────────────
                Obx(() => _CheckInCard(
                  status: attendance.attendanceStatus.value,
                  todayLog: attendance.todayLog.value,
                  isLoading: attendance.isLoading.value,
                  onCheckIn: () => Get.to(
                    () => const CheckInFlowScreen(),
                    transition: Transition.rightToLeft,
                  ),
                  onCheckOut: () => Get.to(
                    () => const CheckInFlowScreen(isCheckOut: true),
                    transition: Transition.rightToLeft,
                  ),
                )),
                const SizedBox(height: 16),

                // ── Today's Stats ────────────────────────────
                Obx(() => _StatsRow(
                  checkpointsDone:  attendance.checkpointsDone.value,
                  checkpointsTotal: attendance.checkpointsTotal.value,
                  tasksCompleted:   attendance.tasksCompleted.value,
                  tasksTotal:       attendance.tasksTotal.value,
                  hoursWorked:      attendance.hoursWorked.value,
                )),
                const SizedBox(height: 16),

                // ── Quick Actions ────────────────────────────
                _QuickActions(),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shift Info Strip ──────────────────────────────────────────

class _ShiftInfoStrip extends StatelessWidget {
  static String formatShiftTiming(String? shift, dynamic rawStart, dynamic rawEnd) {
    String formatTime(dynamic t, String fallback) {
      if (t == null) return fallback;
      final str = t.toString().trim();
      final parts = str.split(':');
      if (parts.length >= 2) {
        int hour = int.tryParse(parts[0]) ?? 6;
        int minute = int.tryParse(parts[1]) ?? 0;
        final ampm = hour >= 12 ? 'PM' : 'AM';
        int hour12 = hour % 12;
        if (hour12 == 0) hour12 = 12;
        return '${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $ampm';
      }
      return fallback;
    }

    final startStr = formatTime(rawStart, '06:00 AM');
    final endStr = formatTime(rawEnd, '02:00 PM');

    final shiftUpper = (shift ?? 'MORNING').toUpperCase();
    String label = 'सकाळ';
    if (shiftUpper.contains('AFTERNOON') || shiftUpper.contains('EVENING')) {
      label = 'दुपार';
    } else if (shiftUpper.contains('NIGHT')) {
      label = 'रात्र';
    } else if (shiftUpper.contains('ADMIN') || shiftUpper.contains('GENERAL')) {
      label = 'सामान्य';
    }

    return '$label ($startStr–$endStr)';
  }

  @override
  Widget build(BuildContext context) {
    final auth  = Get.find<AuthController>();
    final now   = DateTime.now();
    final dateF = DateFormat('d MMM yyyy, EEEE').format(now);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        const Icon(Icons.calendar_today, color: AppColors.primary, size: 16),
        const SizedBox(width: 8),
        Text(dateF, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const Spacer(),
        Obx(() {
          final staff = auth.currentStaff.value;
          final shift = staff?['shift'] ?? 'MORNING';
          final start = staff?['shift_start'] ?? '06:00';
          final end   = staff?['shift_end']   ?? '14:00';
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              formatShiftTiming(shift, start, end),
              style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
          );
        }),
      ]),
    );
  }
}

// ── Check-in Card ─────────────────────────────────────────────

class _CheckInCard extends StatelessWidget {
  final AttendanceStatus status;
  final Map<String, dynamic>? todayLog;
  final bool isLoading;
  final VoidCallback onCheckIn;
  final VoidCallback onCheckOut;

  const _CheckInCard({
    required this.status,
    required this.todayLog,
    required this.isLoading,
    required this.onCheckIn,
    required this.onCheckOut,
  });

  @override
  Widget build(BuildContext context) {
    final isCheckedIn = status == AttendanceStatus.present ||
                        status == AttendanceStatus.late;
    final isCheckedOut = status == AttendanceStatus.checkedOut;

    Color cardColor;
    IconData statusIcon;
    String statusText;
    String statusSubtext;

    if (isCheckedOut) {
      cardColor   = const Color(0xFF1565C0);
      statusIcon  = Icons.check_circle;
      statusText  = 'शिफ्ट पूर्ण झाली ✓';
      statusSubtext = 'आजची उपस्थिती नोंदवली गेली आहे';
    } else if (isCheckedIn) {
      cardColor   = AppColors.primary;
      statusIcon  = Icons.location_on;
      statusText  = 'Check-in झाला आहे ✓';
      final time  = todayLog?['checkin_time'];
      statusSubtext = time != null
          ? 'वेळ: ${DateFormat('hh:mm a').format(DateTime.parse(time))}'
          : 'आज उपस्थित';
    } else {
      cardColor   = const Color(0xFF37474F);
      statusIcon  = Icons.fingerprint;
      statusText  = 'Check-in करा';
      statusSubtext = 'Biometric + GPS + Selfie सह उपस्थिती नोंदवा';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cardColor, cardColor.withValues(alpha: 0.85)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cardColor.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(statusIcon, color: Colors.white, size: 26),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(statusText,
                  style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(statusSubtext,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12,
                    fontFamily: 'NotoSansDevanagari',
                  ),
                ),
              ],
            )),
            // Face match score badge if available
            if (isCheckedIn && todayLog?['checkin_face_score'] != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(children: [
                  Text(
                    '${(((todayLog!['checkin_face_score'] as num?)?.toDouble() ?? 0.0) * 100).toInt()}%',
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  const Text('Face', style: TextStyle(color: Colors.white70, fontSize: 10)),
                ]),
              ),
          ]),

          if (!isCheckedOut) ...[
            const SizedBox(height: 20),
            isLoading
              ? const Center(child: SizedBox(height: 48, width: 48,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)))
              : isCheckedIn
                ? OutlinedButton.icon(
                    onPressed: onCheckOut,
                    icon: const Icon(Icons.logout, size: 18, color: Colors.white),
                    label: const Text('Check-out करा', style: TextStyle(color: Colors.white, fontSize: 14)),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
                      side: const BorderSide(color: Colors.white54),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  )
                : FilledButton.icon(
                    onPressed: onCheckIn,
                    icon: const Icon(Icons.fingerprint, size: 20),
                    label: const Text('Check-in करा', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,
                      fontFamily: 'NotoSansDevanagari')),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: cardColor,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
          ],
        ],
      ),
    );
  }
}

// ── Stats Row ─────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final int checkpointsDone;
  final int checkpointsTotal;
  final int tasksCompleted;
  final int tasksTotal;
  final String hoursWorked;

  const _StatsRow({
    required this.checkpointsDone,
    required this.checkpointsTotal,
    required this.tasksCompleted,
    required this.tasksTotal,
    required this.hoursWorked,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: _StatCard(
        icon: Icons.location_on_outlined,
        value: '$checkpointsDone/$checkpointsTotal',
        label: 'Checkpoints',
        color: AppColors.primary,
      )),
      const SizedBox(width: 10),
      Expanded(child: _StatCard(
        icon: Icons.access_time,
        value: hoursWorked,
        label: 'Hours',
        color: const Color(0xFF1565C0),
      )),
      const SizedBox(width: 10),
      Expanded(child: _StatCard(
        icon: Icons.task_alt,
        value: tasksTotal == 0 ? '—' : '$tasksCompleted/$tasksTotal',
        label: 'Tasks',
        color: const Color(0xFF6A1B9A),
      )),
    ]);
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(children: [
      Icon(icon, color: color, size: 20),
      const SizedBox(height: 6),
      Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(fontSize: 11, color: AppColors.subtle)),
    ]),
  );
}

// ── Quick Actions ─────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Actions',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: _QuickActionTile(
            icon: Icons.report_problem_outlined,
            label: 'Issue Report',
            labelMr: 'तक्रार नोंदवा',
            color: Colors.orange,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ReportIssueScreen()),
            ),
          )),
          const SizedBox(width: 10),
          Expanded(child: _QuickActionTile(
            icon: Icons.qr_code_scanner,
            label: 'Scan QR',
            labelMr: 'QR स्कॅन',
            color: const Color(0xFF1565C0),
            onTap: () => Get.to(() => const QrScannerScreen()),
          )),
          const SizedBox(width: 10),
          Expanded(child: _QuickActionTile(
            icon: Icons.calendar_month_outlined,
            label: 'Leave',
            labelMr: 'रजा',
            color: const Color(0xFF6A1B9A),
            onTap: () => Get.to(() => const LeaveScreen()),
          )),
        ]),

      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String labelMr;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.labelMr,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: [
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        Text(labelMr, style: const TextStyle(fontFamily: 'NotoSansDevanagari', fontSize: 10, color: AppColors.subtle)),
      ]),
    ),
  );
}

void _showNotificationsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Container(
      height: MediaQuery.of(ctx).size.height * 0.72,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.notifications_active, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'सूचना व परिपत्रके',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'NotoSansDevanagari'),
                    ),
                    Text(
                      'सांगली मिरज कुपवाड महानगरपालिका',
                      style: TextStyle(fontSize: 11, color: AppColors.subtle),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildNotificationCard(
                  title: 'विशेष स्वच्छता व नालेसफाई मोहीम',
                  desc: 'प्रभाग ३ व ४ मध्ये पावसाळापूर्व स्वच्छता मोहीम युद्धपातळीवर सुरू ठेवावी. कचरा कुंडी दररोज साफ करावी.',
                  time: '१० मिनिटांपूर्वी',
                  tag: 'URGENT',
                  tagColor: Colors.red.shade700,
                  icon: Icons.priority_high,
                ),
                _buildNotificationCard(
                  title: 'हजेरी व बायोमेट्रिक मार्गदर्शक सूचना',
                  desc: 'सर्व कर्मचाऱ्यांनी शिफ्ट सुरू होताच थेट कॅमेऱ्याने सेल्फी काढून उपस्थिती नोंदवावी. गॅलरी फोटो बंद आहे.',
                  time: '१ तासापूर्वी',
                  tag: 'ADMIN',
                  tagColor: AppColors.primary,
                  icon: Icons.campaign,
                ),
                _buildNotificationCard(
                  title: 'बीट चेकपॉईंट्स स्कॅनिंग सूचना',
                  desc: 'सांगली, मिरज व कुपवाड प्रभागातील सर्व क्यूआर कोड चेकपॉईंट्स वेळेवर स्कॅन करण्याचे निर्देश आहेत.',
                  time: 'आज सकाळी ०६:३०',
                  tag: 'SUPERVISOR',
                  tagColor: const Color(0xFF1565C0),
                  icon: Icons.qr_code_2,
                ),
                _buildNotificationCard(
                  title: 'समस्या बीकन प्रणाली सक्रिय',
                  desc: 'क्षेत्रात आढळलेला कचरा किंवा पाणी गळती तक्रार नोंदवून नकाशावर बीकन तयार करा. काम झाल्यावर त्वरित पूर्ण करा.',
                  time: 'काल संध्याकाळी',
                  tag: 'NEW BEACON',
                  tagColor: Colors.purple.shade700,
                  icon: Icons.share_location,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildNotificationCard({
  required String title,
  required String desc,
  required String time,
  required String tag,
  required Color tagColor,
  required IconData icon,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFF9FAFB),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFE5E7EB)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: tagColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: tagColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: tagColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: tagColor),
                    ),
                  ),
                  Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'NotoSansDevanagari'),
              ),
              const SizedBox(height: 3),
              Text(
                desc,
                style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563), height: 1.3),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
