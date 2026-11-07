import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/controllers/locale_controller.dart';
import 'attendance_history_screen.dart';
import 'leave_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final localeCtrl = Get.find<LocaleController>();

    return Obx(() {
      // Observe locale changes reactively
      final _ = localeCtrl.currentLocale.value;
      final isEn = localeCtrl.currentLocale.value.languageCode == 'en';
      auth.profile.value;
      final staffName = isEn ? auth.staffName : auth.staffNameMr;
      final staffInit = staffName.isNotEmpty ? staffName[0].toUpperCase() : 'S';

      return Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 180,
              pinned: true,
              backgroundColor: AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.2),
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  staffInit,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    staffName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'NotoSansDevanagari',
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    auth.department,
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.8),
                                      fontSize: 12,
                                      fontFamily: 'NotoSansDevanagari',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'role_${auth.staffRole}'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ]),
                          const SizedBox(height: 8),
                          Text(
                            auth.wardName,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 12,
                              fontFamily: 'NotoSansDevanagari',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Attendance section
                  _SectionHeader('attendance_section'.tr),
                  _MenuTile(
                    icon: Icons.history,
                    label: 'attendance_history'.tr,
                    labelEn: 'View check-in & check-out logs',
                    onTap: () => Get.to(() => const AttendanceHistoryScreen()),
                  ),
                  const SizedBox(height: 16),

                  // Leave & corrections
                  _SectionHeader('leave_and_corrections'.tr),
                  _MenuTile(
                    icon: Icons.calendar_today_outlined,
                    label: 'leave_apply'.tr,
                    labelEn: 'Apply for leave & view balance',
                    onTap: () => Get.to(() => const LeaveScreen()),
                  ),
                  const SizedBox(height: 16),

                  // Profile & Settings
                  _SectionHeader('profile_settings_section'.tr),
                  _MenuTile(
                    icon: Icons.person_outline,
                    label: 'my_profile'.tr,
                    labelEn: 'Staff ID, ward and phone',
                    onTap: () => _showProfileSheet(context, auth),
                  ),
                  _MenuTile(
                    icon: Icons.notifications_outlined,
                    label: 'notification_settings'.tr,
                    labelEn: 'Circulars, shift & task alerts',
                    onTap: () => _showNotificationSettingsSheet(context),
                  ),
                  _MenuTile(
                    icon: Icons.language,
                    label: 'language'.tr,
                    labelEn: 'मराठी / हिंदी / English / ಕನ್ನಡ',
                    onTap: () => _showLanguageSheet(context),
                  ),
                  const SizedBox(height: 16),

                  // Help & Support
                  _SectionHeader('help_section'.tr),
                  _MenuTile(
                    icon: Icons.help_outline,
                    label: 'help_faq'.tr,
                    labelEn: 'User guide & common questions',
                    onTap: () => _showHelpFaqSheet(context),
                  ),
                  _MenuTile(
                    icon: Icons.phone_outlined,
                    label: 'it_support'.tr,
                    labelEn: 'IT Help Desk: 0233-2373000 / Email',
                    onTap: () => _showItSupportSheet(context),
                  ),
                  const SizedBox(height: 16),

                  // App info
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(children: [
                      const Text(
                        'FieldOps SMKMC',
                        style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'smkmc_title'.tr,
                        style: const TextStyle(fontSize: 12, color: AppColors.subtle, fontFamily: 'NotoSansDevanagari'),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'आवृत्ती 1.0.0 | Hackathon Build 2026',
                        style: TextStyle(fontSize: 11, color: AppColors.subtle),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 16),

                  // Sign out
                  FilledButton.icon(
                    onPressed: () => Get.dialog(AlertDialog(
                      title: Text('logout'.tr),
                      content: Text(
                        'logout_confirm'.tr,
                        style: const TextStyle(fontFamily: 'NotoSansDevanagari'),
                      ),
                      actions: [
                        TextButton(onPressed: Get.back, child: Text('no'.tr)),
                        FilledButton(
                          onPressed: () {
                            Get.back();
                            auth.signOut();
                          },
                          style: FilledButton.styleFrom(backgroundColor: Colors.red),
                          child: Text('logout'.tr),
                        ),
                      ],
                    )),
                    icon: const Icon(Icons.logout),
                    label: Text('logout'.tr, style: const TextStyle(fontFamily: 'NotoSansDevanagari')),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 80),
                ]),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ── Profile Sheet ─────────────────────────────────────────────
  void _showProfileSheet(BuildContext context, AuthController auth) {
    final staffNameMr = auth.staffNameMr;
    final staffNameEn = auth.staffName;
    final empId = auth.employeeCode;
    final phone = auth.phone;
    final dept = auth.department.isEmpty ? '—' : auth.department;
    final ward = auth.wardName.isEmpty ? '—' : auth.wardName;
    final designation = 'role_${auth.staffRole}'.tr;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primarySurface,
                    ),
                    child: Center(
                      child: Text(
                        staffNameMr.isNotEmpty ? staffNameMr[0] : 'S',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$staffNameMr ($staffNameEn)',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'NotoSansDevanagari',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          designation,
                          style: const TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: Text(
                      'active_verified'.tr,
                      style: TextStyle(fontSize: 10, color: Colors.green.shade800, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Profile Details Grid
              _ProfileDetailTile(icon: Icons.badge_outlined, title: 'employee_id'.tr, value: empId),
              _ProfileDetailTile(icon: Icons.business, title: 'department_label'.tr, value: dept),
              _ProfileDetailTile(icon: Icons.location_on_outlined, title: 'ward_zone'.tr, value: ward),
              _ProfileDetailTile(icon: Icons.phone_android, title: 'mobile_number'.tr, value: phone),
              _ProfileDetailTile(icon: Icons.access_time, title: 'shift_timing_label'.tr, value: 'सकाळ (06:00 AM – 02:00 PM)'),
              _ProfileDetailTile(icon: Icons.supervisor_account, title: 'supervisor_label'.tr, value: 'संजय पवार (स्वच्छता निरीक्षक, ९८२२० ५५५५५)'),
              _ProfileDetailTile(icon: Icons.verified_user_outlined, title: 'device_status'.tr, value: 'सक्रिय Android डिव्हाइस (बायोमेट्रिक नोंदणीकृत)'),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Get.back(),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('close'.tr),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  // ── Notification Settings Sheet ──────────────────────────────
  void _showNotificationSettingsSheet(BuildContext context) {
    final broadcastVal = true.obs;
    final shiftVal = true.obs;
    final taskVal = true.obs;
    final soundVal = true.obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.notifications_active, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Text(
                    'notifications_title'.tr,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, fontFamily: 'NotoSansDevanagari'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Obx(() => SwitchListTile(
                value: broadcastVal.value,
                onChanged: (v) => broadcastVal.value = v,
                title: Text('notif_broadcasts'.tr, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                subtitle: Text('notif_broadcasts_desc'.tr, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                activeTrackColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
              )),
              const Divider(height: 12),

              Obx(() => SwitchListTile(
                value: shiftVal.value,
                onChanged: (v) => shiftVal.value = v,
                title: Text('notif_shift'.tr, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                subtitle: Text('notif_shift_desc'.tr, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                activeTrackColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
              )),
              const Divider(height: 12),

              Obx(() => SwitchListTile(
                value: taskVal.value,
                onChanged: (v) => taskVal.value = v,
                title: Text('notif_tasks'.tr, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                subtitle: Text('notif_tasks_desc'.tr, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                activeTrackColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
              )),
              const Divider(height: 12),

              Obx(() => SwitchListTile(
                value: soundVal.value,
                onChanged: (v) => soundVal.value = v,
                title: Text('notif_sound_vibrate'.tr, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                activeTrackColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
              )),
              const Divider(height: 12),

              SwitchListTile(
                value: true,
                onChanged: null,
                title: Text('notif_emergency'.tr, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.red)),
                subtitle: Text('notif_emergency_desc'.tr, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                activeTrackColor: Colors.red,
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Get.back();
                    Get.snackbar(
                      'notification_settings'.tr,
                      'preferences_saved'.tr,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.primary,
                      colorText: Colors.white,
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('save_preferences'.tr),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  // ── Help & FAQ Sheet ──────────────────────────────────────────
  void _showHelpFaqSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.help_center_outlined, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Text(
                    'faq_section'.tr,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, fontFamily: 'NotoSansDevanagari'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _FaqAccordion(question: 'faq_q1'.tr, answer: 'faq_a1'.tr),
              _FaqAccordion(question: 'faq_q2'.tr, answer: 'faq_a2'.tr),
              _FaqAccordion(question: 'faq_q3'.tr, answer: 'faq_a3'.tr),

              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  Get.back();
                  _showItSupportSheet(context);
                },
                icon: const Icon(Icons.phone_outlined),
                label: Text('it_support'.tr),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                  side: const BorderSide(color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Get.back(),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('close'.tr),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  // ── IT Support Help Desk Sheet ────────────────────────────────
  void _showItSupportSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.support_agent, color: AppColors.primary, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'help_title'.tr,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'NotoSansDevanagari'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Helpline card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.phone, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'helpline_phone'.tr,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '०२३३-२३७३००० (0233 2373000) / +91 98220 99999',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    FilledButton.icon(
                      onPressed: () async {
                        final uri = Uri.parse('tel:+919822099999');
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      },
                      icon: const Icon(Icons.call, size: 16),
                      label: Text('call_now'.tr),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size.fromHeight(38),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Email support card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.email_outlined, color: Colors.blue, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'support_email'.tr,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blue),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'fieldops-support@smkmc.gov.in\nitcell@smkmc.gov.in',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final uri = Uri.parse('mailto:fieldops-support@smkmc.gov.in?subject=FieldOps Mobile Support Request');
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      },
                      icon: const Icon(Icons.send, size: 16),
                      label: Text('email_now'.tr),
                      style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(38)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Address & Timings
              _ProfileDetailTile(icon: Icons.account_balance, title: 'office_address'.tr, value: 'office_address_val'.tr),
              _ProfileDetailTile(icon: Icons.access_time, title: 'office_timing'.tr, value: 'office_timing_val'.tr),

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Get.back(),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('close'.tr),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  // ── Language Selector Sheet ───────────────────────────────────
  void _showLanguageSheet(BuildContext context) {
    final localeCtrl = Get.find<LocaleController>();
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.language, color: AppColors.primary, size: 24),
                const SizedBox(width: 10),
                Text(
                  'select_language'.tr,
                  style: const TextStyle(
                    fontFamily: 'NotoSansDevanagari',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...LocaleController.supportedLocales.map((loc) {
              return Obx(() {
                final isSelected = localeCtrl.currentLocale.value.languageCode == loc['code'];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primarySurface : const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      loc['name'] as String,
                      style: TextStyle(
                        fontFamily: 'NotoSansDevanagari',
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? AppColors.primary : Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      loc['subname'] as String,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: AppColors.primary)
                        : null,
                    onTap: () async {
                      await localeCtrl.changeLocale(loc['code'] as String);
                      Get.back();
                    },
                  ),
                );
              });
            }),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader(this.label);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 8),
    child: Text(
      label,
      style: const TextStyle(
        fontFamily: 'NotoSansDevanagari',
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.subtle,
        letterSpacing: 0.5,
      ),
    ),
  );
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String labelEn;
  final VoidCallback onTap;

  const _MenuTile({required this.icon, required this.label, required this.labelEn, required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(12),
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                label,
                style: const TextStyle(fontFamily: 'NotoSansDevanagari', fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Text(labelEn, style: const TextStyle(fontSize: 11, color: AppColors.subtle)),
            ]),
          ),
          const Icon(Icons.chevron_right, color: AppColors.border, size: 20),
        ]),
      ),
    ),
  );
}

class _ProfileDetailTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileDetailTile({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500)),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'NotoSansDevanagari'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqAccordion extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqAccordion({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'NotoSansDevanagari'),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        children: [
          Text(
            answer,
            style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563), height: 1.4, fontFamily: 'NotoSansDevanagari'),
          ),
        ],
      ),
    );
  }
}
