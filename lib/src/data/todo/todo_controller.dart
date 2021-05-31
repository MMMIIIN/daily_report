import 'dart:collection';
import 'dart:math';

import 'package:daily_report/color.dart';
import 'package:daily_report/src/data/todo/todo.dart';
import 'package:daily_report/src/pages/home/homepage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_range_picker/time_range_picker.dart';

final EventsList = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(kMINEventSource);

class YMD {
  int year;
  int month;
  int day;

  YMD({required this.year, required this.month, required this.day});
}

class ChartDataPercent {
  PieChartSectionData data;
  double percent;

  ChartDataPercent({required this.data, this.percent = 100.0});
}

class ChartDateData {
  YMD ymd;
  List<ChartDataPercent> data = [];

  // PieChart chartSectionData;
  // double percent;

  // ChartDateData(
  //     {required this.chartSectionData, required this.ymd, this.percent = 0.0});
  ChartDateData({required this.ymd, required this.data});
}

class TodoTitle {
  int index;
  String title;

  TodoTitle({this.index = 0, required this.title});
}

class TodoController extends GetxController {
  RxInt currentIndex = 0.obs;
  Rx<DateTime> currentDateTime = DateTime.now().obs;
  final todoList = <Todo>[].obs;
  final todoTitleList = <TodoTitle>[].obs;

  final todoDateList = <DateTodo>[
    DateTodo(day: 16, todo: [
      Todo(
          title: 'test1',
          time: TimeRange(
            startTime: TimeOfDay(hour: 3, minute: 20),
            endTime: TimeOfDay(hour: 5, minute: 40),
          )),
      Todo(
          title: 'test2',
          time: TimeRange(
            startTime: TimeOfDay(hour: 6, minute: 10),
            endTime: TimeOfDay(hour: 8, minute: 40),
          )),
    ]),
    DateTodo(day: 25, todo: [
      Todo(
          title: 'test1',
          time: TimeRange(
            startTime: TimeOfDay(hour: 3, minute: 20),
            endTime: TimeOfDay(hour: 5, minute: 40),
          )),
      Todo(
          title: 'test2',
          time: TimeRange(
            startTime: TimeOfDay(hour: 6, minute: 10),
            endTime: TimeOfDay(hour: 8, minute: 40),
          )),
    ]),
    DateTodo(day: 31, todo: [
      Todo(
          title: 'test1',
          time: TimeRange(
            startTime: TimeOfDay(hour: 3, minute: 20),
            endTime: TimeOfDay(hour: 5, minute: 40),
          )),
    ]),
  ].obs;

  Rx<TimeRange> defaultTime = TimeRange(
          startTime: TimeOfDay(hour: 0, minute: 0),
          endTime: TimeOfDay(hour: 0, minute: 0))
      .obs;

  RxString defaultText = ''.obs;

  var titleTextController = TextEditingController().obs;

  var chartClassList = <ChartDateData>[
    ChartDateData(ymd: YMD(year: 2021, month: 5, day: 1), data: [
      ChartDataPercent(
          data: PieChartSectionData(title: 'sample', color: Colors.blue))
    ]),
    ChartDateData(ymd: YMD(year: 2021, month: 5, day: 16), data: [
      ChartDataPercent(
          data: PieChartSectionData(
              title: 'study', value: 100, color: Colors.purpleAccent)),
      ChartDataPercent(
          data: PieChartSectionData(
              title: 'game', value: 150, color: Colors.redAccent)),
    ]),
    ChartDateData(ymd: YMD(year: 2021, month: 5, day: 25), data: [
      ChartDataPercent(
          data: PieChartSectionData(
              title: 'bible', value: 300, color: Colors.greenAccent)),
      ChartDataPercent(
          data: PieChartSectionData(
              title: 'sleep', value: 150, color: Colors.blue)),
    ]),
  ].obs;

  List<Event> getEventsForDay(DateTime day) {
    // Implementation example
    return EventsList[day] ?? [];
  }

  void setCurrentIndex(DateTime time) {
    var index = chartClassList.indexWhere((element) =>
        element.ymd.year == time.year &&
        element.ymd.month == time.month &&
        element.ymd.day == time.day);
    print('currentIndex = $currentIndex');
    print('index = $index');
    if (index == -1) {
      currentIndex(0);
    } else {
      currentIndex(index);
    }
  }

  void initTodoList() {
    var initData = Todo(
        title: 'example',
        time: TimeRange(
            startTime: TimeOfDay(hour: 0, minute: 0),
            endTime: TimeOfDay(hour: 3, minute: 30)));
    todoList.add(initData);
  }

  void initDateTodoList() {
    var initData = DateTodo(
        year: DateTime.now().year,
        month: DateTime.now().month,
        day: DateTime.now().day,
        todo: [
          Todo(
            title: 'title',
            time: TimeRange(
              startTime: TimeOfDay(hour: 0, minute: 0),
              endTime: TimeOfDay(hour: 3, minute: 30),
            ),
          ),
        ]);
    todoDateList.add(initData);
  }

  int getDateIndex(YMD dateTime) {
    var index = chartClassList.indexWhere((element) =>
        element.ymd.year == dateTime.year &&
        element.ymd.month == dateTime.month &&
        element.ymd.day == dateTime.day);
    print('index = $index');
    print(chartClassList.length);
    if (index == -1) {
      return index;
    } else {
      return index;
    }
  }

  void addClassChartData(YMD ymd, String title, double value) {
    var index = getDateIndex(ymd);
    if (index == -1) {
      chartClassList.add(ChartDateData(
          ymd: ymd,
          data: [
            ChartDataPercent(
                data: PieChartSectionData(
                    title: title,
                    value: value,
                    color: colorList[Random().nextInt(colorList.length)]))
          ]));
    } else {
      int i = chartClassList[index]
          .data
          .indexWhere((element) => element.data.title == title);
      print('iiiiii = $i');
      if (i != -1) {
        double val = chartClassList[index].data[i].data.value + value;
        print('val = $val');
        Color color = chartClassList[index].data[i].data.color;
        chartClassList[index].data.removeAt(i);

        chartClassList[index].data.add(
              ChartDataPercent(
                data: PieChartSectionData(
                  title: title,
                  value: val,
                  color: color,
                ),
              ),
            );
      } else {
        chartClassList[index].data.add(ChartDataPercent(
            data: PieChartSectionData(
                title: title,
                value: value,
                color: colorList[Random().nextInt(colorList.length)])));
      }
    }
    update();
    refresh();
  }

  void checkTitle(ChartDateData dateData, String text, double value) {
    int index =
        dateData.data.indexWhere((element) => element.data.title == text);
    if (index == -1) {
    } else {}
  }

  void initPercent() {
    for (int i = 0; i < chartClassList.length; i++) {
      setDataPercent(chartClassList[i]);
    }
  }

  void setDataPercent(ChartDateData _data) {
    int sum = 0;
    for (int i = 0; i < _data.data.length; i++) {
      sum += _data.data[i].data.value.toInt();
    }
    for (int i = 0; i < _data.data.length; i++) {
      _data.data[i].percent =
          (_data.data[i].data.value.toInt() / sum * 100).roundToDouble();
    }
  }

  void sortDataPercent(ChartDateData _data){
    _data.data.sort((a, b) => b.percent.compareTo(a.percent));
  }

  void addTodoTitle(String text) {
    bool check = false;
    for (int index = 0; index < todoTitleList.length; index++) {
      if (todoTitleList[index].title == text) {
        check = true;
      }
    }
    if (check) {
      int index = todoTitleList.indexWhere((element) => element.title == text);
      todoTitleList[index].index + 1;
      print('if 실행');
    } else {
      print('else 실행');
      todoTitleList.add(TodoTitle(title: text));
    }
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

  double getTime(DateTime _datetime,TimeRange time) {
    var time1 = DateTime(_datetime.year, _datetime.month,
        _datetime.day, time.startTime.hour, time.startTime.minute);
    var time2 = DateTime(_datetime.year, _datetime.month,
        _datetime.day, time.endTime.hour, time.endTime.minute);
    var result = time2.difference(time1).inMinutes;
    if(result < 0 ){
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
    initTodoList();
    initDateTodoList();
    initPercent();
    // ever(chartClassList, (_) => )
  }
}
