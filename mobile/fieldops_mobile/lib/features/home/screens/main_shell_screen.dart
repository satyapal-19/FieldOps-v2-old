import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/navigation_controller.dart';
import '../../../core/controllers/locale_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../home/screens/home_screen.dart';
import '../../map/screens/beat_map_screen.dart';
import '../../tasks/screens/task_list_screen.dart';
import '../../more/screens/more_screen.dart';

class MainShellScreen extends StatelessWidget {
  const MainShellScreen({super.key});

  static final _screens = [
    const HomeScreen(),
    const BeatMapScreen(),
    const TaskListScreen(),
    const MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavigationController>();
    final localeController = Get.find<LocaleController>();

    return Obx(() {
      // Observe locale changes so navigation destination labels update instantly
      final _ = localeController.currentLocale.value;

      return Scaffold(
        body: IndexedStack(
          index: navController.currentIndex.value,
          children: _screens,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: navController.currentIndex.value,
          onDestinationSelected: navController.navigateTo,
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.primarySurface,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home, color: AppColors.primary),
              label: 'nav_home'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.map_outlined),
              selectedIcon: const Icon(Icons.map, color: AppColors.primary),
              label: 'nav_map'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.task_outlined),
              selectedIcon: const Icon(Icons.task, color: AppColors.primary),
              label: 'nav_tasks'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.more_horiz),
              selectedIcon: const Icon(Icons.more_horiz, color: AppColors.primary),
              label: 'nav_more'.tr,
            ),
          ],
        ),
      );
    });
  }
}
