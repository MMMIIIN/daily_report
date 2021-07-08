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

// class ChartDateData {
//   YMD ymd;
//   List<ChartDataPercent> data = [];
//
//   ChartDateData({required this.ymd, required this.data});
// }

// class ChartDataPercent {
//   PieChartSectionData data;
//   double percent;
//   TimeRange timeRange;
//   CATEGORY category;
//
//   ChartDataPercent(
//       {required this.data,
//       this.percent = 100.0,
//       required this.timeRange,
//       this.category = CATEGORY.DEFAULT});
// }

class TodoController extends GetxController {
  RxInt currentIndex = 0.obs;
  final currentIndexList = [].obs;
  Rx<DateTime> currentDateTime = DateTime.now().obs;
  final todoList = <Todo>[].obs;
  TodoUidList todoUidList = TodoUidList(todoList: []);
  int valueSum = 0;

  Rx<TimeRange> defaultTime = TimeRange(
          startTime: TimeOfDay(hour: 0, minute: 0),
          endTime: TimeOfDay(hour: 0, minute: 0))
      .obs;
  RxDouble defaultValue = 0.0.obs;

  void todoUidLoad(String uid) async {
    print('uidLoad실행');
    todoUidList = await TodoRepository.to.loadUidTodo(uid);
  }

  void addTodo(String uid, YMD ymd, String title, TimeRange timeRange,
      double value, int colorIndex) async {
    await TodoRepository.to
        .addTodo(uid, ymd, title, timeRange, value, colorIndex);
  }

  void setPercent(){
    valueSum = 0;
    for(int i = 0; i < currentIndexList.length; i++){
      valueSum += todoUidList.todoList[currentIndexList[i]].value;
    }
    for(int j = 0; j < currentIndexList.length; j++){
      todoUidList.todoList[currentIndexList[j]].percent = todoUidList.todoList[currentIndexList[j]].value / valueSum * 100;
    }
  }


  // void setDefaultTime() {
  //   int startHour =
  //       chartClassList[currentIndex.value].data.last.timeRange.startTime.hour;
  //   int startMin =
  //       chartClassList[currentIndex.value].data.last.timeRange.startTime.minute;
  //   int endHour =
  //       chartClassList[currentIndex.value].data.last.timeRange.endTime.hour;
  //   int endMin =
  //       chartClassList[currentIndex.value].data.last.timeRange.endTime.minute;
  //   defaultTime.update((val) {
  //     val!.startTime = TimeOfDay(hour: startHour, minute: startMin);
  //     val.endTime = TimeOfDay(hour: endHour, minute: endMin);
  //   });
  //   update();
  //   print(defaultTime.value);
  // }

  var titleTextController = TextEditingController().obs;

  // void setCurrentIndex(DateTime time) {
  //   var index = todoUidList.todoList.indexWhere((element) =>
  //       element.year == time.year &&
  //       element.month == time.month &&
  //       element.day == time.day);
  //   print('index = $index');
  //   if (index == -1) {
  //     currentIndex(0);
  //   } else {
  //     currentIndex(index);
  //   }
  //   print('currentIndex = $currentIndex');
  //
  //   // setDefaultTime();
  // }

  void setCurrentIndex(DateTime time) {
    currentIndexList.clear();
    for (int i = 0; i < todoUidList.todoList.length; i++) {
      if (todoUidList.todoList[i].year == time.year &&
          todoUidList.todoList[i].month == time.month &&
          todoUidList.todoList[i].day == time.day) {
        currentIndexList.add(i);
      }
    }
    setPercent();
    print(currentIndexList.value);
  }

  // int getDateIndex(YMD dateTime) {
  //   var index = todoUidList.todoList.indexWhere((element) =>
  //       element.year == dateTime.year &&
  //       element.month == dateTime.month &&
  //       element.day == dateTime.day);
  //   print('index = $index');
  //   if (index == -1) {
  //     return index;
  //   } else {
  //     return index;
  //   }
  // }

  // void checkTitle(ChartDateData dateData, String text, double value) {
  //   int index =
  //       dateData.data.indexWhere((element) => element.data.title == text);
  //   if (index == -1) {
  //   } else {}
  // }

  // void initPercent() { 나중에 작업
  //   for (int i = 0; i < todoUidList.todoList.length; i++) {
  //     setDataPercent(todoUidList.todoList[i]);
  //   }
  // }
  //
  // void setDataPercent(ChartDateData _data) {
  //   int sum = 0;
  //   for (int i = 0; i < _data.data.length; i++) {
  //     sum += _data.data[i].data.value.toInt();
  //   }
  //   for (int i = 0; i < _data.data.length; i++) {
  //     _data.data[i].percent =
  //         (_data.data[i].data.value.toInt() / sum * 100).roundToDouble();
  //   }
  // }
  //
  // void sortDataPercent(ChartDateData _data) {
  //   _data.data.sort((a, b) => b.percent.compareTo(a.percent));
  // } #################

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
    // initTodoList();
    // initDateTodoList();
    // initPercent();
    // makeTestData();
    // ever(chartClassList, (_) => )
  }
}
