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
        child: Stack(
      children: [
        Container(
          padding: EdgeInsets.all(15),
          width: double.infinity,
          height: Get.mediaQuery.size.height * 0.85,
          color: Colors.transparent,
          child: showListView(),
        ),
        Positioned(
            bottom: 30,
            right: 30,
            child: FloatingActionButton(
              elevation: 2,
              backgroundColor: Color(0xff686de0),
              onPressed: () {
                Get.to(AddTodo(), transition: Transition.fadeIn);
                // final date1 = DateTime(DateTime.now().year,DateTime.now().month, DateTime.now().day, _todoController.todoList[1].time.startTime.hour, _todoController.todoList[1].time.startTime.minute);
                // final date2 = DateTime(DateTime.now().year,DateTime.now().month, DateTime.now().day, _todoController.todoList[1].time.endTime.hour, _todoController.todoList[1].time.endTime.minute);
                // print(date1);
                // print(date2);
                // final date3 = DateTime(2021,5,21,20,35);
                // print(date3);
                //
                // print(date2.difference(date1).inMinutes);
                // print(double.parse(date2.difference(date1).inMinutes.toString()));
              },
              child: Icon(Icons.add),
            ),
        ),
      ],
    ));
  }

  Widget showListView() {
    return ListView.builder(
      itemCount: _todoController.todoList.length,
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
                borderRadius: BorderRadius.circular(15),
                border: Border.all()),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(_todoController.todoList[index].title),
                SizedBox(width: 10),
                Row(
                  children: [
                    Text('${_todoController.todoList[index].time.startTime.hour} : '),
                    Text(_todoController.todoList[index].time.startTime.minute.toString()),
                    SizedBox(width: 20),
                    Text('${_todoController.todoList[index].time.endTime.hour} : '),
                    Text(_todoController.todoList[index].time.endTime.minute.toString())
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
