import 'package:time_range_picker/time_range_picker.dart';

class Todo {
  String title;
  TimeRange time;

  Todo({required this.title, required this.time});
}

class TodoTitle{
  String title;
  int titleColor;
  String uid;

  TodoTitle({required this.title, this.uid = 'null', required this.titleColor});
}
