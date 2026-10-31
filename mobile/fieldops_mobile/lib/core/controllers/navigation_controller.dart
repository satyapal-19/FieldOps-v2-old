import 'package:get/get.dart';

class NavigationController extends GetxController {
  final currentIndex = 0.obs;

  void navigateTo(int index) {
    currentIndex.value = index;
  }

  // Named navigation helpers
  void goHome()    => navigateTo(0);
  void goMap()     => navigateTo(1);
  void goTasks()   => navigateTo(2);
  void goChat()    => navigateTo(3);
  void goMore()    => navigateTo(4);
}
