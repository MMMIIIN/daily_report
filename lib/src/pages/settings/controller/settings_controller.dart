import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  RxInt isPercentOrHourIndex = 0.obs;
  RxInt isTimePickerTimeIndex = 1.obs;
  RxInt timePickerOfInterval = 10.obs;
  RxInt listPageIndex = 0.obs;
  RxInt selectPrimaryColorIndex = 0.obs;

  RxString loginText = '로그인'.obs;
  RxBool clickedLogin = false.obs;

  void setLoginText(){
    loginText('');
  }

  void setClickedLogin() {
    clickedLogin(true);
  }

  void setPercentOrHourIndex(int index) {
    isPercentOrHourIndex(index);
    setPercentOrHour();
  }

  void setPercentOrHour() {
    if (isPercentOrHourIndex.value == 0) {
      GetStorage().write('isPercentOrHour', true);
    } else {
      GetStorage().write('isPercentOrHour', false);
    }
  }

  void setListPageIndex(int index) {
    listPageIndex(index);
    setListPage();
  }

  void setListPage() {
    if(listPageIndex.value == 0){
      GetStorage().write('isListPageBool', true);
    } else {
      GetStorage().write('isListPageBool', false);
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
    var percentOrHour = GetStorage().read('isPercentOrHour') ?? false;
    var listPageIndex = GetStorage().read('isListPageBool') ?? false;
    var interval = GetStorage().read('timePickerOfInterval') ?? 1;
    var colorIndex = GetStorage().read('primaryColor') ?? 0;
    if (percentOrHour) {
      isPercentOrHourIndex(0);
      setPercentOrHourIndex(0);
    } else {
      isPercentOrHourIndex(1);
      setPercentOrHourIndex(1);
    }
    if(listPageIndex) {
      setListPageIndex(0);
    } else {
      setListPageIndex(1);
    }
    if (interval != null) {
      isTimePickerTimeIndex(interval);
      setTimePickerTimeIndex(isTimePickerTimeIndex.value);
    }
    if(colorIndex != null){
      print(colorIndex);
      selectPrimaryColorIndex(colorIndex);
      setPrimaryColorIndex(colorIndex);
    }
  }

  void setPrimaryColorIndex(int selectIndex) {
    selectPrimaryColorIndex(selectIndex);
  }

  void setPrimaryColor(int colorIndex) {
    GetStorage().write('primaryColor', colorIndex);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    setInitStorage();
    super.onInit();
  }
}
