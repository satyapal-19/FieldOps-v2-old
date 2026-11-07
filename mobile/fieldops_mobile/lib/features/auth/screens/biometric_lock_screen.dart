import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/controllers/locale_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_theme.dart';

class BiometricLockScreen extends StatefulWidget {
  const BiometricLockScreen({super.key});

  @override
  State<BiometricLockScreen> createState() => _BiometricLockScreenState();
}

class _BiometricLockScreenState extends State<BiometricLockScreen>
    with SingleTickerProviderStateMixin {
  final _authController = Get.find<AuthController>();
  final _localeController = Get.find<LocaleController>();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  bool _isAuthenticating = false;
  bool _failed = false;
  String _statusMessage = 'बायोमेट्रिकने उघडा';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.95, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Auto-prompt biometric after a short render delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) _authenticate();
      });
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;
    setState(() {
      _isAuthenticating = true;
      _failed = false;
      _statusMessage = 'बायोमेट्रिक तपासत आहे...';
    });

    HapticFeedback.lightImpact();

    // Check if device actually has biometrics
    final hasBiometrics = _authController.isBiometricAvailable.value;
    if (!hasBiometrics) {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
          _statusMessage = 'सत्यापित झाले ✓';
        });
      }
      await Future.delayed(const Duration(milliseconds: 400));
      if (mounted) Get.offAllNamed(AppRoutes.mainShell);
      return;
    }

    final success = await _authController.authenticateWithBiometric();

    if (!mounted) return;

    if (success) {
      HapticFeedback.mediumImpact();
      setState(() {
        _isAuthenticating = false;
        _failed = false;
        _statusMessage = 'सत्यापित झाले ✓';
      });
      await Future.delayed(const Duration(milliseconds: 250));
      if (mounted) Get.offAllNamed(AppRoutes.mainShell);
    } else {
      HapticFeedback.heavyImpact();
      setState(() {
        _isAuthenticating = false;
        _failed = true;
        _statusMessage = 'बायोमेट्रिक जुळले नाही. पुन्हा प्रयत्न करा.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {},
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: SafeArea(
          child: Obx(() {
            // Observe locale changes reactively
            final _ = _localeController.currentLocale.value;
            final isEn = _localeController.currentLocale.value.languageCode == 'en';
            _authController.profile.value;
            final staffName = isEn ? _authController.staffName : _authController.staffNameMr;
            final staffRole = 'role_${_authController.staffRole}'.tr;
            final ward = _authController.wardName.isNotEmpty
                ? _authController.wardName
                : _authController.department;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── Top Header & Language Chips ───────────────────
                  Column(
                    children: [
                      // Language Selector at top
                      _buildLanguageSelector(),

                      const SizedBox(height: 14),

                      // Official Municipal Logo
                      Container(
                        width: 84,
                        height: 84,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/smkmc_logo.png',
                            width: 76,
                            height: 76,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.account_balance,
                              color: AppColors.primary,
                              size: 44,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'smkmc_title'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'NotoSansDevanagari',
                          color: Color(0xFF1B5E20),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Sangli Miraj Kupwad Municipal Corporation',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.subtle,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Staff profile chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        constraints: const BoxConstraints(maxWidth: 340),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.person_pin, color: AppColors.primary, size: 18),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                '${'greeting_prefix'.tr}, $staffName ($staffRole)',
                                style: const TextStyle(
                                  fontFamily: 'NotoSansDevanagari',
                                  color: AppColors.onSurface,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // ── Central Biometric Target ──────────────────
                  Column(
                    children: [
                      GestureDetector(
                        onTap: _authenticate,
                        child: AnimatedBuilder(
                          animation: _pulseAnim,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _isAuthenticating ? 1.0 : _pulseAnim.value,
                              child: child,
                            );
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer ripple
                              Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _failed
                                      ? AppColors.errorSurface
                                      : AppColors.primarySurface.withValues(alpha: 0.6),
                                ),
                              ),
                              // Mid ring
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _failed
                                      ? AppColors.errorSurface
                                      : AppColors.primarySurface,
                                  border: Border.all(
                                    color: _failed
                                        ? AppColors.error.withValues(alpha: 0.4)
                                        : AppColors.primaryTonal,
                                    width: 2,
                                  ),
                                ),
                              ),
                              // Center hero circle
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: _failed
                                        ? [AppColors.error, const Color(0xFFD32F2F)]
                                        : [AppColors.primary, AppColors.primaryLight],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (_failed ? AppColors.error : AppColors.primary)
                                          .withValues(alpha: 0.35),
                                      blurRadius: 18,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: _isAuthenticating
                                      ? const SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 3,
                                          ),
                                        )
                                      : Icon(
                                          _failed ? Icons.error_outline : Icons.fingerprint,
                                          color: Colors.white,
                                          size: 48,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Status text
                      Text(
                        _statusMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'NotoSansDevanagari',
                          color: _failed ? AppColors.error : AppColors.primary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ward,
                        style: const TextStyle(
                          fontFamily: 'NotoSansDevanagari',
                          color: AppColors.subtle,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  // ── Bottom Action Buttons ─────────────────────
                  Column(
                    children: [
                      // Primary Unlock Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton.icon(
                          onPressed: _isAuthenticating ? null : _authenticate,
                          icon: const Icon(Icons.fingerprint, size: 22),
                          label: Text(
                            _failed ? 'पुन्हा स्कॅन करा' : 'biometric_unlock'.tr,
                            style: const TextStyle(
                              fontFamily: 'NotoSansDevanagari',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _authController.signOut,
                          icon: const Icon(Icons.switch_account, size: 16),
                          label: Text(
                            'switch_account'.tr,
                            style: const TextStyle(
                              fontFamily: 'NotoSansDevanagari',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(44),
                            side: const BorderSide(color: Color(0xFFD1D5DB)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'smkmc_footer'.tr,
                        style: const TextStyle(
                          fontFamily: 'NotoSansDevanagari',
                          fontSize: 11,
                          color: AppColors.subtle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    final currentCode = _localeController.currentLocale.value.languageCode;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: LocaleController.supportedLocales.map((loc) {
          final isSelected = loc['code'] == currentCode;
          return GestureDetector(
            onTap: () async {
              await _localeController.changeLocale(loc['code'] as String);
              setState(() {});
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                loc['name'] as String,
                style: TextStyle(
                  fontFamily: 'NotoSansDevanagari',
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF4B5563),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
