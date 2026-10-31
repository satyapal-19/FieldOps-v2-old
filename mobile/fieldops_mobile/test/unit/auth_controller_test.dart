import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fieldops_mobile/core/controllers/auth_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthController Tests', () {
    late AuthController authController;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await Supabase.initialize(
        url: 'https://test-project.example.invalid',
        // ignore: deprecated_member_use
        anonKey: 'test-anon-key',
      );
    });

    setUp(() {
      Get.reset();
      Get.testMode = true;
      authController = Get.put(AuthController());
    });

    test('initial state has default unauthenticated properties', () {
      expect(authController.isAuthenticated.value, isFalse);
      expect(authController.isLoading.value, isFalse);
      expect(authController.currentStaff.value, isNull);
      expect(authController.staffName, '');
      expect(authController.isAdmin, isFalse);
      expect(authController.isSupervisor, isFalse);
    });

    test('loginAsDemo correctly populates staff details and convenience getters', () async {
      final mockStaff = {
        'id': 'test-staff-1',
        'name': 'Ramesh Shankar Patil',
        'name_mr': 'रमेश शंकर पाटील',
        'phone': '+919822011111',
        'role': 'STAFF',
        'department': 'SANITATION',
        'designation': 'Safai Kamgar',
        'shift': 'MORNING',
        'shift_start': '06:00:00',
        'shift_end': '14:00:00',
        'profile_photo_url': null,
        'wards': {
          'ward_name': 'Ward 3 — Gaonbhag & Mandai',
          'ward_number': 3,
          'zone': 'SANGLI',
        },
      };

      await authController.loginAsDemo(mockStaff);

      expect(authController.isAuthenticated.value, isTrue);
      expect(authController.staffName, 'Ramesh Shankar Patil');
      expect(authController.staffNameMr, 'रमेश शंकर पाटील');
      expect(authController.department, 'SANITATION');
      expect(authController.wardName, 'Ward 3 — Gaonbhag & Mandai');
      expect(authController.staffRole, 'STAFF');
      expect(authController.isAdmin, isFalse);
      expect(authController.isSupervisor, isFalse);
    });

    test('supervisor staff profile correctly identifies supervisor role', () async {
      final supervisorStaff = {
        'id': 'test-sup-1',
        'name': 'Sanjay Pawar',
        'name_mr': 'संजय पवार',
        'role': 'SUPERVISOR',
        'department': 'SOLID_WASTE',
      };

      await authController.loginAsDemo(supervisorStaff);

      expect(authController.isSupervisor, isTrue);
      expect(authController.isAdmin, isFalse);
    });

    test('admin staff profile correctly identifies admin role', () async {
      final adminStaff = {
        'id': 'test-admin-1',
        'name': 'Vikas More',
        'role': 'ADMIN',
      };

      await authController.loginAsDemo(adminStaff);

      expect(authController.isAdmin, isTrue);
      expect(authController.isSupervisor, isTrue);
    });

    test('signOut clears currentStaff and resets authentication state', () async {
      final mockStaff = {
        'id': 'test-staff-1',
        'name': 'Ramesh Patil',
        'role': 'STAFF',
      };

      await authController.loginAsDemo(mockStaff);
      expect(authController.isAuthenticated.value, isTrue);

      await authController.signOut();
      expect(authController.isAuthenticated.value, isFalse);
      expect(authController.currentStaff.value, isNull);
    });
  });
}
