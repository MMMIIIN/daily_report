import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart';

class Todo {
  String title;
  TimeRange time;

  Todo({required this.title, required this.time});
}

class TodoTitle{
  String title;
  int index;
  int titleColor;

  TodoTitle({required this.title, this.index = 0, required this.titleColor});
}
