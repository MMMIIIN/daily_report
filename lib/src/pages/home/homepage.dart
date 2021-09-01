import 'package:daily_report/color.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/settings/controller/settings_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:table_calendar/table_calendar.dart';

final TodoController _todoController = Get.put(TodoController());
final SettingsController _settingsController = Get.put(SettingsController());

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int touchedIndex = -1;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = _todoController.currentDateTime.value;
  bool isDarkMode = GetStorage().read('isDarkMode');

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _todoController.setCurrentIndex(_selectedDay);
        _todoController.currentDateTime(_selectedDay);
        _todoController.selectDateTime(_selectedDay);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          children: [
            showCalendar(),
            showChart(),
            showChartList(),
          ],
        ),
      ),
    );
  }

  Widget showCalendar() {
    return Obx(
      () => TableCalendar(
        calendarBuilders: CalendarBuilders(
          selectedBuilder: (context, date, events) => Container(
            margin: const EdgeInsets.all(4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: isDarkMode
                    ? Color(0xff95afc0)
                    : primaryColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10)),
            child: date.year == DateTime.now().year &&
                    date.month == DateTime.now().month &&
                    date.day == DateTime.now().day
                ? Column(
                    children: [
                      Text(
                        'today',
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                      date.weekday == 6 || date.weekday == 7
                          ? Text(
                              date.day.toString(),
                              style: TextStyle(color: Colors.redAccent),
                            )
                          : Text(
                              date.day.toString(),
                              style: TextStyle(color: Colors.white),
                            )
                    ],
                  )
                : date.weekday == 6 || date.weekday == 7
                    ? Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.redAccent),
                      )
                    : Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
          ),
          todayBuilder: (context, date, events) => Container(
            margin: const EdgeInsets.all(4),
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  'today',
                  style: TextStyle(fontSize: 10, color: Colors.red),
                ),
                date.weekday == 6 || date.weekday == 7
                    ? Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.white),
                      )
                    : Text(date.day.toString())
              ],
            ),
          ),
          markerBuilder: (context, date, _) {
            if (_.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isDarkMode ? Colors.white : Color(0xff212529)),
                ),
              );
            }
          },
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        locale: 'ko-KR',
        firstDay: FirstDay,
        lastDay: LastDay,
        focusedDay: _todoController.currentDateTime.value,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: _calendarFormat,
        daysOfWeekStyle: DaysOfWeekStyle(
          weekendStyle: TextStyle(color: Colors.red),
        ),
        calendarStyle: CalendarStyle(
          weekendTextStyle: TextStyle(color: Colors.red),
          holidayTextStyle: TextStyle(color: Colors.blue),
        ),
        eventLoader: (day) {
          for (var todo in _todoController.loadTodoUidList.value.todoList) {
            if (day.year == todo.ymd.year &&
                day.month == todo.ymd.month &&
                day.day == todo.ymd.day) {
              return [Container()];
            }
          }
          return [];
        },
        onDaySelected: _onDaySelected,
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
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
                  centerSpaceRadius: 60,
                  sections: List<PieChartSectionData>.generate(
                      _todoController.currentIndexList.length, (index) {
                    final isTouched = index == touchedIndex;
                    final radius = isTouched ? 80.0 : 60.0;
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
      builder: (_) => Flexible(
          flex: 1,
          child: _todoController.currentIndexList.isNotEmpty
              ? GridView.builder(
                  itemCount: _todoController.currentIndexList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 50,
                    mainAxisExtent: 30,
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
                              _settingsController.isPercentOrHourIndex.value ==
                                      0
                                  ? Text(
                                      ' ${_todoController.currentUidList.value.todoList[index].percent.toStringAsFixed(1)} %',
                                      style: TextStyle(fontSize: 13),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : Text(
                                      ' ${_todoController.currentUidList.value.todoList[index].hourMinute}')
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container()),
    );
  }
}
