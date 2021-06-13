import 'package:daily_report/src/data/todo/todo.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/app.dart';
import 'package:daily_report/src/pages/home/homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_range_picker/time_range_picker.dart';

class AddTodo extends StatelessWidget {
  final TodoController _todoController = Get.put(TodoController());
  int? year;
  int? month;
  int? day;

  AddTodo({this.year, this.month, this.day});

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
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
                Flexible(child: printTodo()),
                Flexible(
                  flex: 1,
                  child: Row(
                    children: [
                      Text(year.toString()),
                      Text(month.toString()),
                      Text(day.toString()),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
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
                          _todoController.todoDateList.add(
                            DateTodo(
                                year: year ?? 0,
                                month: month ?? 0,
                                day: day ?? 0,
                                todo: [
                                  Todo(
                                    title: _todoController
                                        .titleTextController.value.text,
                                    time: TimeRange(
                                      startTime: _todoController
                                          .defaultTime.value.startTime,
                                      endTime: _todoController
                                          .defaultTime.value.endTime,
                                    ),
                                  ),
                                ]),
                          );
                          _todoController.addClassChartData(
                              YMD(
                                  year: year ?? 0,
                                  month: month ?? 0,
                                  day: day ?? 0),
                              _todoController.titleTextController.value.text,
                              _todoController.getTime(
                                  _todoController.currentDateTime.value,
                                  _todoController.defaultTime.value));
                          EventsList.addAll({
                            DateTime.utc(year ?? 0, month ?? 0, day ?? 0): [
                              Event('title')
                            ]
                          });
                          _todoController.setDataPercent(
                              _todoController.chartClassList[
                                  _todoController.currentIndex.value]);
                          // Get.back();
                          _todoController.todoList.add(Todo(
                              title: _todoController
                                  .titleTextController.value.text,
                              time: _todoController.defaultTime.value));

                          _todoController.addTodoTitle(
                              _todoController.titleTextController.value.text);
                          _todoController.sortDataPercent(_todoController.chartClassList[_todoController.currentIndex.value]);

                          _todoController.titleTextController.value.clear();
                          // Get.toNamed('/');
                          // print(_todoController.defaultTime.value);
                          // Get.off(App());
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
            interval: Duration(minutes: 10),
            labels: ['0', '3', '6', '9', '12', '15', '18', '21']
                .asMap()
                .entries
                .map((e) {
              return ClockLabel.fromIndex(idx: e.key, length: 8, text: e.value);
            }).toList(),
            snap: true,
            start: TimeOfDay(
                hour: _todoController.defaultTime.value.endTime.hour,
                minute: _todoController.defaultTime.value.endTime.minute),
            end: TimeOfDay(
                hour: (_todoController.defaultTime.value.endTime.hour + 2) > 24 ? 0 : _todoController.defaultTime.value.endTime.hour + 2,
                minute: _todoController.defaultTime.value.endTime.minute),
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
                  // Text('${_todoController.chartClassList[_todoController.currentIndex.value].data.last.timeRange.startTime.hour} : '),
                  // Text('${_todoController.chartClassList[_todoController.currentIndex.value].data.last.timeRange.startTime.minute}')

                ],
              ),
              Row(
                children: [
                  Text('${_todoController.defaultTime.value.endTime.hour} : '),
                  Text('${_todoController.defaultTime.value.endTime.minute}'),
                  // Text('${_todoController.chartClassList[_todoController.currentIndex.value].data.last.timeRange.endTime.hour} : '),
                  // Text('${_todoController.chartClassList[_todoController.currentIndex.value].data.last.timeRange.endTime.minute}')

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget printTodo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 50,
            mainAxisExtent: 30,
          ),
          itemCount: _todoController.todoTitleList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                // _todoController.titleTextController.value.text(_todoController.defaultText);
                _todoController.titleTextController.value.text =
                    _todoController.todoTitleList[index].title;
              },
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(15)),
                child: Text('${_todoController.todoTitleList[index].title}'),
              ),
            );
          }),
    );
  }
}
