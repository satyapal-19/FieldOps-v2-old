import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../../../core/api/api_failure.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/services/face_liveness.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/attendance_controller.dart';

/// Check-in / check-out: 1 location, 2 face (server challenge + liveness),
/// 3 result. The server's answer is the only verdict shown.
class CheckInFlowScreen extends StatefulWidget {
  final bool isCheckOut;
  const CheckInFlowScreen({super.key, this.isCheckOut = false});

  @override
  State<CheckInFlowScreen> createState() => _CheckInFlowScreenState();
}

class _CheckInFlowScreenState extends State<CheckInFlowScreen> {
  final _ctrl = Get.find<AttendanceController>();

  CameraController? _camera;
  CameraDescription? _cameraDesc;
  FaceDetector? _detector;
  LivenessTracker? _tracker;
  bool _processing = false;
  bool _capturing = false;
  Timer? _expiry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ctrl.resetFlow();
      _start();
    });
  }

  @override
  void dispose() {
    _expiry?.cancel();
    _stopCamera();
    _detector?.close();
    super.dispose();
  }

  Future<void> _start() async {
    if (!await _ctrl.settleGps() || !mounted) return;
    final actions = await _ctrl.startChallenge();
    if (actions == null || !mounted) return;
    _tracker = LivenessTracker(actions);
    final expiresAt = _ctrl.challenge.value!.expiresAt;
    _expiry?.cancel();
    _expiry = Timer(expiresAt.difference(DateTime.now().toUtc()), () {
      if (!_capturing && mounted) {
        _stopCamera();
        _ctrl.failure.value = const ApiFailure(code: 'CHALLENGE_EXPIRED');
        _ctrl.step.value = PunchStep.failed;
      }
    });
    await _startCamera();
  }

  Future<void> _retry() async {
    await _stopCamera();
    _ctrl.resetFlow();
    await _start();
  }

  // ── Camera + liveness ─────────────────────────────────────

  Future<void> _startCamera() async {
    try {
      final cameras = await availableCameras();
      _cameraDesc = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      final cam = CameraController(
        _cameraDesc!,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.nv21,
      );
      await cam.initialize();
      _detector ??= FaceDetector(
        options: FaceDetectorOptions(
          enableClassification: true,
          minFaceSize: 0.25,
          performanceMode: FaceDetectorMode.fast,
        ),
      );
      if (!mounted) return cam.dispose();
      setState(() => _camera = cam);
      await cam.startImageStream(_onFrame);
    } catch (e) {
      debugPrint('Camera: $e');
      _ctrl.failure.value = const ApiFailure(code: ApiCodes.cameraUnavailable);
      _ctrl.step.value = PunchStep.failed;
    }
  }

  Future<void> _stopCamera() async {
    final cam = _camera;
    _camera = null;
    if (cam == null) return;
    try {
      if (cam.value.isStreamingImages) await cam.stopImageStream();
    } catch (_) {}
    await cam.dispose();
  }

  InputImage? _toInputImage(CameraImage image) {
    final rotation = InputImageRotationValue.fromRawValue(_cameraDesc!.sensorOrientation);
    if (rotation == null || image.planes.isEmpty) return null;
    final plane = image.planes.first;
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: InputImageFormat.nv21,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  static FaceSample _sample(List<Face> faces) {
    if (faces.length != 1) return FaceSample(faceCount: faces.length);
    final f = faces.first;
    return FaceSample(
      faceCount: 1,
      leftEyeOpen: f.leftEyeOpenProbability,
      rightEyeOpen: f.rightEyeOpenProbability,
      smiling: f.smilingProbability,
      yaw: f.headEulerAngleY,
    );
  }

  Future<void> _onFrame(CameraImage image) async {
    final tracker = _tracker;
    if (_processing || _capturing || tracker == null) return;
    _processing = true;
    try {
      final input = _toInputImage(image);
      if (input == null) return;
      final sample = _sample(await _detector!.processImage(input));
      final before = tracker.completed;
      tracker.add(sample);
      if (tracker.completed != before && mounted) setState(() {});
      if (tracker.readyForCapture(sample)) await _capture();
    } catch (e) {
      debugPrint('Frame: $e');
    } finally {
      _processing = false;
    }
  }

  Future<void> _capture() async {
    final cam = _camera;
    if (cam == null || _capturing) return;
    setState(() => _capturing = true);
    try {
      await cam.stopImageStream();
      final photo = await cam.takePicture();
      final faces = await _detector!.processImage(InputImage.fromFilePath(photo.path));
      if (faces.length != 1) throw StateError('faces: ${faces.length}');
      final r = faces.first.boundingBox;
      final bytes = await photo.readAsBytes();
      final crop = await compute(_cropFace, _CropJob(bytes, FaceBox(r.left, r.top, r.width, r.height)));
      if (crop == null) throw StateError('crop too large');
      _expiry?.cancel();
      await _stopCamera();
      await _ctrl.submitPunch(checkOut: widget.isCheckOut, faceJpeg: crop);
    } catch (e) {
      debugPrint('Capture: $e');
      await _stopCamera();
      _ctrl.failure.value = const ApiFailure(code: ApiCodes.faceCaptureFailed);
      _ctrl.step.value = PunchStep.failed;
    } finally {
      if (mounted) setState(() => _capturing = false);
    }
  }

  // ── UI ────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.isCheckOut ? 'check_out'.tr : 'check_in'.tr),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            _ctrl.resetFlow();
            Get.back();
          },
        ),
      ),
      body: Obx(() {
        final step = _ctrl.step.value;
        return Column(
          children: [
            _StepIndicator(step: step),
            Expanded(
              child: switch (step) {
                PunchStep.idle || PunchStep.locating => _LocationPage(ctrl: _ctrl),
                PunchStep.face => _FacePage(
                    camera: _camera,
                    tracker: _tracker,
                    capturing: _capturing,
                  ),
                PunchStep.sending => _Busy(text: 'punch_sending'.tr),
                PunchStep.done => _ResultPage(
                    ctrl: _ctrl,
                    isCheckOut: widget.isCheckOut,
                    onDone: () {
                      _ctrl.loadToday();
                      Get.back();
                    },
                  ),
                PunchStep.failed => _FailurePage(ctrl: _ctrl, onRetry: _retry),
              },
            ),
          ],
        );
      }),
    );
  }
}

class _CropJob {
  final Uint8List photo;
  final FaceBox box;
  const _CropJob(this.photo, this.box);
}

Uint8List? _cropFace(_CropJob job) => FaceCrop.fromJpeg(job.photo, job.box);

class _StepIndicator extends StatelessWidget {
  final PunchStep step;
  const _StepIndicator({required this.step});

  int get _index => switch (step) {
        PunchStep.idle || PunchStep.locating => 0,
        PunchStep.face => 1,
        _ => 2,
      };

  @override
  Widget build(BuildContext context) {
    final labels = ['step_location'.tr, 'step_face'.tr, 'step_result'.tr];
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        children: List.generate(labels.length * 2 - 1, (i) {
          final s = i ~/ 2;
          if (i.isOdd) {
            return Expanded(
              child: Container(height: 2, color: s < _index ? AppColors.primary : AppColors.border),
            );
          }
          final active = s == _index, done = s < _index;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: done
                    ? AppColors.primary
                    : (active ? AppColors.primarySurface : AppColors.surface),
                child: done
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : Text('${s + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: active ? AppColors.primary : AppColors.subtle,
                        )),
              ),
              const SizedBox(height: 4),
              Text(labels[s],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: (active || done) ? AppColors.primary : AppColors.subtle,
                  )),
            ],
          );
        }),
      ),
    );
  }
}

class _LocationPage extends StatelessWidget {
  final AttendanceController ctrl;
  const _LocationPage({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Obx(() {
        final pos = ctrl.position.value;
        final limit = ctrl.accuracyLimit.toInt();
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.gps_fixed, size: 72, color: AppColors.primary),
            const SizedBox(height: 16),
            Text('gps_settling'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('gps_needed'.trParams({'m': '$limit'}),
                textAlign: TextAlign.center, style: const TextStyle(color: AppColors.subtle)),
            const SizedBox(height: 24),
            if (pos != null)
              Text('gps_accuracy'.trParams({'m': pos.accuracy.toStringAsFixed(0)}),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: pos.accuracy <= limit ? AppColors.success : AppColors.warning,
                  )),
            const SizedBox(height: 16),
            const LinearProgressIndicator(),
          ],
        );
      }),
    );
  }
}

class _FacePage extends StatelessWidget {
  final CameraController? camera;
  final LivenessTracker? tracker;
  final bool capturing;
  const _FacePage({required this.camera, required this.tracker, required this.capturing});

  static String _prompt(LivenessAction? a) => switch (a) {
        LivenessAction.blink => 'liveness_blink'.tr,
        LivenessAction.smile => 'liveness_smile'.tr,
        LivenessAction.turnLeft => 'liveness_turn_left'.tr,
        LivenessAction.turnRight => 'liveness_turn_right'.tr,
        null => 'liveness_look'.tr,
      };

  @override
  Widget build(BuildContext context) {
    final cam = camera;
    final t = tracker;
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.black),
            child: cam == null || !cam.value.isInitialized
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : CameraPreview(cam),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            children: [
              Text(capturing ? 'liveness_capturing'.tr : _prompt(t?.current),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              if (t != null)
                LinearProgressIndicator(
                  value: t.actions.isEmpty ? 1 : t.completed / t.actions.length,
                  minHeight: 6,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Busy extends StatelessWidget {
  final String text;
  const _Busy({required this.text});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(text, style: const TextStyle(fontSize: 16)),
        ]),
      );
}

class _ResultPage extends StatelessWidget {
  final AttendanceController ctrl;
  final bool isCheckOut;
  final VoidCallback onDone;
  const _ResultPage({required this.ctrl, required this.isCheckOut, required this.onDone});

  @override
  Widget build(BuildContext context) {
    final log = ctrl.result.value?.attendance;
    final punch = isCheckOut ? log?.checkout : log?.checkin;
    final local = punch?.at.toLocal();
    final time = local == null
        ? '—'
        : '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, size: 88, color: AppColors.success),
          const SizedBox(height: 16),
          Text(isCheckOut ? 'checkout_done'.tr : 'checkin_done'.tr,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 24),
          _InfoRow(label: 'time'.tr, value: time),
          if (log != null) _InfoRow(label: 'status'.tr, value: 'status_${log.status.name}'.tr),
          if (log != null && log.isLate)
            _InfoRow(label: 'late_by'.tr, value: '${log.lateMinutes} ${'minutes'.tr}'),
          if (punch?.inGeofence == false)
            _InfoRow(label: 'step_location'.tr, value: 'outside_ward_recorded'.tr),
          if (log != null && log.isSuspicious)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text('flagged_for_review'.tr,
                  textAlign: TextAlign.center, style: const TextStyle(color: AppColors.warning)),
            ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: onDone, child: Text('done'.tr)),
          ),
        ],
      ),
    );
  }
}

class _FailurePage extends StatelessWidget {
  final AttendanceController ctrl;
  final VoidCallback onRetry;
  const _FailurePage({required this.ctrl, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final lang = AuthController.lang;
    final message = ctrl.aadhaarRequired.value
        ? 'aadhaar_not_in_build'.tr
        : (ctrl.failure.value ?? const ApiFailure(code: ApiCodes.unknown)).message(lang);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: AppColors.error),
          const SizedBox(height: 16),
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 32),
          if (!ctrl.aadhaarRequired.value)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text('retry'.tr),
              ),
            ),
          TextButton(onPressed: () => Get.back(), child: Text('close'.tr)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: AppColors.subtle)),
            Flexible(
              child: Text(value,
                  textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      );
}
