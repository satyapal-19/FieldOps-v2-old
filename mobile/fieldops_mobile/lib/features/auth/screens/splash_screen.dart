import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fieldops_api/fieldops_api.dart';

import '../../../core/controllers/auth_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/app_config_service.dart';
import '../../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    _scaleAnim = Tween<double>(begin: 0.85, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );
    _animController.forward();

    _route();
  }

  /// Version gate, then the saved session (if any) or sign-in.
  Future<void> _route() async {
    final results = await Future.wait([
      AppConfigService.fetch(),
      Future<void>.delayed(const Duration(milliseconds: 1200)),
    ]);
    final info = results.first as AppInfoDto?;
    if (AppConfigService.needsUpdate(info)) {
      Get.offAllNamed(AppRoutes.updateRequired, arguments: info!.updateUrl);
      return;
    }
    if (info != null && AppConfigService.clockIsOff(DateTime.now().toUtc(), info.serverTime)) {
      Get.snackbar('clock_wrong_title'.tr, 'clock_wrong_desc'.tr,
          snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 6));
    }
    await Get.find<AuthController>().checkExistingSession();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: AnimatedBuilder(
        animation: _animController,
        builder: (_, __) => FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Official Municipal Logo
                    Container(
                      width: 120,
                      height: 120,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/smkmc_logo.png',
                          width: 110,
                          height: 110,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.account_balance,
                            color: AppColors.primary,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'सांगली मिरज आणि कुपवाड शहर महानगरपालिका',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'NotoSansDevanagari',
                        color: Color(0xFF1B5E20),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Sangli Miraj Kupwad Municipal Corporation',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.subtle,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'FieldOps SMKMC',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
