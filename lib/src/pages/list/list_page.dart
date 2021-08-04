import 'package:daily_report/color.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/list/add_todo.dart';
import 'package:daily_report/src/pages/list/controller/list_controller.dart';
import 'package:daily_report/src/pages/list/todo_info_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_range_picker/time_range_picker.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

final TodoController _todoController = Get.put(TodoController());
final ListController _listController = Get.put(ListController());
final bool isDarkMode = GetStorage().read('isDarkMode');

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
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: primaryColor.withOpacity(0.4)),
      child: TextField(
        onChanged: (text) {
          _listController.searchTerm(text);
          _listController.searchTitle(text);
          if (text.isNotEmpty) {
            _listController.selectedDays.clear();
          }
        },
        controller: _listController.searchTitleController.value,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: primaryColor,
            ),
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
            hintText: '검색',
            hintStyle: TextStyle(color: primaryColor)),
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
              color: isDarkMode ? Colors.grey : primaryColor,
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
        markerBuilder: (context, date, _) {
          if (_.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isDarkMode ? Colors.white : Colors.black87),
              ),
            );
          }
        },
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
                if (day.year == todo.ymd.year &&
                    day.month == todo.ymd.month &&
                    day.day == todo.ymd.day) {
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
              _todoController.titleTextController.value.text = _listController
                      .searchTodoList.value.todoList.isEmpty
                  ? _listController.searchResult[index].title
                  : _listController.searchTodoList.value.todoList[index].title;
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
              // Get.to(AddTodo(
              //   editMode: true,
              // ));
              Get.to(
                () => TodoInfoPage(
                  title: _listController.searchTodoList.value.todoList.isEmpty
                      ? _listController.searchResult[index].title
                      : _listController
                          .searchTodoList.value.todoList[index].title,
                  timeRange: TimeRange(
                    startTime: TimeOfDay(
                        hour: _listController
                                .searchTodoList.value.todoList.isEmpty
                            ? _listController.searchResult[index].startHour
                            : _listController
                                .searchTodoList.value.todoList[index].startHour,
                        minute: _listController
                                .searchTodoList.value.todoList.isEmpty
                            ? _listController.searchResult[index].startMinute
                            : _listController.searchTodoList.value
                                .todoList[index].startMinute),
                    endTime: TimeOfDay(
                        hour: _listController
                                .searchTodoList.value.todoList.isEmpty
                            ? _listController.searchResult[index].endHour
                            : _listController
                                .searchTodoList.value.todoList[index].endHour,
                        minute: _listController
                                .searchTodoList.value.todoList.isEmpty
                            ? _listController.searchResult[index].endMinute
                            : _listController.searchTodoList.value
                                .todoList[index].endMinute),
                  ),
                  colorIndex:
                      _listController.searchTodoList.value.todoList.isEmpty
                          ? _listController.searchResult[index].colorIndex
                          : _listController
                              .searchTodoList.value.todoList[index].colorIndex,
                  todoUid: _listController.searchTodoList.value.todoList.isEmpty
                      ? _listController.searchResult[index].uid
                      : _listController
                          .searchTodoList.value.todoList[index].uid,
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(10),
              width: Get.mediaQuery.size.width * 0.8,
              height: Get.mediaQuery.size.height * 0.08,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
                // border: Border.all(),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: _listController
                                .searchTodoList.value.todoList.isEmpty
                            ? colorList[
                                _listController.searchResult[index].colorIndex]
                            : colorList[_listController.searchTodoList.value
                                .todoList[index].colorIndex]),
                  ),
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
      if (_listController.selectedDays.isEmpty) {
        _listController.searchTitle('');
      }
    });
  }
}
