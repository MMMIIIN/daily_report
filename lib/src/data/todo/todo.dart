import 'package:time_range_picker/time_range_picker.dart';

class Todo {
  String title;
  TimeRange time;

  Todo({required this.title, required this.time});
}

class DateTodo {
  int year;
  int month;
  int day;
  List<Todo> todo;

  DateTodo({
    this.year = 2021,
    this.month = 5,
    this.day = 23,
    required this.todo
  });
}
