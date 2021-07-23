import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController{
  RxInt isDarkModeIndex = 0.obs;

  void setDarkModeIndex(int index) {
    isDarkModeIndex(index);
    setDarkMode();
  }

  void setDarkMode(){
    if(isDarkModeIndex.value == 0){
      GetStorage().write('isDarkMode', false);
    } else {
      GetStorage().write('isDarkMode', true);
    }
  }
}