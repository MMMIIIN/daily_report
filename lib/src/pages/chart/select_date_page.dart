import 'package:daily_report/color.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/chart/controller/chart_controller.dart';
import 'package:daily_report/src/pages/chart/controller/select_date_controller.dart';
import 'package:daily_report/src/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:table_calendar/table_calendar.dart';

final SelectDateController _selectDateController =
    Get.put(SelectDateController());
final ChartController _chartController = Get.put(ChartController());
final TodoController _todoController = Get.put(TodoController());

class SelectDatePage extends StatefulWidget {
  @override
  _SelectDatePageState createState() => _SelectDatePageState();
}

class _SelectDatePageState extends State<SelectDatePage> {
  DateTime? _rangeStart = DateTime.now();
  DateTime? _rangeEnd = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  var rangeSelectionMode = RangeSelectionMode.toggledOn;

  Widget tableCalendar() {
    return TableCalendar(
      calendarBuilders: CalendarBuilders(
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
                style: TextStyle(color: Colors.redAccent),
              )
                  : Text(date.day.toString())
            ],
          ),
        ),
        rangeStartBuilder: (context, date, _) => Container(
          margin: const EdgeInsets.all(4),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: context.theme.primaryColor,
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
        rangeEndBuilder: (context, date, _) => Container(
          margin: const EdgeInsets.all(4),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: context.theme.primaryColor,
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
        rangeHighlightBuilder: (context, date, _) => Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Container(
            margin: EdgeInsetsDirectional.only(
                start: date == _rangeStart ? 10 : 0.0,
                end: date == _rangeEnd ? 10 : 0.0),
            decoration: BoxDecoration(
              color: _ ? context.theme.primaryColor.withOpacity(0.8) : null,
            ),
          ),
        ),
        withinRangeBuilder: (context, date, _) => Container(
          margin: const EdgeInsets.all(4),
          alignment: Alignment.center,
          child: Text(
            date.day.toString(),
            style: TextStyle(color: Colors.white),
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
                    color: Colors.black87),
              ),
            );
          }
        },
      ),
      firstDay: FirstDay,
      lastDay: LastDay,
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      rangeStartDay: _rangeStart,
      rangeEndDay: _rangeEnd,
      calendarFormat: _calendarFormat,
      rangeSelectionMode: rangeSelectionMode,
      locale: 'ko-KR',
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle(color: Colors.red),
      ),
      calendarStyle: CalendarStyle(
        weekendTextStyle: TextStyle(color: Colors.red),
      ),
      headerStyle: HeaderStyle(titleCentered: true, formatButtonVisible: false),
      eventLoader: (day) {
        for (var todo in _todoController.todoUidList.value.todoList) {
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
        _selectDateController.setRangeTime(
            _rangeStart ?? DateTime.now(), _rangeEnd ?? DateTime.now());
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
    );
  }

  Widget twoButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MaterialButton(
            onPressed: () {
              Get.offAll(() => Home(), transition: Transition.leftToRight);
            },
            elevation: 0,
            color: context.theme.primaryColor,
            child: Text(
              '취소',
              style: TextStyle(color: Colors.white),
            )),
        MaterialButton(
          onPressed: () {
            if (_selectDateController.rangeBool.value) {
              _chartController.makeRangeDate();
              Get.offAll(() => Home(), transition: Transition.leftToRight);
            }
          },
          elevation: 0,
          color: _selectDateController.rangeBool.value
              ? context.theme.primaryColor
              : context.theme.primaryColor.withOpacity(0.4),
          child: Text(
            '확인',
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Obx(
          () => Column(
            children: [
              tableCalendar(),
              twoButton(),
            ],
          ),
        ),
      ),
    );
  }
}
