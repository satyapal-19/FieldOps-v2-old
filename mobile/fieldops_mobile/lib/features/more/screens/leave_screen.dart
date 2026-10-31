import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/controllers/auth_controller.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({super.key});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  final _auth = Get.find<AuthController>();
  final _supabase = Supabase.instance.client;
  final _reasonController = TextEditingController();

  String _leaveType = 'CASUAL';
  DateTime _fromDate = DateTime.now().add(const Duration(days: 1));
  DateTime _toDate = DateTime.now().add(const Duration(days: 1));
  bool _isLoading = false;
  List<Map<String, dynamic>> _myLeaves = [];

  @override
  void initState() {
    super.initState();
    _loadMyLeaves();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _loadMyLeaves() async {
    final staffId = _auth.currentStaff.value?['id'];
    if (staffId == null) return;
    try {
      final res = await _supabase
          .from('leave_requests')
          .select()
          .eq('staff_id', staffId)
          .order('created_at', ascending: false);
      setState(() => _myLeaves = List<Map<String, dynamic>>.from(res));
    } catch (_) {}
  }

  Future<void> _applyLeave() async {
    if (_reasonController.text.trim().isEmpty) {
      Get.snackbar('माहिती आवश्यक', 'कृपया रजेचे कारण लिहा');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final staffId = _auth.currentStaff.value?['id'];
      final days = _toDate.difference(_fromDate).inDays + 1;

      await _supabase.from('leave_requests').insert({
        'staff_id': staffId,
        'leave_type': _leaveType,
        'from_date': DateFormat('yyyy-MM-dd').format(_fromDate),
        'to_date': DateFormat('yyyy-MM-dd').format(_toDate),
        'days_count': days,
        'reason': _reasonController.text.trim(),
        'status': 'PENDING',
      });

      _reasonController.clear();
      await _loadMyLeaves();

      Get.snackbar(
        'अर्ज दाखल',
        'तुमचा रजा अर्ज यशस्वीपणे दाखल झाला आहे!',
        backgroundColor: Colors.green.shade700,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('त्रुटी', 'अर्ज पाठवता आला नाही: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('रजा व्यवस्थापन'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leave Balances card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('रजा शिल्लक (Leave Balance)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _BalanceItem('Casual (CL)', '8/12', Colors.blue),
                      _BalanceItem('Sick (SL)', '10/12', Colors.orange),
                      _BalanceItem('Earned (EL)', '14/15', Colors.green),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Apply leave card
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
                  const Text('नवीन रजा अर्ज',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 14),

                  // Leave Type Selector
                  DropdownButtonFormField<String>(
                    initialValue: _leaveType,
                    decoration: InputDecoration(
                      labelText: 'रजेचा प्रकार',
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),

                    items: const [
                      DropdownMenuItem(value: 'CASUAL', child: Text('किरकोळ रजा (Casual Leave)')),
                      DropdownMenuItem(value: 'SICK', child: Text('वैद्यकीय रजा (Sick Leave)')),
                      DropdownMenuItem(value: 'EARNED', child: Text('हक्काची रजा (Earned Leave)')),
                    ],
                    onChanged: (val) => setState(() => _leaveType = val!),
                  ),

                  const SizedBox(height: 14),

                  // Date range picker row
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final d = await showDatePicker(
                              context: context,
                              initialDate: _fromDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 90)),
                            );
                            if (d != null) {
                              setState(() {
                                _fromDate = d;
                                if (_toDate.isBefore(_fromDate)) _toDate = _fromDate;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('या तारखेपासून', style: TextStyle(fontSize: 11, color: AppColors.subtle)),
                                const SizedBox(height: 4),
                                Text(dateFormat.format(_fromDate), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final d = await showDatePicker(
                              context: context,
                              initialDate: _toDate,
                              firstDate: _fromDate,
                              lastDate: DateTime.now().add(const Duration(days: 90)),
                            );
                            if (d != null) setState(() => _toDate = d);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('या तारखेपर्यंत', style: TextStyle(fontSize: 11, color: AppColors.subtle)),
                                const SizedBox(height: 4),
                                Text(dateFormat.format(_toDate), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Reason text field
                  TextField(
                    controller: _reasonController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'रजेचे कारण लिहा...',
                      hintStyle: const TextStyle(fontFamily: 'NotoSansDevanagari', color: AppColors.subtle, fontSize: 13),
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),

                  const SizedBox(height: 16),

                  FilledButton(
                    onPressed: _isLoading ? null : _applyLeave,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        : const Text('रजेसाठी अर्ज करा', style: TextStyle(fontFamily: 'NotoSansDevanagari', fontSize: 15)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Past Leaves List
            const Text('मागील अर्ज (Leave History)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),

            _myLeaves.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(24),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Center(
                      child: Text('कोणताही रजा अर्ज नाही', style: TextStyle(color: AppColors.subtle)),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _myLeaves.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final item = _myLeaves[i];
                      final status = item['status'] as String? ?? 'PENDING';
                      final from = item['from_date'] ?? '';
                      final to = item['to_date'] ?? '';
                      final days = item['days_count'] ?? 1;

                      final (statusLabel, statusColor) = switch (status) {
                        'APPROVED' => ('मंजूर ✓', Colors.green),
                        'REJECTED' => ('नाकारले ✗', Colors.red),
                        _ => ('प्रलंबित ⏳', Colors.orange),
                      };

                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                statusLabel,
                                style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${item['leave_type']} ($days दिवस)',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  const SizedBox(height: 2),
                                  Text('$from ते $to', style: const TextStyle(fontSize: 12, color: AppColors.subtle)),
                                  if (item['reason'] != null)
                                    Text('${item['reason']}',
                                        style: const TextStyle(fontSize: 11, color: AppColors.onSurface),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

class _BalanceItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _BalanceItem(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.subtle)),
      ],
    );
  }
}
