import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt currentIndex = 0.obs;

  void changeTapMenu(int index) {
    currentIndex(index);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
