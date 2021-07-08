import 'package:daily_report/src/data/todo/chart_date_data.dart';
import 'package:daily_report/src/data/todo/todo.dart';
import 'package:daily_report/src/repository/todo_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';

enum CATEGORY { DEFAULT, STUDY, SHOPPING, EXERCISE, SLEEP }

class YMD {
  int year;
  int month;
  int day;

  YMD({required this.year, required this.month, required this.day});
}

class TodoController extends GetxController {
  RxInt currentIndex = 0.obs;
  final currentIndexList = [].obs;
  Rx<DateTime> currentDateTime = DateTime.now().obs;
  final todoList = <Todo>[].obs;
  Rx<TodoUidList> todoUidList = TodoUidList(todoList: []).obs;
  int valueSum = 0;
  var titleTextController = TextEditingController().obs;


  Rx<TimeRange> defaultTime = TimeRange(
          startTime: TimeOfDay(hour: 0, minute: 0),
          endTime: TimeOfDay(hour: 0, minute: 0))
      .obs;
  RxDouble defaultValue = 0.0.obs;

  void todoUidLoad(String uid) async {
    print('uidLoad실행');
    todoUidList(await TodoRepository.to.loadUidTodo(uid));
  }

  void addTodo(String uid, YMD ymd, String title, TimeRange timeRange,
      double value, int colorIndex) async {
    await TodoRepository.to
        .addTodo(uid, ymd, title, timeRange, value, colorIndex);
  }

  void setPercent(){
    valueSum = 0;
    for(int i = 0; i < currentIndexList.length; i++){
      valueSum += todoUidList.value.todoList[currentIndexList[i]].value;
    }
    for(int j = 0; j < currentIndexList.length; j++){
      todoUidList.value.todoList[currentIndexList[j]].percent = todoUidList.value.todoList[currentIndexList[j]].value / valueSum * 100;
    }
  }

  void setCurrentIndex(DateTime time) {
    currentIndexList.clear();
    for (int i = 0; i < todoUidList.value.todoList.length; i++) {
      if (todoUidList.value.todoList[i].year == time.year &&
          todoUidList.value.todoList[i].month == time.month &&
          todoUidList.value.todoList[i].day == time.day) {
        currentIndexList.add(i);
      }
    }
    setPercent();
    print(currentIndexList.value);
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

  // void sortChartList() {
  //   chartClassList.sort((a, b) => b.percent.compareTo(a.percent));
  // }

  double getValue(DateTime _datetime, TimeRange time) {
    var time1 = DateTime(_datetime.year, _datetime.month, _datetime.day,
        time.startTime.hour, time.startTime.minute);
    var time2 = DateTime(_datetime.year, _datetime.month, _datetime.day,
        time.endTime.hour, time.endTime.minute);
    var result = time2.difference(time1).inMinutes;
    if (result < 0) {
      result += 1440;
    }
    print('time1 = $time1');
    print('time2 = $time2');
    print('result = $result');
    return result.toDouble();
  }

  @override
  void onInit() {
    super.onInit();
    // TODO: implement onInit
  }
}
