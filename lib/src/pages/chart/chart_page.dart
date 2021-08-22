import 'package:daily_report/color.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/chart/controller/chart_controller.dart';
import 'package:daily_report/src/pages/chart/controller/select_date_controller.dart';
import 'package:daily_report/src/pages/chart/select_date_page.dart';
import 'package:daily_report/src/pages/home.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toggle_switch/toggle_switch.dart';

final TodoController _todoController = Get.put(TodoController());
final ChartController _chartController = Get.put(ChartController());
final SelectDateController _selectDateController =
    Get.put(SelectDateController());

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final bool isDarkMode = GetStorage().read('isDarkMode');
  var now = DateTime.now();
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Obx(
          () => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  selectDateTime(),
                  toggleButton(),
                ],
              ),
              showChart(),
              chartList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget toggleButton() {
    return ToggleSwitch(
      minWidth: 40,
      minHeight: 30,
      totalSwitches: 2,
      initialLabelIndex: _chartController.modeIndex.value,
      labels: ['%', 'h'],
      inactiveBgColor: isDarkMode ? primaryColor : Color(0xffecf0f1),
      activeBgColor: [isDarkMode ? Color(0xffecf0f1) : primaryColor],
      onToggle: (index) {
        _chartController.setMode(index);
      },
    );
  }

  Widget selectDateTime() {
    return InkWell(
      customBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onTap: () {
        Get.to(() => SelectDatePage());
      },
      child: Container(
        width: Get.mediaQuery.size.width * 0.6,
        height: 50,
        decoration: BoxDecoration(
            border: Border.all(
                color: isDarkMode ? darkPrimaryColor : Color(0xff34495e)),
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${_selectDateController.rangeStart.value.year} - '
                '${_selectDateController.rangeStart.value.month} - '
                '${_selectDateController.rangeStart.value.day} ~ '
                '${_selectDateController.rangeEnd.value.year} - '
                '${_selectDateController.rangeEnd.value.month} - '
                '${_selectDateController.rangeEnd.value.day}')
          ],
        ),
      ),
    );
  }

  void selectDateDialog() {
    var _selectedDay;
    DateTime? _rangeStart = _selectDateController.defaultRangeStart.value;
    DateTime? _rangeEnd = _selectDateController.defaultRangeEnd.value;
    var _focusedDay = DateTime.now();
    var _calendarFormat = CalendarFormat.month;
    var rangeSelectionMode = RangeSelectionMode.toggledOn;
    showDialog(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 120),
          child: Obx(
            () => Dialog(
              child: Column(
                children: [
                  TableCalendar(
                    calendarBuilders: CalendarBuilders(
                      selectedBuilder: (context, date, _) => Container(
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
                      todayBuilder: (context, date, _) => Container(
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
                      rangeStartBuilder: (context, date, _) => Container(
                        margin: const EdgeInsets.all(4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      rangeEndBuilder: (context, date, _) => Container(
                        margin: const EdgeInsets.all(4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      rangeHighlightBuilder: (context, date, _) => Container(
                        decoration: BoxDecoration(
                          color: _ ? Color(0xff95afc0) : null,
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
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black87),
                            ),
                          );
                        }
                      },
                    ),
                    firstDay: FirstDay,
                    lastDay: LastDay,
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    rangeStartDay:
                        _selectDateController.defaultRangeStart.value,
                    rangeEndDay: _selectDateController.defaultRangeEnd.value,
                    calendarFormat: _calendarFormat,
                    rangeSelectionMode: rangeSelectionMode,
                    eventLoader: (day) {
                      for (var todo
                          in _todoController.todoUidList.value.todoList) {
                        if (day.year == todo.ymd.year &&
                            day.month == todo.ymd.month &&
                            day.day == todo.ymd.day) {
                          return [Container()];
                        }
                      }
                      return [];
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                          _rangeStart = null; // Important to clean those
                          _rangeEnd = null;
                          rangeSelectionMode = RangeSelectionMode.toggledOff;
                        });
                      }
                    },
                    onRangeSelected: (start, end, focusedDay) {
                      setState(() {
                        _selectedDay = null;
                        _focusedDay = focusedDay;
                        _rangeStart = start;
                        _rangeEnd = end;
                        rangeSelectionMode = RangeSelectionMode.toggledOn;
                      });
                      _selectDateController.setDefaultRangeTime(
                          _rangeStart ?? DateTime.now(),
                          _rangeEnd ?? _rangeStart!);
                    },
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          Get.back();
                        },
                        color: primaryColor,
                        child: Text(
                          '취소',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          _selectDateController.setRangeTime(
                              _rangeStart!, _rangeEnd!);
                          _chartController.makeRangeDate();
                          Get.offAll(Home());
                        },
                        color: primaryColor,
                        child:
                            Text('확인', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget showChart() {
    return GetBuilder<ChartController>(
      init: ChartController(),
      builder: (_) => Flexible(
        flex: 3,
        child: _chartController.checkChartPageList.value.todoList.isNotEmpty
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
                  centerSpaceRadius: 130,
                  sections: List<PieChartSectionData>.generate(
                    _chartController.checkChartPageList.value.todoList.length,
                    (index) {
                      final isTouched = index == touchedIndex;
                      final radius = isTouched ? 70.0 : 50.0;
                      final title = isTouched
                          ? _chartController
                              .checkChartPageList.value.todoList[index].title
                          : '';
                      return PieChartSectionData(
                        title: title,
                        radius: radius,
                        value: _chartController
                            .checkChartPageList.value.todoList[index].value
                            .toDouble(),
                        color: colorList[_chartController.checkChartPageList
                            .value.todoList[index].colorIndex],
                      );
                    },
                  ),
                ),
              )
            : Container(),
      ),
    );
  }

  Widget chartList() {
    return _chartController.checkChartPageList.value.todoList.isNotEmpty
        ? Flexible(
            flex: 1,
            child: GridView.builder(
              itemCount:
                  _chartController.checkChartPageList.value.todoList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 50,
                mainAxisExtent: 30,
              ),
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorList[_chartController.checkChartPageList
                                .value.todoList[index].colorIndex]),
                      ),
                      SizedBox(width: 4),
                      Row(
                        children: [
                          Text(
                            '${_chartController.checkChartPageList.value.todoList[index].title}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          _chartController.modeIndex.value == 0
                              ? Text(
                                  ' ${_chartController.checkChartPageList.value.todoList[index].percent.toStringAsFixed(1)} %',
                                  style: TextStyle(fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                )
                              : Text(
                                  ' ${_chartController.checkChartPageList.value.todoList[index].hourMinute}')
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container();
  }
}
