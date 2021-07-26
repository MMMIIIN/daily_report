import 'package:daily_report/color.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/chart/controller/chart_controller.dart';
import 'package:daily_report/src/pages/chart/controller/select_date_controller.dart';
import 'package:daily_report/src/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              )),
      firstDay: FirstDay,
      lastDay: LastDay,
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      rangeStartDay: _rangeStart,
      rangeEndDay: _rangeEnd,
      calendarFormat: _calendarFormat,
      rangeSelectionMode: rangeSelectionMode,
      eventLoader: (day) {
        for (var todo in _todoController.loadTodoUidList.value.todoList) {
          if (day == todo.ymd) {
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
              Get.off(() => Home(), transition: Transition.leftToRightWithFade);
            },
            color: Color(0xff95afc0),
            child: Text(
              '취소',
              style: TextStyle(color: Colors.white),
            )),
        MaterialButton(
          onPressed: () {
            if (_selectDateController.rangeBool.value) {
              _chartController.makeDateRange(
                  _selectDateController.rangeStart.value,
                  _selectDateController.rangeEnd.value);
              Get.off(() => Home());
            }
          },
          color: _selectDateController.rangeBool.value
              ? primaryColor
              : Color(0xffecf0f1),
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
