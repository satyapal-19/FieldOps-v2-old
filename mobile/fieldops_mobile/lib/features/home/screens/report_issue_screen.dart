import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/controllers/navigation_controller.dart';
import '../../attendance/controllers/attendance_controller.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _descController = TextEditingController();
  final _picker = ImagePicker();
  final _auth = Get.find<AuthController>();
  final _attendance = Get.find<AttendanceController>();
  final _supabase = Supabase.instance.client;

  File? _imageFile;
  String _selectedCategory = 'GARBAGE';
  bool _isSubmitting = false;
  Position? _currentPos;

  final List<Map<String, dynamic>> _categories = [
    {'id': 'GARBAGE', 'label': 'कचरा / Garbage', 'icon': Icons.delete_outline, 'color': Colors.orange},
    {'id': 'DRAIN', 'label': 'सांडपाणी / Drain', 'icon': Icons.water_damage_outlined, 'color': Colors.blue},
    {'id': 'ROAD', 'label': 'रस्ता / Pothole', 'icon': Icons.add_road, 'color': Colors.brown},
    {'id': 'WATER', 'label': 'पाणी गळती / Leak', 'icon': Icons.water_drop_outlined, 'color': Colors.teal},
    {'id': 'LIGHT', 'label': 'पथदिवा / Light', 'icon': Icons.lightbulb_outline, 'color': Colors.amber},
    {'id': 'OTHER', 'label': 'इतर / Other', 'icon': Icons.more_horiz, 'color': Colors.purple},
  ];

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _fetchLocation() async {
    _currentPos = _attendance.gpsPosition.value;
    if (_currentPos == null) {
      try {
        _currentPos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(timeLimit: Duration(seconds: 5)),
        );
        if (mounted) setState(() {});
      } catch (_) {
        // Fallback Sangli coordinates
        if (mounted) {
          setState(() {
            _currentPos = Position(
              latitude: 16.8524,
              longitude: 74.5815,
              timestamp: DateTime.now(),
              accuracy: 15.0,
              altitude: 0.0,
              altitudeAccuracy: 0.0,
              heading: 0.0,
              headingAccuracy: 0.0,
              speed: 0.0,
              speedAccuracy: 0.0,
            );
          });
        }
      }
    }
  }

  Future<void> _takeLiveCameraPhoto() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        imageQuality: 80,
      );
      if (picked != null && mounted) {
        setState(() => _imageFile = File(picked.path));
      }
    } catch (e) {
      Get.snackbar('कॅमेरा त्रुटी', 'फोटो घेता आला नाही: $e');
    }
  }

  Future<void> _submitIssue() async {
    if (_descController.text.trim().isEmpty && _imageFile == null) {
      Get.snackbar('माहिती आवश्यक', 'कृपया फोटो किंवा समस्येचे वर्णन द्या',
        backgroundColor: Colors.orange.shade800,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final staffId = _auth.currentStaff.value?['id'];
      final wardId = _auth.currentStaff.value?['ward_id'];
      String photoUrl = '';

      if (_imageFile != null && _imageFile!.existsSync()) {
        try {
          final bytes = await _imageFile!.readAsBytes();
          final fileName = 'issues/${DateTime.now().millisecondsSinceEpoch}.jpg';
          await _supabase.storage.from('attendance-photos').uploadBinary(
            fileName,
            bytes,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: true,
            ),
          );
          photoUrl = _supabase.storage.from('attendance-photos').getPublicUrl(fileName);
        } catch (e) {
          debugPrint('Report issue photo upload note: $e');
        }
      }

      final pos = _currentPos ?? _attendance.gpsPosition.value;
      final lat = pos?.latitude ?? 16.8524;
      final lng = pos?.longitude ?? 74.5815;

      // 1. Create alert for supervisor
      try {
        await _supabase.from('alerts').insert({
          'staff_id': staffId,
          'ward_id': wardId,
          'alert_type': 'BEAT_DEVIATION',
          'severity': 'MEDIUM',
          'message': '[$_selectedCategory] ${_descController.text.trim()}',
          'message_mr': '[$_selectedCategory] ${_descController.text.trim()}',
          'metadata': {
            'category': _selectedCategory,
            'lat': lat,
            'lng': lng,
            'photo_url': photoUrl,
          },
        });
      } catch (e) {
        debugPrint('Alert insert note: $e');
      }

      // 2. Also create a citizen/field complaint record (This acts as the Problem Beacon on Beat Map!)
      await _supabase.from('citizen_complaints').insert({
        'tracking_id': 'SMK-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        'name': _auth.staffNameMr.isNotEmpty ? _auth.staffNameMr : _auth.staffName,
        'phone': _auth.currentStaff.value?['phone'] ?? '',
        'ward_id': wardId,
        'category': _selectedCategory,
        'description': _descController.text.trim().isEmpty ? '$_selectedCategory Reported' : _descController.text.trim(),
        'photo_url': photoUrl,
        'lat': lat,
        'lng': lng,
        'status': 'RECEIVED',
      });

      if (!mounted) return;

      // Show success dialog safely without double Get.back() race condition
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogCtx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.primary, size: 28),
              SizedBox(width: 8),
              Text('तक्रार नोंदवली ✓', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'समस्या यशस्वीपणे नोंदवली गेली असून नकाशावर बीकन (Beacon) तयार करण्यात आला आहे.',
                style: TextStyle(fontFamily: 'NotoSansDevanagari', height: 1.3),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.share_location, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'स्थान: ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}\nनकाशावरून काम नंतर पूर्ण करता येईल.',
                        style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogCtx).pop(); // close dialog
                if (mounted) Navigator.of(context).pop(); // return to home safely
              },
              child: const Text('पूर्ण करा (Done)'),
            ),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(dialogCtx).pop(); // close dialog
                if (mounted) Navigator.of(context).pop(); // close screen
                Get.find<NavigationController>().navigateTo(1); // Jump straight to Beat Map tab!
              },
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              icon: const Icon(Icons.map, size: 16),
              label: const Text('नकाशावर बीकन पहा'),
            ),
          ],
        ),
      );
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'तक्रार नोंदवता आली नाही: $e',
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('report_issue'.tr),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category selector title
            const Text(
              'समस्येचा प्रकार निवडा',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface),
            ),
            const SizedBox(height: 10),

            // Grid of categories
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.1,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, i) {
                final cat = _categories[i];
                final isSelected = _selectedCategory == cat['id'];
                final color = cat['color'] as Color;

                return InkWell(
                  onTap: () => setState(() => _selectedCategory = cat['id'] as String),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? color.withValues(alpha: 0.15) : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? color : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(cat['icon'] as IconData, color: isSelected ? color : AppColors.subtle, size: 24),
                        const SizedBox(height: 4),
                        Text(
                          cat['label'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? color : AppColors.onSurface,
                            fontFamily: 'NotoSansDevanagari',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Live Camera Photo picker (No gallery)
            const Row(
              children: [
                Icon(Icons.camera_alt, size: 16, color: AppColors.primary),
                SizedBox(width: 6),
                Text(
                  'समस्येचा फोटो (थेट कॅमेरा पुरावा)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'camera_only_note'.tr,
              style: const TextStyle(fontSize: 11, color: AppColors.subtle),
            ),
            const SizedBox(height: 10),

            _imageFile != null
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(_imageFile!, height: 180, width: double.infinity, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => setState(() => _imageFile = null),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                            child: const Icon(Icons.close, color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    height: 110,
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Center(
                      child: FilledButton.icon(
                        onPressed: _takeLiveCameraPhoto,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          minimumSize: const Size(200, 46),
                        ),
                        icon: const Icon(Icons.camera_alt),
                        label: Text('take_photo'.tr),
                      ),
                    ),
                  ),

            const SizedBox(height: 20),

            // Description
            const Text(
              'तपशील / वर्णन',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'समस्येचे ठिकाण, स्वरूप आणि इतर माहिती लिहा...',
                hintStyle: const TextStyle(fontFamily: 'NotoSansDevanagari', color: AppColors.subtle, fontSize: 13),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),

            const SizedBox(height: 16),

            // Location preview & Beacon indication
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryTonal),
              ),
              child: Row(
                children: [
                  const Icon(Icons.share_location, color: AppColors.primary, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentPos != null
                              ? 'GPS: ${_currentPos!.latitude.toStringAsFixed(4)}, ${_currentPos!.longitude.toStringAsFixed(4)}'
                              : 'GPS लोकेशन शोधत आहे...',
                          style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'ही जागा नकाशावर बीकन म्हणून नोंदवली जाईल',
                          style: TextStyle(fontSize: 11, color: Color(0xFF2E7D32)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Submit Button
            FilledButton.icon(
              onPressed: _isSubmitting ? null : _submitIssue,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.send),
              label: Text(
                _isSubmitting ? 'नोंदवत आहे...' : 'तक्रार सबमिट करा (बीकन जोडा)',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'NotoSansDevanagari'),
              ),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
