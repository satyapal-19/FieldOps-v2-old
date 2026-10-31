import 'package:get/get.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/biometric_lock_screen.dart';
import '../../features/auth/screens/otp_login_screen.dart';
import '../../features/home/screens/main_shell_screen.dart';
import '../../features/attendance/screens/checkin_flow_screen.dart';

class AppRoutes {
  static const splash         = '/';
  static const biometricLock  = '/lock';
  static const otpLogin       = '/login';
  static const mainShell      = '/home';
  static const checkInFlow    = '/checkin';
  static const checkOutFlow   = '/checkout';

  static final pages = [
    GetPage(name: splash,        page: () => const SplashScreen(), popGesture: false),
    GetPage(name: biometricLock, page: () => const BiometricLockScreen(), popGesture: false),
    GetPage(name: otpLogin,      page: () => const OtpLoginScreen(), popGesture: false),
    GetPage(name: mainShell,     page: () => const MainShellScreen(), popGesture: false),
    GetPage(name: checkInFlow,   page: () => const CheckInFlowScreen()),
    GetPage(name: checkOutFlow,  page: () => const CheckInFlowScreen(isCheckOut: true)),
  ];
}
