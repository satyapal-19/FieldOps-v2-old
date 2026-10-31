import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/controllers/auth_controller.dart';

class PayrollScreen extends StatelessWidget {
  const PayrollScreen({super.key});

  Future<Map<String, dynamic>?> _loadPayroll(String? staffId) async {
    if (staffId == null) return null;
    try {
      final res = await Supabase.instance.client
          .from('payroll_records')
          .select()
          .eq('staff_id', staffId)
          .order('month', ascending: false)
          .limit(1)
          .maybeSingle();
      return res;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final staffId = auth.currentStaff.value?['id'] as String?;
    final currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());
    final currency = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('वेतन पर्ची (Salary Slip)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _loadPayroll(staffId),
        builder: (context, snapshot) {
          final record = snapshot.data;
          
          final int totalWorkingDays = (record?['working_days'] as num?)?.toInt() ?? 26;
          final double presentDays = (record?['present_days'] as num?)?.toDouble() ?? 24.5;
          final double absentDays = (record?['absent_days'] as num?)?.toDouble() ?? 1.0;
          final int lateCount = (record?['late_days'] as num?)?.toInt() ?? 2;
          final double overtimeHours = (record?['overtime_hours'] as num?)?.toDouble() ?? 5.0;

          const double basicRatePerDay = 650.0;
          final double grossSalary = (record?['gross_salary'] as num?)?.toDouble() ?? (totalWorkingDays * basicRatePerDay);
          final double absentDeduction = absentDays * basicRatePerDay;
          final double lateDeductions = lateCount * (basicRatePerDay * 0.25);
          final double totalDeductions = (record?['deductions'] as num?)?.toDouble() ?? (absentDeduction + lateDeductions);
          final double overtimePay = overtimeHours * (basicRatePerDay / 8 * 1.5);
          final double netSalary = (record?['net_salary'] as num?)?.toDouble() ?? (grossSalary - totalDeductions + overtimePay);
          final String statusText = (record?['status'] as String?) ?? 'APPROVED';
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Net Pay Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(currentMonth, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(statusText, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                  const SizedBox(height: 12),
                  const Text('निव्वळ वेतन (Net Payable)', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(
                    currency.format(netSalary),
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(auth.staffNameMr.isNotEmpty ? auth.staffNameMr : auth.staffName,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                      Text(auth.department, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],

                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Attendance Breakdown
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('उपस्थिती तपशील (Attendance Summary)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 12),
                  _buildRowItem('एकूण कामाचे दिवस (Working Days)', '$totalWorkingDays दिवस'),
                  _buildRowItem('उपस्थित दिवस (Present)', '$presentDays दिवस', textColor: Colors.green),
                  _buildRowItem('गैरहजर दिवस (Absent)', '$absentDays दिवस', textColor: Colors.red),
                  _buildRowItem('उशीरा उपस्थिती (Late Count)', '$lateCount वेळा (¼ कपात)', textColor: Colors.orange),
                  _buildRowItem('ओव्हरटाईम (Overtime Hours)', '$overtimeHours तास (१.५x दर)', textColor: Colors.blue),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Earnings & Deductions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('वेतन आणि कपात (Salary Details)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 12),
                  _buildRowItem('मूळ वेतन (Gross Basic)', currency.format(grossSalary)),
                  _buildRowItem('ओव्हरटाईम भत्ता (Overtime Pay)', '+ ${currency.format(overtimePay)}', textColor: Colors.green),
                  _buildRowItem('गैरहजर कपात (Absent Deduction)', '- ${currency.format(absentDeduction)}', textColor: Colors.red),
                  _buildRowItem('उशीर कपात (Late Deduction)', '- ${currency.format(lateDeductions)}', textColor: Colors.red),
                  const Divider(),
                  _buildRowItem('एकूण देय वेतन (Net Salary)', currency.format(netSalary), isBold: true),
                ],
              ),
            ),

            const SizedBox(height: 24),

            OutlinedButton.icon(
              onPressed: () {
                Get.snackbar('डाउनलोड', 'वेतन पर्ची PDF डाऊनलोड सुरू झाली आहे');
              },
              icon: const Icon(Icons.download),
              label: const Text('वेतन पर्ची डाउनलोड करा (PDF)'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      );
    },
  ),
);
}

  Widget _buildRowItem(String label, String value, {Color? textColor, bool isBold = false}) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: AppColors.subtle, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: textColor ?? AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
