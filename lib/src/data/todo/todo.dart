import 'package:time_range_picker/time_range_picker.dart';

class Todo {
  String title;
  TimeRange time;

  Todo({required this.title, required this.time});
}

class TodoTitle {
  String uid;
  String title;
  int titleColor;
  TimeRange? timeRange;
  bool boolOfTime;

  TodoTitle(
      {required this.title,
      this.uid = 'null',
      required this.titleColor,
      this.timeRange,
      this.boolOfTime = false});
}

class TestTodo {
  TestTodo(
      {required this.uid,
        required this.ymd,
        required this.title,
        required this.startHour,
        required this.startMinute,
        required this.endHour,
        required this.endMinute,
        required this.value,
        required this.colorIndex,
        this.percent = 0.0,
        this.hourMinute = '',
        this.memoText = ''
      });

  String uid;
  DateTime ymd;
  String title;
  int startHour;
  int startMinute;
  int endHour;
  int endMinute;
  int value;
  int colorIndex;
  double percent;
  String hourMinute;
  String memoText;
}

class TodoUidList {
  final List<TestTodo> todoList;

  TodoUidList({required this.todoList});
}

