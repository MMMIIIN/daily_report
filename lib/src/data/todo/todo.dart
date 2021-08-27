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
