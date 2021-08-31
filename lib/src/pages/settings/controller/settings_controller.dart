import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  RxInt isDarkModeIndex = 0.obs;
  RxInt isPercentOrHourIndex = 0.obs;
  RxInt isTimePickerTimeIndex = 1.obs;
  RxInt timePickerOfInterval = 10.obs;
  RxInt listPageIndex = 0.obs;

  void setDarkModeIndex(int index) {
    isDarkModeIndex(index);
    setDarkMode();
  }

  void setDarkMode() {
    if (isDarkModeIndex.value == 0) {
      GetStorage().write('isDarkMode', false);
    } else {
      GetStorage().write('isDarkMode', true);
    }
  }

  void setPercentOrHourIndex(int index) {
    isPercentOrHourIndex(index);
    setPercentOrHour();
  }

  void setPercentOrHour() {
    if (isPercentOrHourIndex.value == 0) {
      GetStorage().write('isPercentOrHour', false);
    } else {
      GetStorage().write('isPercentOrHour', true);
    }
  }

  void setTimePickerTimeIndex(int index) {
    isTimePickerTimeIndex(index);
    setTimePickerOfInterval(index);
  }

  void setTimePickerOfInterval(index) async{
    switch (index)  {
      case 0:
        timePickerOfInterval(5);
        await GetStorage().write('timePickerOfInterval', 0);
        break;
      case 1:
        timePickerOfInterval(10);
        await GetStorage().write('timePickerOfInterval', 1);
        break;
      case 2:
        timePickerOfInterval(15);
        await GetStorage().write('timePickerOfInterval', 2);
        break;
      case 3:
        timePickerOfInterval(20);
        await GetStorage().write('timePickerOfInterval', 3);
        break;
      case 4:
        timePickerOfInterval(30);
        await GetStorage().write('timePickerOfInterval', 4);
        break;
    }
  }

  void setInitStorage() {
    var darkModeIndex = GetStorage().read('isDarkMode') ?? false;
    var percentOrHour = GetStorage().read('isPercentOrHour') ?? false;
    var interval = GetStorage().read('timePickerOfInterval') ?? 1;
    if (darkModeIndex) {
      isDarkModeIndex(1);
    } else {
      isDarkModeIndex(0);
    }
    if (percentOrHour) {
      isPercentOrHourIndex(1);
    } else {
      isPercentOrHourIndex(0);
    }
    if (interval != null) {
      isTimePickerTimeIndex(interval);
      setTimePickerTimeIndex(isTimePickerTimeIndex.value);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    setInitStorage();
    print(isDarkModeIndex.value);
    print(isPercentOrHourIndex.value);
    print(timePickerOfInterval.value);
    super.onInit();
  }
}
