import 'dart:collection';

import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/list/add_todo.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

final TodoController _todoController = Get.put(TodoController());

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

final now = DateTime.now();
final FirstDay = DateTime(2020, 1, 1);
final LastDay = DateTime(now.year + 5, 12, 31);

final kMINEventSource = {
  for (var item
      in List.generate(_todoController.chartClassList.length, (index) => index))
    DateTime.utc(
            _todoController.chartClassList[item].ymd.year,
            _todoController.chartClassList[item].ymd.month,
            _todoController.chartClassList[item].ymd.day):
        List.generate(1, (index) => Event('title'))
};

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int touchedIndex = -1;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _focusedDay = _todoController.currentDateTime.value;

  // DateTime _selectedDay = now;
  DateTime _selectedDay = _todoController.currentDateTime.value;

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _todoController.currentDateTime(selectedDay);
        print('_selectedDay = $_selectedDay');
        print('_focusedDay = $_focusedDay');
        _todoController.setCurrentIndex(_selectedDay);
        _todoController.currentDateTime(_selectedDay);
        print('todoDateTime ${_todoController.currentDateTime.value}');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Obx(
                  () => TableCalendar(
                    calendarBuilders: CalendarBuilders(
                        selectedBuilder: (context, date, events) => Container(
                              margin: const EdgeInsets.all(4),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                        todayBuilder: (context, date, events) => Container(
                              margin: const EdgeInsets.all(4),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Color(0xff95afc0),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            )),

                    firstDay: DateTime(_todoController.todoDateList[1].year,
                        _todoController.todoDateList[1].month - 3, 1),
                    // firstDay: FirstDay,
                    lastDay: LastDay,
                    // focusedDay: _focusedDay,
                    focusedDay: _todoController.currentDateTime.value,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    calendarFormat: _calendarFormat,
                    calendarStyle: CalendarStyle(
                      // outsideDaysVisible: false,
                      weekendTextStyle: TextStyle(color: Colors.red),
                      holidayTextStyle: TextStyle(color: Colors.blue),
                    ),
                    eventLoader: _todoController.getEventsForDay,
                    // locale: 'ko-KR',
                    onDaySelected: _onDaySelected,
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      // _focusedDay = focusedDay;
                      _todoController.currentDateTime(focusedDay);
                    },
                  ),
                ),
                GetBuilder<TodoController>(
                  init: TodoController(),
                  builder: (_) => Flexible(
                    flex: 3,
                    child:
                        // _todoController.chartClassList.isNotEmpty
                        _.currentIndex.value != 0
                            ? PieChart(
                                PieChartData(
                                  pieTouchData: PieTouchData(
                                      touchCallback: (pieTouchResponse) {
                                    setState(() {
                                      final desiredTouch =
                                          pieTouchResponse.touchInput
                                                  is! PointerExitEvent &&
                                              pieTouchResponse.touchInput
                                                  is! PointerUpEvent;
                                      if (desiredTouch &&
                                          pieTouchResponse.touchedSection !=
                                              null) {
                                        touchedIndex = pieTouchResponse
                                            .touchedSection!
                                            .touchedSectionIndex;
                                      } else {
                                        touchedIndex = -1;
                                      }
                                      // print(touchedIndex);
                                    });
                                  }),
                                  startDegreeOffset: 270,
                                  sectionsSpace: 4,
                                  centerSpaceRadius: 40,
                                  sections: List<PieChartSectionData>.generate(
                                      _.chartClassList[_.currentIndex.value]
                                          .data.length, (index) {
                                    final isTouched = index == touchedIndex;
                                    final radius = isTouched ? 70.0 : 50.0;
                                    final title = isTouched
                                        ? _.chartClassList[_.currentIndex.value]
                                            .data[index].data.title
                                        : '';
                                    return PieChartSectionData(
                                      title: title,
                                      color: _
                                          .chartClassList[_.currentIndex.value]
                                          .data[index]
                                          .data
                                          .color,
                                      value: _
                                          .chartClassList[_.currentIndex.value]
                                          .data[index]
                                          .data
                                          .value,
                                      radius: radius,
                                    );
                                  }),
                                ),
                              )
                            : Container(),
                  ),
                ),
                GetBuilder<TodoController>(
                  // init: TodoController(),
                  builder: (_) => Flexible(
                      flex: 1,
                      child: _.currentIndex.value != 0
                          ? GridView.builder(
                              itemCount: _.chartClassList[_.currentIndex.value]
                                  .data.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 50,
                                mainAxisExtent: 30,
                                // mainAxisSpacing: 5,
                              ),
                              itemBuilder: (context, index) => Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _
                                                .chartClassList[
                                                    _.currentIndex.value]
                                                .data[index]
                                                .data
                                                .color),
                                      ),
                                      SizedBox(width: 4),
                                      Row(
                                        children: [
                                          Text(
                                            _
                                                .chartClassList[
                                                    _.currentIndex.value]
                                                .data[index]
                                                .data
                                                .title,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            ' ${_.chartClassList[_.currentIndex.value].data[index].percent} %',
                                            style: TextStyle(fontSize: 13),
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        ],
                                      ),
                                      // Text(_todoController.chartClassList[index].chartSectionData.value.toString()),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container()),
                )
              ],
            ),
            Positioned(
              bottom: 110,
              right: 30,
              child: FloatingActionButton(
                elevation: 2,
                backgroundColor: Color(0xff686de0).withOpacity(0.8),
                onPressed: () {
                  Get.to(
                      AddTodo(
                        year: _selectedDay.year,
                        month: _selectedDay.month,
                        day: _selectedDay.day,
                      ),
                      transition: Transition.fadeIn);
                },
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
