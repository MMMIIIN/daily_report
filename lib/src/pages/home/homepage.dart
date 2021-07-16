import 'package:daily_report/color.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/list/add_todo.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        // _todoController.setCurrentIndex(_selectedDay);
        _todoController.setCurrentIndex(_selectedDay);
        _todoController.currentDateTime(_selectedDay);
        print('todoDateTime ${_todoController.currentDateTime.value}');
      });
    }
  }

  Widget showCalendar() {
    return Obx(
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
          ),
        ),
        firstDay: FirstDay,
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
        // eventLoader: _todoController.getEventsForDay,
        eventLoader: (day) {
          for (int i = 0;
              i < _todoController.loadTodoUidList.value.todoList.length;
              i++) {
            if (day.year ==
                    _todoController
                        .loadTodoUidList.value.todoList[i].ymd.year &&
                day.month ==
                    _todoController
                        .loadTodoUidList.value.todoList[i].ymd.month &&
                day.day ==
                    _todoController.loadTodoUidList.value.todoList[i].ymd.day) {
              return [Event('')];
            }
          }
          return [];
        },
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
    );
  }

  Widget showChart() {
    return GetBuilder<TodoController>(
      init: TodoController(),
      builder: (_) => Flexible(
        flex: 3,
        child: _todoController.currentIndexList.isNotEmpty
            ? PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                    setState(() {
                      final desiredTouch =
                          pieTouchResponse.touchInput is! PointerExitEvent &&
                              pieTouchResponse.touchInput is! PointerUpEvent;
                      if (desiredTouch &&
                          pieTouchResponse.touchedSection != null) {
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      } else {
                        touchedIndex = -1;
                      }
                    });
                  }),
                  startDegreeOffset: 270,
                  sectionsSpace: 4,
                  centerSpaceRadius: 40,
                  sections: List<PieChartSectionData>.generate(
                      _todoController.currentIndexList.length, (index) {
                    final isTouched = index == touchedIndex;
                    final radius = isTouched ? 70.0 : 50.0;
                    final title = isTouched
                        ? _todoController
                            .currentUidList.value.todoList[index].title
                        : '';
                    return PieChartSectionData(
                      title: title,
                      color: colorList[_todoController
                          .currentUidList.value.todoList[index].colorIndex],
                      value: _todoController
                          .currentUidList.value.todoList[index].value
                          .toDouble(),
                      radius: radius,
                    );
                  }),
                ),
              )
            : Container(),
      ),
    );
  }

  Widget showChartList() {
    return GetBuilder<TodoController>(
      // init: TodoController(),
      builder: (_) => Flexible(
          flex: 1,
          child: _todoController.currentIndexList.isNotEmpty
              ? GridView.builder(
                  itemCount: _todoController.currentIndexList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorList[_todoController.currentUidList
                                    .value.todoList[index].colorIndex]),
                          ),
                          SizedBox(width: 4),
                          Row(
                            children: [
                              Text(
                                _todoController
                                    .currentUidList.value.todoList[index].title,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                ' ${_todoController.currentUidList.value.todoList[index].percent.roundToDouble()} %',
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
    );
  }

  Widget showAddIcon() {
    return Positioned(
      bottom: 110,
      right: 30,
      child: FloatingActionButton(
        elevation: 2,
        backgroundColor: Color(0xff34495e),
        onPressed: () {
          Get.to(
              AddTodo(
                uid: FirebaseAuth.instance.currentUser!.uid,
                year: _selectedDay.year,
                month: _selectedDay.month,
                day: _selectedDay.day,
              ),
              transition: Transition.fadeIn);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                showCalendar(),
                showChart(),
                showChartList(),
              ],
            ),
            showAddIcon(),
          ],
        ),
      ),
    );
  }
}
