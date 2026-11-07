import 'package:fieldops_api/fieldops_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/api/api_service.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/notify.dart';

/// Leave requests and attendance corrections (regularization) for myself.
class LeaveScreen extends StatefulWidget {
  const LeaveScreen({super.key});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  final _api = Get.find<ApiService>();
  final _auth = Get.find<AuthController>();
  final _reason = TextEditingController();
  final _df = DateFormat('dd MMM yyyy');

  // One UUID per form, renewed after a success: a retried submit is a no-op.
  String _leaveUuid = const Uuid().v4();
  String _fixUuid = const Uuid().v4();

  CreateLeaveDtoLeaveTypeEnum _leaveType = CreateLeaveDtoLeaveTypeEnum.CASUAL;
  CreateRegularizationDtoReasonTypeEnum _fixReason = CreateRegularizationDtoReasonTypeEnum.OUT_OF_NETWORK;
  DateTime _from = DateTime.now().add(const Duration(days: 1));
  DateTime _to = DateTime.now().add(const Duration(days: 1));
  DateTime _fixDate = DateTime.now().subtract(const Duration(days: 1));
  bool _correction = false;
  bool _sending = false;
  List<LeaveRequestDto> _leaves = [];
  List<RegularizationRequestDto> _fixes = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final leaves = await _api.leave.leaveControllerListLeave(staffId: _auth.staffId, pageSize: 20);
      final fixes = await _api.leave.leaveControllerListRegularizations(staffId: _auth.staffId, pageSize: 20);
      if (!mounted) return;
      setState(() {
        _leaves = leaves.data!.items.toList();
        _fixes = fixes.data!.items.toList();
      });
    } catch (e) {
      Notify.failure(e);
    }
  }

  Future<void> _submit() async {
    final text = _reason.text.trim();
    if (_correction && text.isEmpty) {
      Notify.warn('explanation_required'.tr);
      return;
    }
    setState(() => _sending = true);
    try {
      if (_correction) {
        await _api.leave.leaveControllerRequestRegularization(
          createRegularizationDto: CreateRegularizationDto((b) => b
            ..clientUuid = _fixUuid
            ..attendanceDate = isoDay(_fixDate)
            ..reasonType = _fixReason
            ..explanation = text),
        );
        _fixUuid = const Uuid().v4();
      } else {
        await _api.leave.leaveControllerRequestLeave(
          createLeaveDto: CreateLeaveDto((b) => b
            ..clientUuid = _leaveUuid
            ..leaveType = _leaveType
            ..fromDate = isoDay(_from)
            ..toDate = isoDay(_to)
            ..reason = text.isEmpty ? null : text),
        );
        _leaveUuid = const Uuid().v4();
      }
      _reason.clear();
      Notify.ok('request_sent'.tr);
      await _load();
    } catch (e) {
      Notify.failure(e);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _cancel(LeaveRequestDto l) async {
    try {
      await _api.leave.leaveControllerCancelLeave(
        id: l.id,
        cancelRequestDto: CancelRequestDto((b) => b..expectedVersion = l.version),
      );
      await _load();
    } catch (e) {
      Notify.failure(e);
    }
  }

  Future<DateTime?> _pick(DateTime initial, {bool past = false}) => showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: DateTime.now().subtract(const Duration(days: 31)),
        lastDate: past ? DateTime.now() : DateTime.now().add(const Duration(days: 180)),
      );

  Widget _dateField(String label, DateTime value, ValueChanged<DateTime> onPicked, {bool past = false}) =>
      Expanded(
        child: OutlinedButton(
          onPressed: () async {
            final d = await _pick(value, past: past);
            if (d != null) setState(() => onPicked(d));
          },
          child: Text('$label: ${_df.format(value)}'),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('leave_and_corrections'.tr)),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SegmentedButton<bool>(
              segments: [
                ButtonSegment(value: false, label: Text('leave'.tr)),
                ButtonSegment(value: true, label: Text('correction'.tr)),
              ],
              selected: {_correction},
              onSelectionChanged: (s) => setState(() => _correction = s.first),
            ),
            const SizedBox(height: 16),
            if (!_correction) ...[
              DropdownButtonFormField<CreateLeaveDtoLeaveTypeEnum>(
                initialValue: _leaveType,
                decoration: InputDecoration(labelText: 'leave_type'.tr),
                items: CreateLeaveDtoLeaveTypeEnum.values
                    .map((t) => DropdownMenuItem(value: t, child: Text('leave_${t.name}'.tr)))
                    .toList(),
                onChanged: (t) => setState(() => _leaveType = t ?? _leaveType),
              ),
              const SizedBox(height: 12),
              Row(children: [
                _dateField('from'.tr, _from, (d) {
                  _from = d;
                  if (_to.isBefore(d)) _to = d;
                }),
                const SizedBox(width: 8),
                _dateField('to'.tr, _to, (d) => _to = d.isBefore(_from) ? _from : d),
              ]),
            ] else ...[
              DropdownButtonFormField<CreateRegularizationDtoReasonTypeEnum>(
                initialValue: _fixReason,
                decoration: InputDecoration(labelText: 'correction_reason'.tr),
                items: CreateRegularizationDtoReasonTypeEnum.values
                    .map((t) => DropdownMenuItem(value: t, child: Text('fix_${t.name}'.tr)))
                    .toList(),
                onChanged: (t) => setState(() => _fixReason = t ?? _fixReason),
              ),
              const SizedBox(height: 12),
              Row(children: [_dateField('date'.tr, _fixDate, (d) => _fixDate = d, past: true)]),
            ],
            const SizedBox(height: 12),
            TextField(
              controller: _reason,
              maxLines: 3,
              maxLength: 500,
              decoration: InputDecoration(labelText: _correction ? 'explanation'.tr : 'reason_optional'.tr),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sending ? null : _submit,
                child: _sending
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text('submit'.tr),
              ),
            ),
            const SizedBox(height: 24),
            Text('my_requests'.tr, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 8),
            if (!_correction)
              ..._leaves.map((l) => Card(
                    child: ListTile(
                      title: Text('leave_${l.leaveType.name}'.tr),
                      subtitle: Text(
                          '${_df.format(DateTime.parse(l.fromDate))} – ${_df.format(DateTime.parse(l.toDate))} · ${'request_${l.status.name}'.tr}'),
                      trailing: l.status == LeaveRequestDtoStatusEnum.PENDING
                          ? TextButton(onPressed: () => _cancel(l), child: Text('cancel'.tr))
                          : null,
                    ),
                  ))
            else
              ..._fixes.map((r) => Card(
                    child: ListTile(
                      title: Text('fix_${r.reasonType.name}'.tr),
                      subtitle: Text(
                          '${_df.format(DateTime.parse(r.attendanceDate))} · ${'request_${r.status.name}'.tr}'),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
