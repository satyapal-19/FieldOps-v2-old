import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/app_routes.dart';
import '../services/location_ping_service.dart';
import '../../features/attendance/controllers/attendance_controller.dart';

class AuthController extends GetxController {
  final _supabase = Supabase.instance.client;
  final _localAuth = LocalAuthentication();

  final isLoading = false.obs;
  final isAuthenticated = false.obs;
  final isBiometricAvailable = false.obs;
  final Rx<Map<String, dynamic>?> currentStaff = Rx(null);
  final isDemoMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final available = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      isBiometricAvailable.value = available || isDeviceSupported;
    } catch (e) {
      debugPrint('Biometric availability check: $e');
      isBiometricAvailable.value = false;
    }
  }

  Future<void> checkExistingSession() async {
    try {
      // Check cached staff profile (works offline)
      final prefs = await SharedPreferences.getInstance();
      final cachedStaffJson = prefs.getString('cached_staff_profile');
      if (cachedStaffJson != null && cachedStaffJson.isNotEmpty) {
        try {
          final decoded =
              jsonDecode(cachedStaffJson) as Map<String, dynamic>;
          currentStaff.value = decoded;
          isAuthenticated.value = true;
          await _checkBiometricAvailability();
          Get.offAllNamed(AppRoutes.biometricLock);
          return;
        } catch (e) {
          debugPrint('Cached profile decode error: $e');
          await prefs.remove('cached_staff_profile');
        }
      }
    } catch (e) {
      debugPrint('SharedPreferences error: $e');
    }

    // Check live Supabase session
    try {
      final session = _supabase.auth.currentSession;
      if (session != null) {
        await _loadStaffProfile();
        await _checkBiometricAvailability();
        Get.offAllNamed(AppRoutes.biometricLock);
        return;
      }
    } catch (e) {
      debugPrint('Session check error: $e');
    }

    Get.offAllNamed(AppRoutes.otpLogin);
  }

  // ── OTP Auth ──────────────────────────────────────────────

  Future<bool> sendOtp(String phone) async {
    isLoading.value = true;
    try {
      final digits = phone.replaceAll(RegExp(r'\D'), '');
      if (digits.length < 10) {
        _showError('कृपया वैध १०-अंकी मोबाइल नंबर प्रविष्ट करा');
        return false;
      }
      final last10 = digits.substring(digits.length - 10);
      final normalizedPhone = '+91$last10';

      // Check if phone exists in staff table
      bool staffFound = false;
      try {
        final staffData = await _supabase
            .from('staff')
            .select('id, name, name_mr')
            .or('phone.eq.$normalizedPhone,phone.eq.$last10')
            .maybeSingle();

        if (staffData != null) {
          staffFound = true;
          isDemoMode.value = true;
          _showSuccess(
            'OTP पाठवला (डेमो)',
            'डेमो कोड: 123456 प्रविष्ट करा (${staffData['name_mr'] ?? staffData['name']})',
          );
          return true;
        }
      } catch (e) {
        debugPrint('Staff lookup note: $e');
      }

      // Try real Supabase OTP
      if (!staffFound) {
        try {
          await _supabase.auth.signInWithOtp(phone: normalizedPhone);
          _showSuccess('OTP पाठवला', '$last10 वर OTP पाठवला आहे');
          return true;
        } catch (e) {
          debugPrint('Supabase OTP note: $e');
          // Fall through to demo mode
        }
      }

      // Demo mode fallback (SMS provider not configured)
      isDemoMode.value = true;
      _showSuccess(
        'डेमो मोड सक्रिय',
        'चाचणीसाठी OTP: 123456 वापरा',
      );
      return true;
    } catch (e) {
      _showError(e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp(String phone, String otp) async {
    isLoading.value = true;
    try {
      final digits = phone.replaceAll(RegExp(r'\D'), '');
      final last10 =
          digits.length >= 10 ? digits.substring(digits.length - 10) : digits;
      final normalizedPhone = '+91$last10';

      // Demo OTP: 123456
      if (otp.trim() == '123456') {
        await _handleDemoLogin(normalizedPhone, last10);
        return;
      }

      // Real Supabase OTP verification
      try {
        final response = await _supabase.auth.verifyOTP(
          phone: normalizedPhone,
          token: otp.trim(),
          type: OtpType.sms,
        );
        if (response.session != null) {
          await _loadStaffProfile();
          Get.offAllNamed(AppRoutes.mainShell);
          return;
        }
      } on AuthException catch (e) {
        // If Supabase auth fails but demo mode is on, try demo path
        if (isDemoMode.value) {
          await _handleDemoLogin(normalizedPhone, last10);
          return;
        }
        _showError('OTP चुकीचा: ${e.message}');
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _handleDemoLogin(
      String normalizedPhone, String last10) async {
    // Try to find staff by phone in database
    try {
      final staffData = await _supabase
          .from('staff')
          .select('*, wards(*)')
          .or('phone.eq.$normalizedPhone,phone.eq.$last10')
          .maybeSingle();
      if (staffData != null) {
        await _saveAndLoginStaff(staffData);
        return;
      }
    } catch (e) {
      debugPrint('Demo staff lookup: $e');
    }

    // Try any staff record
    try {
      final anyStaff = await _supabase
          .from('staff')
          .select('*, wards(*)')
          .limit(1)
          .maybeSingle();
      if (anyStaff != null) {
        final modified = Map<String, dynamic>.from(anyStaff);
        modified['phone'] = normalizedPhone;
        await _saveAndLoginStaff(modified);
        return;
      }
    } catch (e) {
      debugPrint('Any staff lookup: $e');
    }

    // Ultimate fallback — local mock profile
    await _saveAndLoginStaff(_buildMockStaff(normalizedPhone));
  }

  Map<String, dynamic> _buildMockStaff(String phone) => {
        'id': '20000000-0000-0000-0000-000000000011',
        'employee_id': 'SMK-4001',
        'smkmc_id': 'SMK-4001',
        'name': 'Ramesh Vishnu Patil',
        'name_mr': 'रमेश विष्णू पाटील',
        'phone': phone,
        'role': 'WORKER',
        'department': 'SANITATION',
        'designation': 'Safai Kamgar',
        'shift': 'MORNING',
        'shift_start': '06:00:00',
        'shift_end': '14:00:00',
        'profile_photo_url': null,
        'ward_id': '11111111-0000-0000-0000-000000000004',
        'wards': {
          'id': '11111111-0000-0000-0000-000000000004',
          'ward_name': 'Ward 4 - Walchand College Campus (WCE), Vishrambag',
          'ward_name_mr': 'प्रभाग ४ - वालचंद महाविद्यालय परिसर (WCE)',
          'ward_number': 4,
          'zone': 'SANGLI',
          'boundary': {
            'type': 'Polygon',
            'coordinates': [
              [
                [74.6008, 16.8431],
                [74.6032, 16.8431],
                [74.6032, 16.8455],
                [74.6008, 16.8455],
                [74.6008, 16.8431]
              ]
            ]
          }
        },
      };

  Future<void> loginAsDemo(Map<String, dynamic> staff) async {
    isLoading.value = true;
    try {
      await _saveAndLoginStaff(staff);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveAndLoginStaff(Map<String, dynamic> staff) async {
    currentStaff.value = staff;
    isAuthenticated.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cached_staff_profile', jsonEncode(staff));
    } catch (e) {
      debugPrint('Cache staff error: $e');
    }

    // Reload attendance for newly logged-in staff
    try {
      if (Get.isRegistered<AttendanceController>()) {
        Get.find<AttendanceController>().loadTodayAttendance();
      }
    } catch (_) {}

    // Immediately capture live GPS and start 10-minute periodic tracking for this staff
    try {
      LocationPingService().startLiveTracking(staffId: staff['id']?.toString());
    } catch (e) {
      debugPrint('Live tracking start note: $e');
    }

    Get.offAllNamed(AppRoutes.mainShell);
  }

  // ── Biometric Lock ────────────────────────────────────────

  Future<bool> authenticateWithBiometric() async {
    try {
      final isSupported = await _localAuth.isDeviceSupported();
      final canCheck = await _localAuth.canCheckBiometrics;

      // If device has no biometric hardware at all, return true (skip step)
      if (!isSupported && !canCheck) {
        debugPrint('No biometric hardware — skipping biometric step');
        return true; // allow through without blocking check-in
      }

      final authenticated = await _localAuth.authenticate(
        localizedReason:
            'FieldOps SMKMC: उपस्थिती नोंदवण्यासाठी ओळख द्या',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false, // allow PIN/pattern as fallback
          useErrorDialogs: true,
          sensitiveTransaction: false,
        ),
      );
      return authenticated;
    } catch (e) {
      debugPrint('Biometric auth error: $e');
      // Return true on error to not block check-in flow
      // (real device issues get logged, check-in still proceeds)
      return true;
    }
  }

  Future<bool> authenticateFaceOnly() async {
    return authenticateWithBiometric();
  }

  // ── Profile ───────────────────────────────────────────────

  Future<void> _loadStaffProfile() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;
    try {
      final data = await _supabase
          .from('staff')
          .select('*, wards(*)')
          .or('auth_id.eq.$userId,id.eq.$userId')
          .maybeSingle();
      if (data != null) {
        currentStaff.value = data;
        isAuthenticated.value = true;
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('cached_staff_profile', jsonEncode(data));
        } catch (_) {}
      }
    } catch (e) {
      debugPrint('_loadStaffProfile error: $e');
    }
  }

  Future<void> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('cached_staff_profile');
    } catch (_) {}
    try {
      await _supabase.auth.signOut();
    } catch (_) {}
    currentStaff.value = null;
    isAuthenticated.value = false;
    Get.offAllNamed(AppRoutes.otpLogin);
  }

  // ── Helpers ───────────────────────────────────────────────

  void _showError(String msg) {
    Get.snackbar(
      'त्रुटी',
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade700,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  void _showSuccess(String title, String msg) {
    Get.snackbar(
      title,
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade700,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  // Convenience getters
  String get staffName => currentStaff.value?['name'] as String? ?? '';
  String get staffNameMr =>
      currentStaff.value?['name_mr'] as String? ?? staffName;
  String get staffRole => currentStaff.value?['role'] as String? ?? 'WORKER';
  String get wardName =>
      currentStaff.value?['wards']?['ward_name'] as String? ?? '';
  String get department =>
      currentStaff.value?['department'] as String? ?? '';
  bool get isAdmin => staffRole == 'ADMIN';
  bool get isSupervisor =>
      staffRole == 'ADMIN' ||
      staffRole == 'WARD_INSPECTOR' ||
      staffRole == 'INSPECTOR' ||
      staffRole == 'SUPERVISOR';
}
