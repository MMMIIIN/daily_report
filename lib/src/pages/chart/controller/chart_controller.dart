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
    _todoController.todoUidList.value.todoList.forEach((element) {
      var item = element;
      chartPageList.value.todoList.add(TestTodo(
          uid: item.uid,
          ymd: item.ymd,
          title: item.title,
          startHour: item.startMinute,
          startMinute: item.startMinute,
          endHour: item.endHour,
          endMinute: item.endMinute,
          value: item.value,
          colorIndex: item.colorIndex));
    });
    initChart();
  }

  void initChart() {
    chartPageList.value.todoList.forEach((element) => makeChart(element));
    sortChartList();
    setPercent();
    setHourMinute();
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
    checkChartPageList.value.todoList.forEach((element) {
      totalSum += element.value;
    });
    checkChartPageList.value.todoList.forEach((element) {
      element.percent = element.value / totalSum * 100;
    });
  }

  void sortChartList() {
    checkChartPageList.value.todoList
        .sort((a, b) => b.value.compareTo(a.value));
  }

  void makeDateRange(DateTime startTime, DateTime endTime) {
    chartPageList.value.todoList.clear();
    checkChartPageList.value.todoList.clear();
    var rangeOfDays = endTime.difference(startTime).inDays + 1;
    for (int i = 0; i < rangeOfDays; i++) {
      chartPageList.value.todoList.addAll(_todoController
          .todoUidList.value.todoList
          .where((element) => element.ymd == startTime.add(Duration(days: i))));
    }
    for (int i = 0; i < chartPageList.value.todoList.length; i++) {
      makeChart(chartPageList.value.todoList[i]);
    }
    setPercent();
    sortChartList();
    setHourMinute();
  }

  void makeChart(TestTodo data) {
    var index = checkChartPageList.value.todoList
        .indexWhere((element) => element.title == data.title);
    print(index);
    if (index != -1) {
      checkChartPageList.value.todoList[index].value += data.value;
    } else {
      checkChartPageList.value.todoList.add(TestTodo(
          uid: data.uid,
          ymd: data.ymd,
          title: data.title,
          startHour: data.startHour,
          startMinute: data.startMinute,
          endHour: data.endHour,
          endMinute: data.endMinute,
          value: data.value,
          colorIndex: data.colorIndex));
    }
  }

  @override
  void onInit() {
    super.onInit();
    makeMonthChart(DateTime.now());
  }
}
