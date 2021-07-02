// To parse this JSON data, do
//
//     final chartDateData = chartDateDataFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

TestChartDateData chartDateDataFromJson(String str) =>
    TestChartDateData.fromJson(json.decode(str));

String chartDateDataToJson(TestChartDateData data) =>
    json.encode(data.toJson());

class TestChartDateData {
  TestChartDateData({
    required this.ymd,
    required this.data,
  });

  TestYmd ymd;
  List<TestChartDataPercent> data;

  factory TestChartDateData.fromJson(Map<String, dynamic> json) =>
      TestChartDateData(
        ymd: TestYmd.fromJson(json['ymd']),
        data: List<TestChartDataPercent>.from(
            json['data'].map((x) => TestChartDataPercent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ymd": ymd.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class TestChartDataPercent {
  TestChartDataPercent({
    required this.percent,
    required this.chartSectionData,
    required this.timeRange,
    // required this.category,
  });

  double percent;
  TestChartSectionData chartSectionData;
  TestTimeRange timeRange;

  // String category;

  factory TestChartDataPercent.fromJson(Map<String, dynamic> json) =>
      TestChartDataPercent(
        percent: json["percent"],
        chartSectionData:
            TestChartSectionData.fromJson(json["ChartSectionData"]),
        timeRange: TestTimeRange.fromJson(json["TimeRange"]),
        // category: json["CATEGORY"],
      );

  Map<String, dynamic> toJson() => {
        "percent": percent,
        "ChartSectionData": chartSectionData.toJson(),
        "TimeRange": timeRange.toJson(),
        // "CATEGORY": category,
      };
}

class TestChartSectionData {
  TestChartSectionData({
    required this.title,
    required this.value,
    required this.color,
  });

  String title;
  int value;
  Color color;

  factory TestChartSectionData.fromJson(Map<String, dynamic> json) =>
      TestChartSectionData(
        title: json["title"],
        value: json["value"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
        "color": color,
      };
}

class TestTimeRange {
  TestTimeRange({
    required this.startTime,
    required this.endTime,
  });

  TestTime startTime;
  TestTime endTime;

  factory TestTimeRange.fromJson(Map<String, dynamic> json) => TestTimeRange(
        startTime: TestTime.fromJson(json["startTime"]),
        endTime: TestTime.fromJson(json["endTime"]),
      );

  Map<String, dynamic> toJson() => {
        "startTime": startTime.toJson(),
        "endTime": endTime.toJson(),
      };
}

class TestTime {
  TestTime({
    required this.hour,
    required this.minute,
  });

  int hour;
  int minute;

  factory TestTime.fromJson(Map<String, dynamic> json) => TestTime(
        hour: json["hour"],
        minute: json["minute"],
      );

  Map<String, dynamic> toJson() => {
        "hour": hour,
        "minute": minute,
      };
}

class TestYmd {
  TestYmd({
    required this.year,
    required this.month,
    required this.day,
  });

  int year;
  int month;
  int day;

  factory TestYmd.fromJson(Map<String, dynamic> json) => TestYmd(
        year: json["year"],
        month: json["month"],
        day: json["day"],
      );

  Map<String, dynamic> toJson() => {
        "year": year,
        "month": month,
        "day": day,
      };
}

class TestTodo {
  // final List<TestTodoList> todoList;

  TestTodo(
      {required this.uid,
      required this.year,
      required this.month,
      required this.day,
      required this.title,
      required this.startHour,
      required this.startMinute,
      required this.endHour,
      required this.endMinute,
      required this.value,
      required this.colorIndex});

  String uid;
  int year;
  int month;
  int day;
  String title;
  int startHour;
  int startMinute;
  int endHour;
  int endMinute;
  int value;
  int colorIndex;

  factory TestTodo.fromJson(Map<String, dynamic> json) => TestTodo(
      uid: json["uid"],
      year: json["year"],
      month: json["month"],
      day: json["day"],
      title: json["title"],
      startHour: json["startHour"],
      startMinute: json["startMinute"],
      endHour: json["endHour"],
      endMinute: json["endMinute"],
      value: json["value"],
      colorIndex: json["color"]);

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "year": year,
        "month": month,
        "day": day,
        "title": title,
        "startHour": startHour,
        "startMinute": startMinute,
        "endHour": endHour,
        "endMinute": endMinute,
        "value": value,
        "color": colorIndex
      };
}

class TodoUidList {
  final List<TestTodo> todoList;

  TodoUidList({required this.todoList});

  factory TodoUidList.fromJson(List<dynamic> json) {
    List<TestTodo> todoList1;
    todoList1 = json.map((e) => TestTodo.fromJson(e)).toList();

    return new TodoUidList(todoList: todoList1);
  }
}
