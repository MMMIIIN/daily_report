import 'dart:math';

import 'package:daily_report/color.dart';
import 'package:daily_report/src/data/todo/todo.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_range_picker/time_range_picker.dart';

class ChartData {
  PieChartSectionData chartSectionData;
  String percent;

  ChartData({required this.chartSectionData, this.percent = ''});
}

class TodoController extends GetxController {
  final todoList = <Todo>[].obs;
  Rx<TimeRange> defaultTime = TimeRange(
          startTime: TimeOfDay(hour: 0, minute: 0),
          endTime: TimeOfDay(hour: 0, minute: 0))
      .obs;
  var titleTextController = TextEditingController().obs;

  var chartClassList = <ChartData>[].obs;
  RxInt allSum = 0.obs;


  void initTodoList() {
    var initData = Todo(
        title: 'example',
        time: TimeRange(
            startTime: TimeOfDay(hour: 0, minute: 0),
            endTime: TimeOfDay(hour: 3, minute: 30)));
    todoList.add(initData);
  }

  void addClassChartData(String title, double value) {
    chartClassList.add(
      ChartData(
        chartSectionData: PieChartSectionData(
            title: title,
            value: value,
            color: colorList[Random().nextInt(colorList.length)]),
        // percent: getPercent(value.toInt())
      ),
    );
  }

  void totalSum() {
    int sum = 0;
    print('length = ${chartClassList.length}');
    for (int i = 0; i < chartClassList.length; i++){
      sum += chartClassList[i].chartSectionData.value.toInt();
    }
    print(sum);
    allSum(sum);
    print('allSum = $allSum');
  }

  void setPercent(){
    for(int i = 0; i < chartClassList.length; i++){
      chartClassList[i].percent = getPercent(chartClassList[i].chartSectionData.value.toInt());
    }
  }

  String getPercent(int num) {
    totalSum();
    allSum.toInt() / num * 100;
    print(allSum.toInt() / num * 100);
    return '${(num / allSum.toInt() * 100).toStringAsFixed(1)}';
  }


  void setTime(TimeRange time) {
    defaultTime.update((val) {
      val!.startTime = time.startTime;
      val.endTime = time.endTime;
    });
    update();
  }

  void sortTodoList() {
    todoList
        .sort((a, b) => a.time.startTime.hour.compareTo(b.time.startTime.hour));
  }

  double getTime(TimeRange time) {
    var time1 = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, time.startTime.hour, time.startTime.minute);
    var time2 = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, time.endTime.hour, time.endTime.minute);
    var result = time2.difference(time1).inMinutes;
    print(result);
    return result.toDouble();
  }

  @override
  void onInit() {
    super.onInit();
    // TODO: implement onInit
    initTodoList();
    // initChartList();
  }
}
