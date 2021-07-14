import 'package:daily_report/src/data/todo/chart_date_data.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:get/get.dart';

final TodoController _todoController = Get.put(TodoController());

class ChartController extends GetxController {
  RxInt currentTodoIndex = 0.obs;
  RxInt currentIndex = 0.obs;
  Rx<TodoUidList> chartPageList = TodoUidList(todoList: []).obs;
  double totalSum = 0;
  RxBool mode = false.obs;

  void makeMonthChart(int month) {
    chartPageList.value.todoList.clear();
    chartPageList.value.todoList.addAll(_todoController
        .loadTodoUidList.value.todoList
        .where((element) => element.ymd.month == month));
    sortChartList();
    setPercent();
    setHourMinute();
  }

  void setHourMinute() {
    for(int i = 0; i < chartPageList.value.todoList.length; i++){
      chartPageList.value.todoList[i].hourMinute = '${(chartPageList.value.todoList[i].value / 60).toInt()}h '
      '${chartPageList.value.todoList[i].value % 60}m';
    }
  }

  void setMode() {
    mode(!mode.value);
    print(mode.value);
  }

  void setPercent() {
    totalSum = 0;
    for (int i = 0; i < chartPageList.value.todoList.length; i++) {
      totalSum += chartPageList.value.todoList[i].value;
    }
    for (int i = 0; i < chartPageList.value.todoList.length; i++) {
      chartPageList.value.todoList[i].percent =
          (chartPageList.value.todoList[i].value / totalSum * 100)
              .roundToDouble();
    }
  }

  void sortChartList() {
    chartPageList.value.todoList.sort((a, b) => b.value.compareTo(a.value));
  }

  @override
  void onInit() {
    super.onInit();
    makeMonthChart(DateTime.now().month);
  }
}
