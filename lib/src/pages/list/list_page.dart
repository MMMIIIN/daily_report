import 'package:daily_report/color.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/list/add_todo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_range_picker/time_range_picker.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

final TodoController _todoController = Get.put(TodoController());

class _ListPageState extends State<ListPage> {
  int touchedIndex = -1;
  DateTime _focusedDay = _todoController.currentDateTime.value;
  DateTime _selectedDay = _todoController.currentDateTime.value;
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(15),
        width: double.infinity,
        height: Get.mediaQuery.size.height * 0.85,
        color: Colors.transparent,
        child: Obx(
          () => Column(
            children: [
              searchWidget(),
              showCalendar(),
              Divider(
                height: 30.0,
              ),
              showListView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            // border: Border.all()
            color: Colors.black12),
        child: TextField(
          onChanged: (text) {
            _todoController.searchTerm(text);
          },
          controller: _todoController.searchTitleController.value,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              suffixIcon: _todoController.searchTerm.value != ''
                  ? IconButton(
                      icon: Icon(
                        Icons.cancel_outlined,
                        size: 20,
                      ),
                      onPressed: () {
                        _todoController.searchTerm('');
                        _todoController.searchTitleController.value.clear();
                      },
                    )
                  : null,
              hintText: '검색'),
        ),
      ),
    );
  }

  Widget showCalendar() {
    return TableCalendar(
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
      focusedDay: _todoController.currentDateTime.value,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      calendarFormat: _calendarFormat,
      calendarStyle: CalendarStyle(
        weekendTextStyle: TextStyle(color: Colors.red),
        holidayTextStyle: TextStyle(color: Colors.blue),
      ),
      eventLoader: (day) {
        for (var todo in _todoController.searchTodoList.value.todoList) {
          if(day == todo.ymd){
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
    );
  }

  Widget showListView() {
    final searchResult =
        _todoController.searchTitle(_todoController.searchTerm.value);
    return Expanded(
      child: ListView.builder(
        itemCount: _todoController.searchTodoList.value.todoList.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            customBorder:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            onTap: () {
              _todoController.titleTextController.value.text =
                  searchResult[index].title;
              _todoController.setTime(
                TimeRange(
                  startTime: TimeOfDay(
                      hour: searchResult[index].startHour,
                      minute: searchResult[index].startMinute),
                  endTime: TimeOfDay(
                      hour: searchResult[index].endHour,
                      minute: searchResult[index].endMinute),
                ),
              );
              Get.to(AddTodo(
                editMode: true,
              ));
            },
            child: Container(
              padding: EdgeInsets.all(10),
              height: Get.mediaQuery.size.height * 0.08,
              decoration: BoxDecoration(
                  color: colorList[searchResult[index].colorIndex],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all()),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('${searchResult[index].ymd.year}.'
                      '${searchResult[index].ymd.month}.'
                      '${searchResult[index].ymd.day}'),
                  Text(searchResult[index].title),
                  SizedBox(width: 10),
                  Row(
                    children: [
                      Text('${searchResult[index].startHour} : '
                          '${searchResult[index].startMinute}'),
                      SizedBox(width: 20),
                      Text('${searchResult[index].endHour} : '
                          '${searchResult[index].endMinute}')
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _todoController.currentDateTime(selectedDay);
        _todoController.setCurrentIndex(_selectedDay);
        _todoController.currentDateTime(_selectedDay);
        _todoController.setSearchList();
      });
    }
  }
}
