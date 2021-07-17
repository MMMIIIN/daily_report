import 'package:get/get.dart';

class SelectDateController extends GetxController{
  RxBool rangeBool = false.obs;
  Rx<DateTime> rangeStart = DateTime.now().obs;
  Rx<DateTime> rangeEnd = DateTime.now().obs;

  void setRangeTime(DateTime startTime, DateTime endTime){
    rangeStart(startTime);
    rangeEnd(endTime);
    setRangeBool();
  }

  void setRangeBool() {
    if(rangeStart.value.hour == 0 && rangeEnd.value.hour == 0){
      rangeBool(true);
    } else{
      rangeBool(false);
    }
  }
}
