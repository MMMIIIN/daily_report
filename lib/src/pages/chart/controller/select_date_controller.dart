import 'package:get/get.dart';

class SelectDateController extends GetxController{
  RxBool rangeBool = false.obs;
  Rx<DateTime> rangeStart = DateTime(DateTime.now().year, DateTime.now().month, 1).obs;
  Rx<DateTime> rangeEnd = DateTime(DateTime.now().year, DateTime.now().month + 1, 0).obs;

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
