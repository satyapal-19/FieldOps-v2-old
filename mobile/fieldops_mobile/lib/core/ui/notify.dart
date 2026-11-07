import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/api_failure.dart';
import '../controllers/auth_controller.dart';

/// Snackbars with the shared error table, so every screen words errors alike.
class Notify {
  Notify._();

  static void failure(Object error) => Get.snackbar(
        'error'.tr,
        ApiFailure.from(error).message(AuthController.lang),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );

  static void warn(String message) => Get.snackbar(
        'error'.tr,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade800,
        colorText: Colors.white,
      );

  static void ok(String title, [String message = '']) => Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade700,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
}

/// `YYYY-MM-DD` for a calendar day picked on the phone.
String isoDay(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
