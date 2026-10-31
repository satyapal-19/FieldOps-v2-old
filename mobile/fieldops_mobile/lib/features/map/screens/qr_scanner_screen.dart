import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../attendance/controllers/attendance_controller.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool _isProcessing = false;
  final _supabase = Supabase.instance.client;
  final _auth = Get.find<AuthController>();
  final _attendance = Get.find<AttendanceController>();

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _handleBarcode(BarcodeCapture capture) async {
    if (_isProcessing) return;
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final code = barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;

    setState(() => _isProcessing = true);

    try {
      final staffId = _auth.currentStaff.value?['id'] ?? '20000000-0000-0000-0000-000000000011';
      final pos = _attendance.gpsPosition.value ?? await Geolocator.getCurrentPosition();
      final logId = _attendance.todayLog.value?['id'];

      // Record checkpoint scan in database
      await _supabase.from('checkpoint_scans').insert({
        'staff_id': staffId,
        if (logId != null && !logId.toString().startsWith('offline-')) 'attendance_log_id': logId,
        'checkpoint_id': code,
        'checkpoint_name': 'Checkpoint $code',
        'lat': pos.latitude,
        'lng': pos.longitude,
        'scanned_at': DateTime.now().toIso8601String(),
      });

      // Increment checkpoints count in attendance controller
      _attendance.checkpointsDone.value += 1;

      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.primary),
              SizedBox(width: 8),
              Text('Checkpoint Scanned', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('चेकपोईंट यशस्वीपणे स्कॅन झाला आहे! ✓',
                  style: TextStyle(fontFamily: 'NotoSansDevanagari', fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text('Code: $code', style: const TextStyle(fontSize: 12, color: AppColors.subtle)),
              Text('Time: ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 12, color: AppColors.subtle)),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Get.back(); // close dialog
                Get.back(); // return to previous screen
              },
              child: const Text('ठीक आहे'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      Get.snackbar(
        'स्कॅन त्रुटी',
        'Checkpoint नोंदवता आले नाही: $e',
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('QR Checkpoint स्कॅन'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: _cameraController,
              builder: (context, state, child) {
                switch (state.torchState) {
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.amber);
                  case TorchState.off:
                  default:
                    return const Icon(Icons.flash_off, color: Colors.white);
                }
              },
            ),

            onPressed: () => _cameraController.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _cameraController,
            onDetect: _handleBarcode,
          ),
          // Scanner viewfinder overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _Corner(topLeft: true),
                      _Corner(topRight: true),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _Corner(bottomLeft: true),
                      _Corner(bottomRight: true),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'SMKMC Checkpoint वरील QR कोड फ्रेममध्ये धरा',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'NotoSansDevanagari',
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade900.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.security, size: 13, color: Colors.greenAccent),
                        SizedBox(width: 5),
                        Text(
                          'थेट स्कॅनिंग आवश्यक (गॅलरी बंद / Live Only)',
                          style: TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }
}

class _Corner extends StatelessWidget {
  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;

  const _Corner({
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.only(
          topLeft: topLeft ? const Radius.circular(12) : Radius.zero,
          topRight: topRight ? const Radius.circular(12) : Radius.zero,
          bottomLeft: bottomLeft ? const Radius.circular(12) : Radius.zero,
          bottomRight: bottomRight ? const Radius.circular(12) : Radius.zero,
        ),
      ),
    );
  }
}
