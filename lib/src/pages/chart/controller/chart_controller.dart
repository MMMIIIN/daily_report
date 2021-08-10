import 'package:daily_report/src/data/todo/chart_date_data.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/chart/controller/select_date_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final TodoController _todoController = Get.put(TodoController());
final SelectDateController _selectDateController =
    Get.put(SelectDateController());

class ChartController extends GetxController {
  final currentIndexList = [].obs;
  Rx<TodoUidList> chartPageList = TodoUidList(todoList: []).obs;
  Rx<TodoUidList> checkChartPageList = TodoUidList(todoList: []).obs;

  double totalSum = 0;
  RxInt modeIndex = 0.obs;

  void makeMonthChart(DateTime dateTime) {
    chartPageList.value.todoList.clear();
    _todoController.todoUidList.value.todoList.forEach((element) {
      if (element.ymd.year == dateTime.year &&
          element.ymd.month == dateTime.month) {
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
      }
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
    for (var i = 0; i < checkChartPageList.value.todoList.length; i++) {
      checkChartPageList.value.todoList[i].hourMinute =
          '${checkChartPageList.value.todoList[i].value ~/ 60}h '
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

  void makeRangeDate() {
    var timeRange = DateTimeRange(
        start: _selectDateController.rangeStart.value,
        end: _selectDateController.rangeEnd.value);
    chartPageList.value.todoList.clear();
    checkChartPageList.value.todoList.clear();
    var rangeOfDays = timeRange.end.difference(timeRange.start).inDays;
    currentIndexList.clear();
    for (var i = 0; i <= rangeOfDays; i++) {
      var date = timeRange.start.add(Duration(days: i));
      for (var j = 0;
          j < _todoController.loadTodoUidList.value.todoList.length;
          j++) {
        if (_todoController.loadTodoUidList.value.todoList[j].ymd.year ==
                date.year &&
            _todoController.loadTodoUidList.value.todoList[j].ymd.month ==
                date.month &&
            _todoController.loadTodoUidList.value.todoList[j].ymd.day ==
                date.day) {
          currentIndexList.add(j);
        }
      }
    }
    setChartList();
    chartPageList.value.todoList.forEach((element) {
      makeChart(element);
    });
    setPercent();
    sortChartList();
    setHourMinute();
  }

  void setChartList() {
    chartPageList.value.todoList.clear();
    for (var i = 0; i < currentIndexList.length; i++) {
      var item =
          _todoController.loadTodoUidList.value.todoList[currentIndexList[i]];
      chartPageList.value.todoList.add(TestTodo(
          uid: item.uid,
          ymd: item.ymd,
          title: item.title,
          startHour: item.startHour,
          startMinute: item.startMinute,
          endHour: item.endHour,
          endMinute: item.endMinute,
          value: item.value,
          colorIndex: item.colorIndex));
    }
    update();
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

  @override
  void onInit() {
    super.onInit();
    makeMonthChart(DateTime.now());
  }
}
