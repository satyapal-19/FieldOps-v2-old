import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';

/// Shown when this build is older than the server's minimum version.
class UpdateRequiredScreen extends StatelessWidget {
  const UpdateRequiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final url = Get.arguments as String?;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.system_update, size: 80, color: AppColors.primary),
                const SizedBox(height: 16),
                Text('update_required'.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text('update_required_desc'.tr,
                    textAlign: TextAlign.center, style: const TextStyle(color: AppColors.subtle)),
                const SizedBox(height: 24),
                if (url != null && url.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
                      child: Text('update_now'.tr),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
