import 'package:daily_report/color.dart';
import 'package:daily_report/src/pages/list/add_todo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_range_picker/time_range_picker.dart';

class TodoInfoPage extends StatelessWidget {
  final String title;
  final TimeRange timeRange;
  final int colorIndex;
  final String todoUid;

  const TodoInfoPage(
      {Key? key,
      required this.title,
      required this.timeRange,
      required this.colorIndex,
      required this.todoUid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(child: SafeArea(child: Column(
      children: [
        Text('title = $title'),
        Text('${timeRange.startTime.hour} : '
        '${timeRange.startTime.minute} - '
        '${timeRange.endTime.hour} : '
        '${timeRange.endTime.minute}'),
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorList[colorIndex]
          ),
        ),
        Text(todoUid),
        MaterialButton(onPressed: () {
          Get.to(() => AddTodo(
            todoUid: todoUid,
            editMode: true,
          ));
        },
        color: Colors.redAccent,)
      ],
    )));
  }
}
