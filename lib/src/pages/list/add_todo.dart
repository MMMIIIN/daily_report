import 'package:daily_report/src/data/todo/todo.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/chart/controller/chart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_range_picker/time_range_picker.dart';

class AddTodo extends StatelessWidget {
  final TodoController _todoController = Get.put(TodoController());
  // final ChartController _chartController = Get.put(ChartController());

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Container(
            height: Get.mediaQuery.size.height * 0.8,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), border: Border.all()),
            child: Column(
              children: [
                Expanded(
                  // flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: TextField(
                      controller: _todoController.titleTextController.value,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          hintText: 'Title'),
                    ),
                  ),
                ),
                Expanded(
                  // flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: setTime(context),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          Get.back();
                        },
                        color: Colors.white,
                        child: Text('CANCLE'),
                      ),
                      MaterialButton(
                        onPressed: () {
                          _todoController.todoList.add(Todo(
                            time: TimeRange(
                              startTime:
                                  _todoController.defaultTime.value.startTime,
                              endTime:
                                  _todoController.defaultTime.value.endTime,
                            ),
                            title:
                                _todoController.titleTextController.value.text,
                          ));
                          _todoController.sortTodoList();
                          _todoController.addClassChartData(_todoController.titleTextController.value.text, _todoController.getTime(_todoController.defaultTime.value));
                          _todoController.setPercent();
                          _todoController.sortChartList();
                          Get.back();
                        },
                        color: Colors.white,
                        child: Text('ADD'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget setTime(BuildContext context) {
    return Obx(
      () => InkWell(
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onTap: () async {
          TimeRange result = await showTimeRangePicker(
            context: context,
            clockRotation: 180,
            paintingStyle: PaintingStyle.fill,
            // backgroundColor: Colors.grey.withOpacity(0.2),
            backgroundColor: Colors.yellow[100],
            labels: ['0', '3', '6', '9', '12', '15', '18', '21']
                .asMap()
                .entries
                .map((e) {
              return ClockLabel.fromIndex(idx: e.key, length: 8, text: e.value);
            }).toList(),
            snap: true,
            start: TimeOfDay(hour: 10, minute: 0),
            end: TimeOfDay(hour: 13, minute: 0),
            ticks: 24,
            handlerRadius: 8,
            strokeColor: Colors.orangeAccent[200],
            ticksColor: Theme.of(context).primaryColor,
            labelOffset: 30,
            rotateLabels: false,
            padding: 60,
          );
          _todoController.setTime(result);
          // controller.listeners;
          // controller.change(result);
        },
        child: Container(
          height: Get.mediaQuery.size.height * 0.1,
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  SizedBox(width: 20),
                  Text(
                      '${_todoController.defaultTime.value.startTime.hour} : '),
                  Text('${_todoController.defaultTime.value.startTime.minute}'),
                  // Text('${Get.parameters['title']}')
                ],
              ),
              Row(
                children: [
                  Text('${_todoController.defaultTime.value.endTime.hour} : '),
                  Text('${_todoController.defaultTime.value.endTime.minute}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
