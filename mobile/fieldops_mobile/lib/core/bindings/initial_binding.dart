import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/locale_controller.dart';
import '../../features/attendance/controllers/attendance_controller.dart';

import '../services/location_ping_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LocaleController(),    permanent: true);
    Get.put(AuthController(),      permanent: true);
    Get.put(NavigationController(), permanent: true);
    Get.put(AttendanceController(), permanent: true);

    // Immediately capture live GPS location on app launch and keep sending every 10 mins
    LocationPingService().startLiveTracking();
  }
}
