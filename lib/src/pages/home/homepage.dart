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

// final kEvents = LinkedHashMap<DateTime, List<Event>>(
//   equals: isSameDay,
//   hashCode: getHashCode,
// )..addAll(kMINEventSource);
// ..addAll(_kEventSource);

// final _kEventSource = {
//   for (var item
//       in List.generate(_todoController.todoList.length, (index) => index))
//     DateTime.utc(
//             // 2021,5,21)
//             _todoController.todoDateList[item].year,
//             _todoController.todoDateList[item].month,
//             _todoController.todoDateList[item].day):
//         List.generate(_todoController.todoDateList[item].todo.length,
//             (index) => Event('Event $item | ${index + 1}'))
// }..addAll({
//     DateTime(2021, 5, 25): [
//       // Event('Today\'s Event 1'),
//       Event('Today\'s Event 2'),
//     ],
//   });

final kMINEventSource = {
  for (var item
      in List.generate(_todoController.todoDateList.length, (index) => index))
    DateTime.utc(
            _todoController.todoDateList[item].year,
            _todoController.todoDateList[item].month,
            _todoController.todoDateList[item].day):
        List.generate(_todoController.todoDateList[item].todo.length,
            (index) => Event('title'))
};

// final kEventSource = Map.fromIterable(
//     List.generate(_todoController.todoDateList.length, (index) => index),
//     key: (item) => DateTime.utc(
//         _todoController.todoDateList[item].year,
//         _todoController.todoDateList[item].month,
//         _todoController.todoDateList[item].day),
//     value: (item) => List.generate(_todoController.todoDateList[item].todo.length, (index) => Event('title')))
//   ..addAll({
//     DateTime.now(): [
//       Event('Today\'s Event 1'),
//       Event('Today\'s Event 2'),
//     ],
//   });

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

  DateTime _focusedDay = DateTime.now();

  DateTime _selectedDay = now;

  // int currentIndex = _todoController.chartClassList.indexWhere((element) => element.ymd.day == _selectedDay.day);

  // List<Event> _getEventsForDay(DateTime day) {
  //   // Implementation example
  //   return kEvents[day] ?? [];
  // }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        print(_selectedDay);
        print(_focusedDay);
        _todoController.setCurrentIndex(_selectedDay);
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
                    focusedDay: _focusedDay,
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
                      _focusedDay = focusedDay;
                    },
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Obx(
                    () => _todoController.chartClassList.isNotEmpty
                        ? PieChart(
                            PieChartData(
                              pieTouchData: PieTouchData(
                                  touchCallback: (pieTouchResponse) {
                                setState(() {
                                  final desiredTouch = pieTouchResponse
                                          .touchInput is! PointerExitEvent &&
                                      pieTouchResponse.touchInput
                                          is! PointerUpEvent;
                                  if (desiredTouch &&
                                      pieTouchResponse.touchedSection != null) {
                                    touchedIndex = pieTouchResponse
                                        .touchedSection!.touchedSectionIndex;
                                  } else {
                                    touchedIndex = -1;
                                  }
                                  print(touchedIndex);
                                });
                              }),
                              startDegreeOffset: 270,
                              sectionsSpace: 4,
                              centerSpaceRadius: 40,
                              sections: List<PieChartSectionData>.generate(
                                  _todoController
                                      .chartClassList[
                                          _todoController.currentIndex.value]
                                      .chartSectionData
                                      .data
                                      .sections
                                      .length, (index) {
                                final isTouched = index == touchedIndex;
                                final radius = isTouched ? 70.0 : 50.0;
                                final title = isTouched
                                    ? _todoController
                                        .chartClassList[
                                            _todoController.currentIndex.value]
                                        .chartSectionData
                                        .data
                                        .sections[index]
                                        .title
                                    : '';
                                return PieChartSectionData(
                                  title: title,
                                  color: _todoController
                                      .chartClassList[
                                          _todoController.currentIndex.value]
                                      .chartSectionData
                                      .data
                                      .sections[index]
                                      .color,
                                  value: _todoController
                                      .chartClassList[
                                          _todoController.currentIndex.value]
                                      .chartSectionData
                                      .data
                                      .sections[index]
                                      .value,
                                  radius: radius,
                                );
                              }),
                            ),
                          )
                        : Container(),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: GridView.builder(
                    itemCount: _todoController.chartClassList[_todoController.currentIndex.value].chartSectionData.data.sections.length,
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
                              color: _todoController.chartClassList[_todoController.currentIndex.value]
                                  .chartSectionData.data.sections[index].color),
                            ),
                            SizedBox(width: 4),
                            Row(
                              children: [
                                Text(
                                  _todoController
                                      .chartClassList[_todoController.currentIndex.value].chartSectionData.data.sections[index].title,
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  ' ${_todoController.chartClassList[index].percent} %',
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
                )

              ],
            ),
            Positioned(
              bottom: 30,
              right: 30,
              child: FloatingActionButton(
                elevation: 2,
                backgroundColor: Color(0xff686de0),
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
