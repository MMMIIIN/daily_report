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


class ChartDateData {
  YMD ymd;
  PieChart chartSectionData;
  double percent;

  ChartDateData(
      {required this.chartSectionData, required this.ymd, this.percent = 0.0});
}

class TodoController extends GetxController {
  RxInt currentIndex = 0.obs;
  final todoList = <Todo>[].obs;

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
  var titleTextController = TextEditingController().obs;

  var chartClassList = <ChartDateData>[
    ChartDateData(
        chartSectionData: PieChart(PieChartData(sections: [])),
        ymd: YMD(year: 2021, month: 5, day: 1)),
    ChartDateData(
        chartSectionData: PieChart(PieChartData(
            startDegreeOffset: 270,
            sectionsSpace: 4,
            centerSpaceRadius: 40,
            sections: [
              PieChartSectionData(
                  title: 'study', value: 300, color: Colors.orangeAccent),
              PieChartSectionData(
                  title: 'game', value: 500, color: Colors.redAccent),
            ])),
        ymd: YMD(year: 2021, month: 5, day: 16)),
    ChartDateData(
        chartSectionData: PieChart(PieChartData(
            startDegreeOffset: 270,
            sectionsSpace: 4,
            centerSpaceRadius: 40,
            sections: [
              PieChartSectionData(
                  title: 'study', value: 200, color: Colors.greenAccent),
              PieChartSectionData(
                  title: 'game', value: 500, color: Colors.purpleAccent),
            ])),
        ymd: YMD(year: 2021, month: 5, day: 25))
  ].obs;
  RxInt allSum = 0.obs;

  // Rx<DateTime> focusedDay = DateTime.now().obs;
  //
  // Rx<DateTime> selectedDay = now.obs;

  List<Event> getEventsForDay(DateTime day) {
    // Implementation example
    return EventsList[day] ?? [];
  }

  void setCurrentIndex(DateTime time) {
    var index =
        chartClassList.indexWhere((element) => element.ymd.day == time.day);
    print(index);
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
          chartSectionData: PieChart(PieChartData(
              startDegreeOffset: 270,
              sectionsSpace: 4,
              centerSpaceRadius: 40,
              sections: [
                PieChartSectionData(
                    title: title,
                    value: value,
                    color: colorList[Random().nextInt(colorList.length)])
              ])),
          ymd: ymd));
    } else {
      chartClassList[index].chartSectionData.data.sections.add(
          PieChartSectionData(
              title: title,
              value: value,
              color: colorList[Random().nextInt(colorList.length)]));
    }
  }

  // void setPercent() {
  //   for (int i = 0; i < chartClassList.length; i++) {
  //     chartClassList[i].percent =
  //         getPercent(chartClassList[currentIndex.value].chartSectionData.data.sections[i].value.toInt());
  //   }
  // }
  //
  // double getPercent(int num) {
  //   totalSum();
  //   allSum.toInt() / num * 100;
  //   print(allSum.toInt() / num * 100);
  //   return (num / allSum.toInt() * 100).roundToDouble();
  // }
  //
  // void totalSum(int index) {
  //   int sum = 0;
  //   print('length = ${chartClassList[index].chartSectionData.data.sections.length}');
  //   for (int i = 0; i < chartClassList[index].chartSectionData.data.sections.length; i++) {
  //     sum += chartClassList[index].chartSectionData.data.sections[i].value.toInt();
  //   }
  //   print(sum);
  //   allSum(sum);
  //   print('allSum = $allSum');
  // }

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

  void sortChartList() {
    chartClassList.sort((a, b) => b.percent.compareTo(a.percent));
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
    initDateTodoList();
    // initChartList();
    // ever(todoDateList, (_) => getEventsForDay);
  }
}
