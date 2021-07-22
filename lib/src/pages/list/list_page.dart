import 'package:daily_report/color.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/list/add_todo.dart';
import 'package:daily_report/src/pages/list/controller/list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_range_picker/time_range_picker.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

final TodoController _todoController = Get.put(TodoController());
final ListController _listController = Get.put(ListController());

class _ListPageState extends State<ListPage> {
  int touchedIndex = -1;
  DateTime _focusedDay = _todoController.currentDateTime.value;
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
            borderRadius: BorderRadius.circular(15), color: Colors.black12),
        child: TextField(
          onChanged: (text) {
            _listController.searchTerm(text);
            _listController.searchTitle(text);
            if(text.isNotEmpty){
              _listController.selectedDays.clear();
            }
          },
          controller: _listController.searchTitleController.value,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              suffixIcon: _listController.searchTerm.value != ''
                  ? IconButton(
                      icon: Icon(
                        Icons.cancel_outlined,
                        size: 20,
                      ),
                      onPressed: () {
                        _listController.searchTerm('');
                        _listController.searchTitleController.value.clear();
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
      selectedDayPredicate: (day) {
        return _listController.selectedDays.contains(day);
      },
      calendarFormat: _calendarFormat,
      calendarStyle: CalendarStyle(
        weekendTextStyle: TextStyle(color: Colors.red),
        holidayTextStyle: TextStyle(color: Colors.blue),
      ),
      eventLoader: _listController.searchTerm.isEmpty
          ? (day) {
              for (var todo in _todoController.loadTodoUidList.value.todoList) {
                if (day == todo.ymd) {
                  return [Container()];
                }
              }
              return [];
            }
          : (day) {
              for (var todo in _listController.searchTodoList.value.todoList) {
                if (day == todo.ymd) {
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
    return Expanded(
      child: ListView.builder(
        itemCount: _listController.searchTodoList.value.todoList.isEmpty
            ? _listController.searchResult.length
            : _listController.searchTodoList.value.todoList.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            customBorder:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            onTap: () {
              _todoController.titleTextController.value.text =
                  _listController.searchResult[index].title;
              _todoController.setTime(
                TimeRange(
                  startTime: TimeOfDay(
                      hour:
                          _listController.searchTodoList.value.todoList.isEmpty
                              ? _listController.searchResult[index].startHour
                              : _listController.searchTodoList.value
                                  .todoList[index].startHour,
                      minute:
                          _listController.searchTodoList.value.todoList.isEmpty
                              ? _listController.searchResult[index].startMinute
                              : _listController.searchTodoList.value
                                  .todoList[index].startMinute),
                  endTime: TimeOfDay(
                      hour:
                          _listController.searchTodoList.value.todoList.isEmpty
                              ? _listController.searchResult[index].endHour
                              : _listController
                                  .searchTodoList.value.todoList[index].endHour,
                      minute:
                          _listController.searchTodoList.value.todoList.isEmpty
                              ? _listController.searchResult[index].endMinute
                              : _listController.searchTodoList.value
                                  .todoList[index].endMinute),
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
                  color: _listController.searchTodoList.value.todoList.isEmpty
                      ? colorList[
                          _listController.searchResult[index].colorIndex]
                      : colorList[_listController
                          .searchTodoList.value.todoList[index].colorIndex],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all()),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                      '${_listController.searchTodoList.value.todoList.isEmpty ? _listController.searchResult[index].ymd.year : _listController.searchTodoList.value.todoList[index].ymd.year}.'
                      '${_listController.searchTodoList.value.todoList.isEmpty ? _listController.searchResult[index].ymd.month : _listController.searchTodoList.value.todoList[index].ymd.month}.'
                      '${_listController.searchTodoList.value.todoList.isEmpty ? _listController.searchResult[index].ymd.day : _listController.searchTodoList.value.todoList[index].ymd.day}'),
                  Text(_listController.searchTodoList.value.todoList.isEmpty
                      ? _listController.searchResult[index].title
                      : _listController
                          .searchTodoList.value.todoList[index].title),
                  SizedBox(width: 10),
                  Row(
                    children: [
                      Text(
                          '${_listController.searchTodoList.value.todoList.isEmpty ? _listController.searchResult[index].startHour : _listController.searchTodoList.value.todoList[index].startHour} : '
                          '${_listController.searchTodoList.value.todoList.isEmpty ? _listController.searchResult[index].startMinute : _listController.searchTodoList.value.todoList[index].startMinute}'),
                      SizedBox(width: 20),
                      Text(
                          '${_listController.searchTodoList.value.todoList.isEmpty ? _listController.searchResult[index].endHour : _listController.searchTodoList.value.todoList[index].endHour} : '
                          '${_listController.searchTodoList.value.todoList.isEmpty ? _listController.searchResult[index].endMinute : _listController.searchTodoList.value.todoList[index].endMinute}')
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
    setState(() {
      _focusedDay = focusedDay;
      if (_listController.selectedDays.contains(selectedDay)) {
        _listController.selectedDays.remove(selectedDay);
      } else {
        _listController.selectedDays.add(selectedDay);
      }
      _listController.setSearchTodoList(_listController.selectedDays);
      _listController.searchTitleController.value.clear();
      if(_listController.selectedDays.isEmpty){
        _listController.searchTitle('');
      }
    });
  }
}
