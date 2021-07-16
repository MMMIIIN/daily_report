import 'package:daily_report/src/data/todo/chart_date_data.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:get/get.dart';

final TodoController _todoController = Get.put(TodoController());

class ChartController extends GetxController {
  RxInt currentTodoIndex = 0.obs;
  RxInt currentIndex = 0.obs;
  Rx<TodoUidList> chartPageList = TodoUidList(todoList: []).obs;
  Rx<TodoUidList> checkChartPageList = TodoUidList(todoList: []).obs;

  double totalSum = 0;
  RxInt modeIndex = 0.obs;

  void makeMonthChart(DateTime dateTime) {
    chartPageList.value.todoList.clear();
    chartPageList.value.todoList.addAll(
        _todoController.loadTodoUidList.value.todoList.where((element) =>
            element.ymd.year == dateTime.year &&
            element.ymd.month == dateTime.month));
    // setPercent();
    // setHourMinute();
    initChart();
  }

  void initChart() {
    for (int i = 0; i < chartPageList.value.todoList.length; i++) {
      makeChart(chartPageList.value.todoList[i]);
    }
    sortChartList();
    setPercent();
    setHourMinute();
  }

  void makeChart(TestTodo data) {
    var index = checkChartPageList.value.todoList
        .indexWhere((element) => element.title == data.title);
    if (index != -1) {
      checkChartPageList.value.todoList[index].value += data.value;
    } else {
      checkChartPageList.value.todoList.add(data);
    }
  }

  void setHourMinute() {
    for (int i = 0; i < checkChartPageList.value.todoList.length; i++) {
      checkChartPageList.value.todoList[i].hourMinute =
          '${(checkChartPageList.value.todoList[i].value / 60).toInt()}h '
          '${checkChartPageList.value.todoList[i].value % 60}m';
    }
  }

  void setMode(int index) {
    modeIndex(index);
  }

  void setPercent() {
    totalSum = 0;
    for (int i = 0; i < checkChartPageList.value.todoList.length; i++) {
      totalSum += checkChartPageList.value.todoList[i].value;
    }
    for (int i = 0; i < checkChartPageList.value.todoList.length; i++) {
      checkChartPageList.value.todoList[i].percent =
          (checkChartPageList.value.todoList[i].value / totalSum * 100)
              .roundToDouble();
    }
  }

  void sortChartList() {
    checkChartPageList.value.todoList
        .sort((a, b) => b.value.compareTo(a.value));
  }

  @override
  void onInit() {
    super.onInit();
    makeMonthChart(DateTime.now());
  }
}
