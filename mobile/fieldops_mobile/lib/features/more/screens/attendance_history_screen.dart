import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/controllers/auth_controller.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  final _supabase = Supabase.instance.client;
  final _auth = Get.find<AuthController>();

  bool _isLoading = true;
  List<Map<String, dynamic>> _logs = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final staffId = _auth.currentStaff.value?['id'];
    if (staffId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final res = await _supabase
          .from('attendance_logs')
          .select()
          .eq('staff_id', staffId)
          .order('date', ascending: false)
          .limit(30);

      setState(() => _logs = List<Map<String, dynamic>>.from(res));
    } catch (_) {} finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('उपस्थिती इतिहास (History)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _logs.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history_outlined, size: 64, color: AppColors.border),
                      SizedBox(height: 12),
                      Text('मागील हजेरी नोंदी सापडल्या नाहीत',
                          style: TextStyle(fontFamily: 'NotoSansDevanagari', color: AppColors.subtle)),
                    ],
                  ),
                )

              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _logs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final item = _logs[i];
                    final dateStr = item['date'] as String? ?? '';
                    final status = item['status'] as String? ?? 'PRESENT';
                    final checkinTime = item['checkin_time'] as String?;
                    final checkoutTime = item['checkout_time'] as String?;
                    final withinGeofence = item['checkin_within_geofence'] as bool? ?? true;
                    final faceScore = item['checkin_face_score'] as num?;

                    final parsedDate = DateTime.tryParse(dateStr);
                    final formattedDate = parsedDate != null ? DateFormat('EEEE, dd MMM yyyy').format(parsedDate) : dateStr;

                    final (statusLabel, statusColor) = switch (status) {
                      'PRESENT' => ('उपस्थित', Colors.green),
                      'LATE' => ('उशीर', Colors.orange),
                      'ABSENT' => ('गैरहजर', Colors.red),
                      'HALF_DAY' => ('अर्धा दिवस', Colors.amber),
                      _ => (status, AppColors.subtle),
                    };

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 4, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(formattedDate, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(statusLabel, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoChip(
                                  Icons.login,
                                  'Check-in',
                                  checkinTime != null ? DateFormat('hh:mm a').format(DateTime.parse(checkinTime)) : '—',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildInfoChip(
                                  Icons.logout,
                                  'Check-out',
                                  checkoutTime != null ? DateFormat('hh:mm a').format(DateTime.parse(checkoutTime)) : '—',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                withinGeofence ? Icons.check_circle : Icons.warning,
                                color: withinGeofence ? Colors.green : Colors.orange,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                withinGeofence ? 'Ward Zone मध्ये' : 'Zone बाहेर हजेरी',
                                style: TextStyle(fontSize: 11, color: withinGeofence ? Colors.green : Colors.orange),
                              ),
                              if (faceScore != null) ...[
                                const SizedBox(width: 12),
                                const Icon(Icons.face, size: 14, color: AppColors.primary),
                                const SizedBox(width: 4),
                                Text(
                                  'Face Match: ${(faceScore * 100).toInt()}%',
                                  style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, String value) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.subtle),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 9, color: AppColors.subtle)),
              Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
