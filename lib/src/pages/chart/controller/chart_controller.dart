import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final TodoController _todoController = Get.put(TodoController());

class ChartController extends GetxController {
  RxInt currentTodoIndex = 0.obs;
  RxInt currentIndex = 0.obs;
  var chartPageList = <ChartDateData>[].obs;

  void initChartPageList() {
    chartPageList.add(ChartDateData(
        ymd: YMD(
            year: 2019,
            month: 1,
            day: 1),
        data: [
          // ChartDataPercent(
          //     data: PieChartSectionData(
          //         title: 'test', value: 50, color: Colors.green))
        ]));
  }

  void setCurrentTodoIndex(DateTime _dateTime) {
    var index = _todoController.chartClassList.indexWhere((element) =>
        element.ymd.year == _dateTime.year &&
        element.ymd.month == _dateTime.month &&
        element.ymd.day == _dateTime.day);
    print('index = $index');
    if (index == -1) {
      currentIndex(0);
    }else{
      currentTodoIndex(index);
    }
    print('currentTodoIndex.value = ${currentTodoIndex.value}');
    if (currentTodoIndex.value != 0) {
      addChartPageList(_dateTime);
    }
  }

  void addChartPageList(DateTime _dateTime) {
    chartPageList.clear();
    initChartPageList();
    for (int index = 0;
        index <
            _todoController.chartClassList[currentTodoIndex.value].data.length;
        index++) {
      print('add실행 $index');
      chartPageList.add(
        ChartDateData(
            ymd: YMD(
                year: _dateTime.year,
                month: _dateTime.month,
                day: _dateTime.day),
            data: [
              ChartDataPercent(
                  data: PieChartSectionData(
                title: _todoController.chartClassList[currentTodoIndex.value]
                    .data[index].data.title,
                value: _todoController.chartClassList[currentTodoIndex.value]
                    .data[index].data.value,
                color: _todoController.chartClassList[currentTodoIndex.value]
                    .data[index].data.color,
              ))
            ]),
      );
    }
    setCurrentIndex(_dateTime);
  }

  void setCurrentIndex(DateTime _dateTime) {
    var index = chartPageList.indexWhere((element) =>
        element.ymd.year == _dateTime.year &&
        element.ymd.month == _dateTime.month &&
        element.ymd.day == _dateTime.day);
    currentIndex(index);
    print('currentIndex = ${currentIndex.value}');
  }

  int getDay(int currentMonth) {
    var day = 0;
    if (currentMonth == 1) {
      day = 31;
    }
    if (currentMonth == 2) {
      day = 28;
    }
    if (currentMonth == 3) {
      day = 31;
    }
    if (currentMonth == 4) {
      day = 30;
    }
    if (currentMonth == 5) {
      day = 31;
    }
    if (currentMonth == 6) {
      day = 30;
    }
    if (currentMonth == 7) {
      day = 31;
    }
    if (currentMonth == 8) {
      day = 31;
    }
    if (currentMonth == 9) {
      day = 30;
    }
    if (currentMonth == 10) {
      day = 31;
    }
    if (currentMonth == 11) {
      day = 30;
    }
    if (currentMonth == 12) {
      day = 31;
    }
    return day;
  }
  @override
  void onInit() {
    super.onInit();
    initChartPageList();
  }
}
