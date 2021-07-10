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
  // RxInt currentIndex = 0.obs;
  final currentIndexList = [].obs;
  Rx<DateTime> currentDateTime = DateTime.now().obs;
  final todoList = <Todo>[].obs;
  Rx<TodoUidList> todoUidList = TodoUidList(todoList: []).obs;
  int valueSum = 0;
  var titleTextController = TextEditingController().obs;
  Rx<TodoUidList> currentUidList = TodoUidList(todoList: []).obs;
  final todoTitleList = <TodoTitle>[].obs;

  var searchTitleController = TextEditingController().obs;
  RxString searchTerm = ''.obs;

  Rx<TimeRange> defaultTime = TimeRange(
          startTime: TimeOfDay(hour: 0, minute: 0),
          endTime: TimeOfDay(hour: 0, minute: 0))
      .obs;
  RxDouble defaultValue = 0.0.obs;
  RxInt selectColorIndex = 0.obs;

  void todoUidLoad(String uid) async {
    print('uidLoad실행');
    todoUidList(await TodoRepository.to.loadUidTodo(uid));
    initTodoTitleList();
  }

  void addTodo(String uid, YMD ymd, String title, TimeRange timeRange,
      double value, int colorIndex) async {
    await TodoRepository.to
        .addTodo(uid, ymd, title, timeRange, value, colorIndex);
  }

  void setPercent() {
    valueSum = 0;
    for (int i = 0; i < currentIndexList.length; i++) {
      valueSum += currentUidList.value.todoList[i].value;
    }
    for (int j = 0; j < currentIndexList.length; j++) {
      currentUidList.value.todoList[j].percent =
          currentUidList.value.todoList[j].value / valueSum * 100;
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
    setCurrentList();
    setPercent();
    sortCurrentList();
    print(currentIndexList.value);
  }

  void setCurrentList() {
    currentUidList.value.todoList.clear();
    for (int i = 0; i < currentIndexList.length; i++) {
      currentUidList.value.todoList
          .add(todoUidList.value.todoList[currentIndexList[i]]);
    }
  }

  void sortCurrentList() {
    currentUidList.value.todoList
        .sort((a, b) => b.percent.compareTo(a.percent));
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

  void initTodoTitleList() {
    print('initTitle실행 ');
    for (int i = 0; i < todoUidList.value.todoList.length; i++) {
      addTodoTitle(todoUidList.value.todoList[i].title);
    }
  }

  void addTodoTitle(String text) {
    var index = todoTitleList.indexWhere((element) => element.title == text);
    if(index == -1){
      todoTitleList.add(TodoTitle(title: text));
    }
  }

  List<TestTodo> searchTitle(String text){
    return todoUidList.value.todoList.where((element) => element.title.contains(text)).toList();
  }

  @override
  void onInit() {
    super.onInit();
    // TODO: implement onInit
  }
}
