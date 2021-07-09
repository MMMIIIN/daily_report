import 'package:daily_report/color.dart';
import 'package:daily_report/src/data/todo/todo.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/list/add_todo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListPage extends StatelessWidget {
  final TodoController _todoController = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(15),
        width: double.infinity,
        height: Get.mediaQuery.size.height * 0.85,
        color: Colors.transparent,
        child: showListView(),
      ),
    );
  }

  Widget showListView() {
    return ListView.builder(
      itemCount: _todoController.todoUidList.value.todoList.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: InkWell(
          customBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(10),
            height: Get.mediaQuery.size.height * 0.08,
            decoration: BoxDecoration(
                color: colorList[_todoController
                    .todoUidList.value.todoList[index].colorIndex],
                borderRadius: BorderRadius.circular(15),
                border: Border.all()),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                    '${_todoController.todoUidList.value.todoList[index].year}.'
                    '${_todoController.todoUidList.value.todoList[index].month}.'
                    '${_todoController.todoUidList.value.todoList[index].day}'),
                Text(_todoController.todoUidList.value.todoList[index].title),
                SizedBox(width: 10),
                Row(
                  children: [
                    Text(
                        '${_todoController.todoUidList.value.todoList[index].startHour} : '
                        '${_todoController.todoUidList.value.todoList[index].startMinute}'),
                    SizedBox(width: 20),
                    Text(
                        '${_todoController.todoUidList.value.todoList[index].endHour} : '
                        '${_todoController.todoUidList.value.todoList[index].endMinute}')
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
