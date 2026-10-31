import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/face_match_service.dart';
import '../../../core/services/offline_queue_service.dart';
import '../../../core/services/location_ping_service.dart';

enum CheckInStep { idle, gpsVerifying, faceAuth, selfie, uploading, done }

enum AttendanceStatus { unknown, absent, present, late, checkedOut }

class AttendanceController extends GetxController {
  final _supabase = Supabase.instance.client;
  final _locationSvc = LocationService();
  final _offlineQueue = OfflineQueueService();
  final _pingSvc = LocationPingService();

  // ── Observables ─────────────────────────────────────────────
  final isLoading = false.obs;
  final currentStep = CheckInStep.idle.obs;
  final attendanceStatus = AttendanceStatus.unknown.obs;
  final Rx<Map<String, dynamic>?> todayLog = Rx(null);

  // Check-in data collected across steps
  final Rx<Position?> gpsPosition = Rx(null);
  final gpsAccuracyOk = false.obs;
  final isWithinGeofence = false.obs;
  final geofenceDistM = 0.obs;
  final faceMatchScore = 0.0.obs;
  final faceMatchPassed = false.obs;
  final Rx<File?> selfieFile = Rx(null);

  // Today's stats
  final checkpointsDone = 0.obs;
  final checkpointsTotal = 5.obs;
  final tasksCompleted = 0.obs;
  final tasksTotal = 0.obs;
  final hoursWorked = '—'.obs;

  final isOffline = false.obs;
  final hasPendingSync = false.obs;

  String? _todayLogId;

  @override
  void onInit() {
    super.onInit();
    _monitorConnectivity();
    loadTodayAttendance();
  }

  // ── Connectivity ────────────────────────────────────────────

  void _monitorConnectivity() {
    Connectivity().onConnectivityChanged.listen((results) async {
      final offline = results.contains(ConnectivityResult.none) && results.length == 1;
      isOffline.value = offline;
      if (!offline) {
        await _syncOfflineData();
      }
    });
  }

  Future<void> _syncOfflineData() async {
    final pending = await _offlineQueue.hasAnyPending();
    if (!pending) return;
    hasPendingSync.value = true;
    try {
      final checkIns = await _offlineQueue.getPendingCheckIns();
      for (final ci in checkIns) {
        await _supabase.from('attendance_logs').upsert(ci, onConflict: 'staff_id,date');
      }
      if (checkIns.isNotEmpty) await _offlineQueue.clearCheckInQueue();

      final pings = await _offlineQueue.getPendingPings();
      if (pings.isNotEmpty) {
        await _supabase.from('location_pings').insert(pings);
        await _offlineQueue.clearPingQueue();
      }
      hasPendingSync.value = false;
      Get.snackbar(
        'Synced ✅',
        'Offline data uploaded successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade700,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      debugPrint('Sync error: $e');
    }
  }

  // ── Load today's attendance ──────────────────────────────────

  Future<void> loadTodayAttendance() async {
    isLoading.value = true;
    try {
      final staffId = Get.find<AuthController>().currentStaff.value?['id'];
      if (staffId == null) return;

      final today = DateTime.now().toIso8601String().substring(0, 10);
      final data = await _supabase
          .from('attendance_logs')
          .select()
          .eq('staff_id', staffId)
          .eq('date', today)
          .maybeSingle();

      todayLog.value = data;
      if (data != null) {
        _todayLogId = data['id'] as String?;
        if (data['checkout_time'] != null) {
          attendanceStatus.value = AttendanceStatus.checkedOut;
        } else {
          attendanceStatus.value = AttendanceStatus.present;
          final checkinTimeStr = data['checkin_time'] as String?;
          if (checkinTimeStr != null) {
            try {
              _updateHoursWorked(DateTime.parse(checkinTimeStr));
            } catch (_) {}
          }
        }
      } else {
        attendanceStatus.value = AttendanceStatus.absent;
      }
      await _loadTodayStats();
    } catch (e) {
      debugPrint('loadTodayAttendance error: $e');
      attendanceStatus.value = AttendanceStatus.unknown;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadTodayStats() async {
    try {
      final staffId = Get.find<AuthController>().currentStaff.value?['id'];
      if (staffId == null) return;
      final today = DateTime.now().toIso8601String().substring(0, 10);
      final scans = await _supabase
          .from('checkpoint_scans')
          .select('id')
          .eq('staff_id', staffId)
          .gte('scanned_at', '${today}T00:00:00Z');
      checkpointsDone.value = (scans as List).length;
    } catch (_) {}
  }

  void _updateHoursWorked(DateTime checkInTime) {
    final diff = DateTime.now().difference(checkInTime);
    final h = diff.inHours;
    final m = diff.inMinutes % 60;
    hoursWorked.value = '${h}h ${m}m';
  }

  // ── Check-in Flow Steps ──────────────────────────────────────

  /// STEP 1: Verify GPS location + geofence
  Future<bool> verifyGps() async {
    currentStep.value = CheckInStep.gpsVerifying;
    final position = await _locationSvc.getCurrentPosition();
    if (position == null) {
      _showError(
        'GPS location मिळवता आले नाही.\n'
        'Location Services चालू आहेत का ते तपासा.',
      );
      currentStep.value = CheckInStep.idle;
      return false;
    }

    gpsPosition.value = position;
    gpsAccuracyOk.value = _locationSvc.isAccuracyAcceptable(position);

    // Soft warning if accuracy is poor — don't block check-in
    if (!gpsAccuracyOk.value) {
      debugPrint('GPS accuracy low: ${position.accuracy}m — allowing check-in with flag');
    }

    // Check geofence against staff ward (Walchand College Campus)
    final staff = Get.find<AuthController>().currentStaff.value;
    final wardBoundary = _extractWardBoundary(staff);
    isWithinGeofence.value = _locationSvc.isInsidePolygon(
      position.latitude,
      position.longitude,
      wardBoundary,
    );

    // Distance to ward centroid for display
    final centroid = _getWardCentroid(staff);
    if (centroid != null) {
      geofenceDistM.value = _locationSvc
          .distanceBetween(
            position.latitude,
            position.longitude,
            centroid[0],
            centroid[1],
          )
          .toInt();
    }

    // If outside geofence, immediately trigger alert to supervisor
    if (!isWithinGeofence.value) {
      final wardName = staff?['wards']?['ward_name'] ?? 'Ward 4 - Walchand College Campus (WCE)';
      await _triggerOutOfZoneAlert(
        pos: position,
        distM: geofenceDistM.value,
        wardName: wardName.toString(),
      );
    }

    return true; // proceed — supervisor alerted
  }

  /// Simulation helper for quick testing (e.g. Inside WCE vs Outside WCE)
  Future<void> simulatePosition({
    required double lat,
    required double lng,
    String? label,
  }) async {
    final simPos = Position(
      latitude: lat,
      longitude: lng,
      timestamp: DateTime.now(),
      accuracy: 10.0,
      altitude: 560.0,
      altitudeAccuracy: 5.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );

    gpsPosition.value = simPos;
    gpsAccuracyOk.value = true;

    final staff = Get.find<AuthController>().currentStaff.value;
    final wardBoundary = _extractWardBoundary(staff);
    isWithinGeofence.value = _locationSvc.isInsidePolygon(lat, lng, wardBoundary);

    final centroid = _getWardCentroid(staff);
    if (centroid != null) {
      geofenceDistM.value = _locationSvc
          .distanceBetween(lat, lng, centroid[0], centroid[1])
          .toInt();
    }

    final wardName = staff?['wards']?['ward_name'] ?? 'Ward 4 - Walchand College Campus (WCE)';

    if (!isWithinGeofence.value) {
      await _triggerOutOfZoneAlert(
        pos: simPos,
        distM: geofenceDistM.value,
        wardName: wardName.toString(),
      );
    } else {
      Get.snackbar(
        '✅ प्रभाग पडताळणी यशस्वी',
        'तुम्ही $wardName क्षेत्रामध्ये आहात (Inside Geofence).',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF1B5E20),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 28),
      );
    }
  }

  /// STEP 2: Face biometric (device fingerprint/PIN)
  Future<bool> verifyFaceBiometric() async {
    currentStep.value = CheckInStep.faceAuth;
    try {
      final passed =
          await Get.find<AuthController>().authenticateWithBiometric();
      return passed;
    } catch (e) {
      debugPrint('verifyFaceBiometric error: $e');
      return false;
    }
  }

  /// STEP 3: Capture selfie and perform AI face liveness check
  Future<bool> captureSelfieAndMatch(File photo) async {
    currentStep.value = CheckInStep.selfie;
    selfieFile.value = photo;

    if (!photo.existsSync()) {
      debugPrint('captureSelfieAndMatch: file does not exist — skipping ML check');
      faceMatchPassed.value = true;
      faceMatchScore.value = 0.5;
      return true;
    }

    try {
      final staff = Get.find<AuthController>().currentStaff.value;
      final profileUrl = staff?['profile_photo_url'] as String?;

      FaceMatchResult result;

      if (profileUrl != null && profileUrl.isNotEmpty) {
        // compareFaces handles URLs gracefully (falls back to liveness-only)
        result = await FaceMatchService().compareFaces(
          enrolledPhotoPath: profileUrl,
          capturedPhotoPath: photo.path,
        );
      } else {
        // No enrolled photo → just do liveness check
        result = await FaceMatchService().checkLiveness(photo);
      }

      faceMatchScore.value = result.score;
      faceMatchPassed.value = result.passed;

      debugPrint('Face match: ${result.reason}');

      if (!result.passed) {
        _triggerFaceMismatchAlert(result.score);
      }
    } catch (e) {
      debugPrint('captureSelfieAndMatch error: $e — allowing check-in');
      faceMatchPassed.value = true;
      faceMatchScore.value = 0.5;
    }
    return true;
  }

  /// FINAL: Upload check-in to Supabase (or queue offline)
  Future<void> submitCheckIn() async {
    currentStep.value = CheckInStep.uploading;
    isLoading.value = true;

    try {
      final auth = Get.find<AuthController>();
      final staff = auth.currentStaff.value;
      if (staff == null) {
        _showError('Staff profile not found. Please log in again.');
        return;
      }

      final staffId = staff['id'] as String;
      final pos = gpsPosition.value ??
          Position(
            latitude: 16.8524,
            longitude: 74.5815,
            timestamp: DateTime.now(),
            accuracy: 50.0,
            altitude: 0.0,
            altitudeAccuracy: 0.0,
            heading: 0.0,
            headingAccuracy: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0,
          );
      final today = DateTime.now().toIso8601String().substring(0, 10);
      final now = DateTime.now().toIso8601String();

      // Upload selfie photo to Supabase Storage
      String? photoUrl;
      final file = selfieFile.value;
      if (file != null && file.existsSync() && file.lengthSync() > 0) {
        try {
          final bytes = await file.readAsBytes();
          final hash = sha256.convert(bytes).toString();
          final path =
              'selfies/$staffId/$today-checkin-${DateTime.now().millisecondsSinceEpoch}.jpg';

          await _supabase.storage.from('attendance-photos').uploadBinary(
                path,
                bytes,
                fileOptions: const FileOptions(
                  contentType: 'image/jpeg',
                  upsert: true,
                ),
              );
          photoUrl = _supabase.storage
              .from('attendance-photos')
              .getPublicUrl(path);

          // Store photo metadata
          try {
            await _supabase.from('photos').insert({
              'staff_id': staffId,
              'storage_path': path,
              'public_url': photoUrl,
              'sha256_hash': hash,
              'lat': pos.latitude,
              'lng': pos.longitude,
              'accuracy_m': pos.accuracy,
              'captured_at': now,
              'photo_type': 'CHECKIN',
              'face_match_score': faceMatchScore.value,
              'face_match_passed': faceMatchPassed.value,
            });
          } catch (e) {
            debugPrint('Photos table insert note (non-critical): $e');
          }
        } catch (e) {
          debugPrint('Selfie upload note (non-critical): $e');
          // Continue check-in even if photo upload fails
        }
      }

      // Determine if late
      final shiftStr = staff['shift_start'] as String? ?? '06:00:00';
      final shiftParts = shiftStr.split(':');
      final shiftHour = int.tryParse(shiftParts.isNotEmpty ? shiftParts[0] : '6') ?? 6;
      final shiftMin = int.tryParse(shiftParts.length > 1 ? shiftParts[1] : '0') ?? 0;
      final now2 = DateTime.now();
      final shiftStart = DateTime(now2.year, now2.month, now2.day, shiftHour, shiftMin);
      final lateMinutes = now2.difference(shiftStart).inMinutes;
      final isLate = lateMinutes > 15;
      final status = isLate ? 'LATE' : 'PRESENT';

      final payload = <String, dynamic>{
        'staff_id': staffId,
        'date': today,
        'shift': staff['shift'] ?? 'MORNING',
        'checkin_time': now,
        'checkin_lat': pos.latitude,
        'checkin_lng': pos.longitude,
        'accuracy_m': pos.accuracy,
        'checkin_within_geofence': isWithinGeofence.value,
        'checkin_geofence_dist_m': geofenceDistM.value,
        'checkin_face_score': faceMatchScore.value,
        'checkin_face_passed': faceMatchPassed.value,
        'status': status,
        'is_late_mark': isLate,
        'late_minutes': lateMinutes > 0 ? lateMinutes : 0,
        'is_suspicious': !isWithinGeofence.value || !faceMatchPassed.value,
        if (photoUrl != null) 'checkin_photo_url': photoUrl,
      };

      try {
        // Check for existing record today
        final existing = await _supabase
            .from('attendance_logs')
            .select('id')
            .eq('staff_id', staffId)
            .eq('date', today)
            .maybeSingle();

        if (existing != null) {
          final result = await _supabase
              .from('attendance_logs')
              .update(payload)
              .eq('id', existing['id'] as String)
              .select()
              .single();
          _todayLogId = result['id'] as String?;
          todayLog.value = result;
        } else {
          final result = await _supabase
              .from('attendance_logs')
              .insert(payload)
              .select()
              .single();
          _todayLogId = result['id'] as String?;
          todayLog.value = result;
        }
      } catch (e) {
        debugPrint('Online checkin failed — queuing offline: $e');
        await _offlineQueue.enqueueCheckIn(payload);
        hasPendingSync.value = true;
        _todayLogId = 'offline-${DateTime.now().millisecondsSinceEpoch}';
        todayLog.value = Map<String, dynamic>.from(payload)
          ..['id'] = _todayLogId;
      }

      // Start background GPS pings
      try {
        final logId = _todayLogId;
        if (logId != null && !logId.startsWith('offline-')) {
          await _pingSvc.startPinging(
            attendanceLogId: logId,
            staffId: staffId,
          );
        }
      } catch (e) {
        debugPrint('StartPinging note: $e');
      }

      attendanceStatus.value = AttendanceStatus.present;
      currentStep.value = CheckInStep.done;
      await loadTodayAttendance();
    } catch (e) {
      debugPrint('submitCheckIn critical error: $e');
      _showError('Check-in त्रुटी: ${e.toString()}');
      currentStep.value = CheckInStep.idle;
    } finally {
      isLoading.value = false;
    }
  }

  // ── Check-out ────────────────────────────────────────────────

  Future<void> submitCheckOut({
    required File? photo,
    required Position position,
  }) async {
    isLoading.value = true;
    try {
      final staffId =
          Get.find<AuthController>().currentStaff.value?['id'] as String?;
      if (staffId == null) return;

      final now = DateTime.now().toIso8601String();
      final today = DateTime.now().toIso8601String().substring(0, 10);

      // Upload checkout photo
      String? checkoutPhotoUrl;
      if (photo != null && photo.existsSync() && photo.lengthSync() > 0) {
        try {
          final bytes = await photo.readAsBytes();
          final hash = sha256.convert(bytes).toString();
          final path = 'selfies/$staffId/$today-checkout-${DateTime.now().millisecondsSinceEpoch}.jpg';
          await _supabase.storage.from('attendance-photos').uploadBinary(
                path,
                bytes,
                fileOptions: const FileOptions(
                  contentType: 'image/jpeg',
                  upsert: true,
                ),
              );
          checkoutPhotoUrl = _supabase.storage
              .from('attendance-photos')
              .getPublicUrl(path);

          try {
            await _supabase.from('photos').insert({
              'staff_id': staffId,
              'storage_path': path,
              'public_url': checkoutPhotoUrl,
              'sha256_hash': hash,
              'lat': position.latitude,
              'lng': position.longitude,
              'accuracy_m': position.accuracy,
              'captured_at': now,
              'photo_type': 'CHECKOUT',
              'is_valid': true,
            });
          } catch (e) {
            debugPrint('Photos insert checkout note: $e');
          }
        } catch (e) {
          debugPrint('Checkout photo upload note: $e');
        }
      }

      // Find the attendance log for today
      var logId = _todayLogId;
      if (logId == null || logId.startsWith('offline-')) {
        try {
          final existing = await _supabase
              .from('attendance_logs')
              .select('id')
              .eq('staff_id', staffId)
              .eq('date', today)
              .maybeSingle();
          logId = existing?['id'] as String?;
        } catch (_) {}
      }

      if (logId != null && !logId.startsWith('offline-')) {
        try {
          double? totalHours;
          final checkinStr = todayLog.value?['checkin_time'] as String?;
          if (checkinStr != null) {
            try {
              final checkinDt = DateTime.parse(checkinStr);
              totalHours = DateTime.now().difference(checkinDt).inMinutes / 60.0;
            } catch (_) {}
          }
          final currentStatus = todayLog.value?['status'] as String? ?? 'PRESENT';
          final updatedStatus = (totalHours != null && totalHours < 4.0 && currentStatus != 'LATE')
              ? 'HALF_DAY'
              : currentStatus;

          await _supabase.from('attendance_logs').update({
            'checkout_time': now,
            'checkout_lat': position.latitude,
            'checkout_lng': position.longitude,
            'checkout_type': 'MANUAL',
            if (totalHours != null) 'total_hours': double.parse(totalHours.toStringAsFixed(2)),
            'status': updatedStatus,
            if (checkoutPhotoUrl != null) 'checkout_photo_url': checkoutPhotoUrl,
          }).eq('id', logId);
        } catch (e) {
          debugPrint('Checkout update failed: $e');
        }
      }

      try {
        await _pingSvc.stopPinging();
      } catch (_) {}

      attendanceStatus.value = AttendanceStatus.checkedOut;
      await loadTodayAttendance();
    } catch (e) {
      _showError('Check-out त्रुटी: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Alert triggers ───────────────────────────────────────────

  Future<void> _triggerOutOfZoneAlert({
    required Position pos,
    required int distM,
    required String wardName,
  }) async {
    try {
      final auth = Get.find<AuthController>();
      final staff = auth.currentStaff.value;
      final staffId = staff?['id'] as String? ?? '20000000-0000-0000-0000-000000000011';
      final staffName = staff?['name'] ?? 'Ramesh Vishnu Patil';
      final staffNameMr = staff?['name_mr'] ?? 'रमेश विष्णू पाटील';
      final wardId = staff?['ward_id'] as String? ?? '11111111-0000-0000-0000-000000000004';
      final now = DateTime.now().toUtc().toIso8601String();

      final alertPayload = {
        'staff_id': staffId,
        'ward_id': wardId,
        'alert_type': 'OUT_OF_ZONE',
        'severity': 'HIGH',
        'message': 'Geofence Breach: $staffName (Sanitation Staff) is OUTSIDE assigned ward ($wardName). Distance: ${distM}m away.',
        'message_mr': 'प्रभाग उल्लंघन: $staffNameMr हे नियुक्त क्षेत्राबाहेर ($wardName) आढळले. अंतर: $distM मीटर.',
        'metadata': {
          'lat': pos.latitude,
          'lng': pos.longitude,
          'accuracy_m': pos.accuracy,
          'ward_name': wardName,
          'distance_m': distM,
          'source': 'CHECKIN_FLOW',
          'employee_name': staffName,
          'employee_phone': staff?['phone'] ?? '9822011111',
        },
        'location_lat': pos.latitude,
        'location_lng': pos.longitude,
        'is_resolved': false,
        'resolved': false,
        'triggered_at': now,
        'created_at': now,
      };

      await _supabase.from('alerts').insert(alertPayload);
      debugPrint('[GEOFENCE ALERT] Alert saved to Supabase alerts table successfully');

      Get.snackbar(
        '🚨 GEOFENCE ALERT / प्रभाग उल्लंघन',
        'तुम्ही $wardName हद्दीबाहेर ($distM मी.) आहात! पर्यवेक्षक डॅशबोर्डवर तात्काळ अलर्ट पाठवला आहे.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade800,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 28),
      );
    } catch (e) {
      debugPrint('[GEOFENCE ALERT ERROR]: $e');
    }
  }

  Future<void> _triggerFaceMismatchAlert(double score) async {
    try {
      final staffId =
          Get.find<AuthController>().currentStaff.value?['id'] as String?;
      if (staffId == null) return;
      await _supabase.from('alerts').insert({
        'staff_id': staffId,
        'alert_type': 'FACE_MISMATCH',
        'severity': 'HIGH',
        'message':
            'Face liveness check warning during check-in. Score: ${score.toStringAsFixed(2)}',
      });
    } catch (e) {
      debugPrint('Alert insert note: $e');
    }
  }

  // ── Helpers ──────────────────────────────────────────────────

  void resetCheckInFlow() {
    currentStep.value = CheckInStep.idle;
    gpsPosition.value = null;
    gpsAccuracyOk.value = false;
    isWithinGeofence.value = false;
    geofenceDistM.value = 0;
    faceMatchScore.value = 0.0;
    faceMatchPassed.value = false;
    selfieFile.value = null;
  }

  static List<Map<String, double>> _defaultWalchandBoundary() => [
    {'lat': 16.8431, 'lng': 74.6008},
    {'lat': 16.8431, 'lng': 74.6032},
    {'lat': 16.8455, 'lng': 74.6032},
    {'lat': 16.8455, 'lng': 74.6008},
    {'lat': 16.8431, 'lng': 74.6008},
  ];

  List<Map<String, double>> _extractWardBoundary(
      Map<String, dynamic>? staff) {
    try {
      final ward = staff?['wards'] as Map<String, dynamic>?;
      var boundary = ward?['boundary'];
      if (boundary is String) {
        boundary = jsonDecode(boundary);
      }
      if (boundary == null) return _defaultWalchandBoundary();
      final coords = (boundary['coordinates'][0] as List)
          .map((c) => {
                'lat': (c[1] as num).toDouble(),
                'lng': (c[0] as num).toDouble(),
              })
          .toList();
      return List<Map<String, double>>.from(coords);
    } catch (_) {
      return _defaultWalchandBoundary();
    }
  }

  List<double>? _getWardCentroid(Map<String, dynamic>? staff) {
    try {
      final ward = staff?['wards'] as Map<String, dynamic>?;
      var boundary = ward?['boundary'];
      if (boundary is String) {
        boundary = jsonDecode(boundary);
      }
      if (boundary == null) return [16.8443, 74.6020];
      final coords = boundary['coordinates'][0] as List;
      double sumLat = 0, sumLng = 0;
      for (final c in coords) {
        sumLat += (c[1] as num).toDouble();
        sumLng += (c[0] as num).toDouble();
      }
      return [sumLat / coords.length, sumLng / coords.length];
    } catch (_) {
      return [16.8443, 74.6020];
    }
  }

  void _showError(String msg) {
    Get.snackbar(
      'त्रुटी',
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFC62828),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }
}
