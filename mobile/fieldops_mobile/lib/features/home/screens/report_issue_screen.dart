import 'package:fieldops_api/fieldops_api.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../core/api/api_service.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/notify.dart';

/// Staff report a civic problem they see on their round through the same
/// public complaint endpoint citizens use; the ward office turns it into a task.
class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _auth = Get.find<AuthController>();
  final _description = TextEditingController();
  SubmitComplaintDtoCategoryEnum _category = SubmitComplaintDtoCategoryEnum.GARBAGE;
  Position? _pos;
  bool _locating = false;
  bool _sending = false;
  String _uuid = const Uuid().v4();
  String? _trackingId;

  @override
  void initState() {
    super.initState();
    _locate();
  }

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  Future<void> _locate() async {
    setState(() => _locating = true);
    try {
      _pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 20)),
      );
    } catch (_) {
      _pos = await Geolocator.getLastKnownPosition();
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _submit() async {
    final text = _description.text.trim();
    if (text.length < 10) {
      Notify.warn('describe_problem'.tr);
      return;
    }
    setState(() => _sending = true);
    try {
      final res = await Get.find<ApiService>().public.publicComplaintsControllerSubmit(
        submitComplaintDto: SubmitComplaintDto((b) => b
          ..clientUuid = _uuid
          ..category = _category
          ..description = text
          ..citizenName = _auth.staffName
          ..citizenPhone = _auth.phone
          ..wardId = _auth.profile.value?.homeWardId
          ..lat = _pos?.latitude
          ..lng = _pos?.longitude),
      );
      setState(() {
        _trackingId = res.data!.trackingId;
        _uuid = const Uuid().v4();
        _description.clear();
      });
    } catch (e) {
      Notify.failure(e);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('report_issue'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_trackingId != null)
            Card(
              color: AppColors.primarySurface,
              child: ListTile(
                leading: const Icon(Icons.check_circle, color: AppColors.success),
                title: Text('complaint_filed'.tr),
                subtitle: Text('${'tracking_id'.tr}: $_trackingId'),
              ),
            ),
          DropdownButtonFormField<SubmitComplaintDtoCategoryEnum>(
            initialValue: _category,
            decoration: InputDecoration(labelText: 'category'.tr),
            items: SubmitComplaintDtoCategoryEnum.values
                .map((c) => DropdownMenuItem(value: c, child: Text('complaint_${c.name}'.tr)))
                .toList(),
            onChanged: (c) => setState(() => _category = c ?? _category),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _description,
            maxLines: 4,
            maxLength: 1000,
            decoration: InputDecoration(labelText: 'problem_description'.tr),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.place, color: AppColors.primary),
            title: Text(_locating
                ? 'gps_settling'.tr
                : _pos == null
                    ? 'location_unavailable'.tr
                    : '${_pos!.latitude.toStringAsFixed(5)}, ${_pos!.longitude.toStringAsFixed(5)}'),
            trailing: IconButton(icon: const Icon(Icons.refresh), onPressed: _locating ? null : _locate),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _sending ? null : _submit,
            child: _sending
                ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : Text('submit'.tr),
          ),
        ],
      ),
    );
  }
}
