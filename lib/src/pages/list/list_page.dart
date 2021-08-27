import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_report/color.dart';
import 'package:daily_report/icons.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/chart/controller/chart_controller.dart';
import 'package:daily_report/src/pages/list/add_todo.dart';
import 'package:daily_report/src/pages/list/controller/list_controller.dart';
import 'package:daily_report/src/pages/settings/controller/settings_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
final ChartController _chartController = Get.put(ChartController());
final SettingsController _settingsController = Get.put(SettingsController());

class _ListPageState extends State<ListPage> {
  int touchedIndex = -1;
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  final bool isDarkMode = GetStorage().read('isDarkMode');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(10),
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
      height: Get.mediaQuery.size.height * 0.06,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: isDarkMode
            ? Colors.white.withOpacity(0.9)
            : primaryColor.withOpacity(0.1),
      ),
      child: TextField(
        onChanged: (text) {
          _listController.searchTerm(text);
          _listController.searchTitle(text);
          if (text.isNotEmpty) {
            _listController.selectedDays.clear();
          }
        },
        cursorColor: primaryColor,
        style: TextStyle(color: primaryColor),
        controller: _listController.searchTitleController.value,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
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
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _listController.searchTerm('');
                      _listController.searchTitle('');
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
              color: isDarkMode ? darkSelectColor : primaryColor,
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
              color: isDarkMode ? darkTodayColor : Color(0xff95afc0),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Text(
                'today',
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
              date.weekday == 6 || date.weekday == 7
                  ? Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.red),
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
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle(color: Colors.red),
      ),
      calendarFormat: _calendarFormat,
      calendarStyle: CalendarStyle(
        weekendTextStyle: TextStyle(color: Colors.red),
        holidayTextStyle: TextStyle(color: Colors.blue),
      ),
      daysOfWeekVisible: true,
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
      ),
      locale: 'ko-KR',
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
    );
  }

  Widget showListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: _listController.searchTodoList.value.todoList.isEmpty
            ? _listController.searchResult.length
            : _listController.searchTodoList.value.todoList.length,
        itemBuilder: (context, index) {
          var currentHourMinute = _listController
                  .searchTodoList.value.todoList.isEmpty
              ? _listController.searchResult[index].hourMinute
              : _listController.searchTodoList.value.todoList[index].hourMinute;
          var currentValue =
              _listController.searchTodoList.value.todoList.isEmpty
                  ? _listController.searchResult[index].value
                  : _listController.searchTodoList.value.todoList[index].value;
          var currentTimeRange = TimeRange(
              startTime: TimeOfDay(
                  hour: _listController.searchTodoList.value.todoList.isEmpty
                      ? _listController.searchResult[index].startHour
                      : _listController
                          .searchTodoList.value.todoList[index].startHour,
                  minute: _listController.searchTodoList.value.todoList.isEmpty
                      ? _listController.searchResult[index].startMinute
                      : _listController
                          .searchTodoList.value.todoList[index].startMinute),
              endTime: TimeOfDay(
                  hour: _listController.searchTodoList.value.todoList.isEmpty
                      ? _listController.searchResult[index].endHour
                      : _listController
                          .searchTodoList.value.todoList[index].endHour,
                  minute: _listController.searchTodoList.value.todoList.isEmpty
                      ? _listController.searchResult[index].endMinute
                      : _listController
                          .searchTodoList.value.todoList[index].endMinute));
          var currentTitle =
              _listController.searchTodoList.value.todoList.isEmpty
                  ? _listController.searchResult[index].title
                  : _listController.searchTodoList.value.todoList[index].title;
          var currentColorIndex = _listController
                  .searchTodoList.value.todoList.isEmpty
              ? _listController.searchResult[index].colorIndex
              : _listController.searchTodoList.value.todoList[index].colorIndex;
          var currentDateTime = DateTime(
              _listController.searchTodoList.value.todoList.isEmpty
                  ? _listController.searchResult[index].ymd.year
                  : _listController
                      .searchTodoList.value.todoList[index].ymd.year,
              _listController.searchTodoList.value.todoList.isEmpty
                  ? _listController.searchResult[index].ymd.month
                  : _listController
                      .searchTodoList.value.todoList[index].ymd.month,
              _listController.searchTodoList.value.todoList.isEmpty
                  ? _listController.searchResult[index].ymd.day
                  : _listController
                      .searchTodoList.value.todoList[index].ymd.day);
          var todoUid = _listController.searchTodoList.value.todoList.isEmpty
              ? _listController.searchResult[index].uid
              : _listController.searchTodoList.value.todoList[index].uid;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              onTap: () {
                _todoController.setTime(
                  currentTimeRange,
                );
                _todoController.currentDateTime(currentDateTime);
                todoDialog(context, currentTitle, currentDateTime,
                    currentTimeRange, currentColorIndex, todoUid);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: Get.mediaQuery.size.width * 0.8,
                height: Get.mediaQuery.size.height * 0.05,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      // color: Colors.greenAccent,
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: colorList[currentColorIndex]),
                              ),
                              SizedBox(width: Get.mediaQuery.size.width * 0.03),
                              Text('${currentDateTime.year}.'
                                  '${currentDateTime.month}.'
                                  '${currentDateTime.day}'
                                  ' ${getOfDay(currentDateTime.weekday)}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          currentTitle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    _settingsController.listPageIndex.value == 0
                        ? Container(
                            width: Get.mediaQuery.size.width * 0.3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '${currentTimeRange.startTime.hour.toString().length < 2 ? '0${currentTimeRange.startTime.hour} : ' : '${currentTimeRange.startTime.hour} : '}'
                                  '${currentTimeRange.startTime.minute.toString() == '0' ? '00' : currentTimeRange.startTime.minute}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(width: 20),
                                Text(
                                    '${currentTimeRange.endTime.hour.toString().length < 2 ? '0${currentTimeRange.endTime.hour} : ' : '${currentTimeRange.endTime.hour} : '}'
                                    '${currentTimeRange.endTime.minute.toString() == '0' ? '00' : currentTimeRange.endTime.minute}',
                                    style: TextStyle(fontSize: 14))
                              ],
                            ),
                          )
                        : Container(
                            width: Get.mediaQuery.size.width * 0.2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${currentValue ~/ 60}시간 '),
                                currentValue & 60 != 0
                                    ? Text('')
                                    : Text('${currentValue % 60}분')
                              ],
                            ),
                          )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String getOfDay(int weekday) {
    switch (weekday) {
      case 1:
        return '(월)';
      case 2:
        return '(화)';
      case 3:
        return '(수)';
      case 4:
        return '(목)';
      case 5:
        return '(금)';
      case 6:
        return '(토)';
      case 7:
        return '(일)';
      default:
        return '';
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
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

  void todoDialog(BuildContext context, String title, DateTime dateTime,
      TimeRange timeRange, int colorIndex, String todoUid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        print('todoUid = $todoUid');
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorList[colorIndex],
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: Get.mediaQuery.size.width * 0.4,
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              IconButton(
                  icon: Icon(IconsDB.trash, size: 22),
                  splashRadius: 20,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('삭제 하시겠습니까?'),
                            actions: [
                              MaterialButton(
                                elevation: 0.0,
                                color: primaryColor.withOpacity(0.4),
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text('취소'),
                              ),
                              MaterialButton(
                                color: primaryColor,
                                onPressed: () {
                                  todoFirebaseDelete(todoUid);
                                  todoDelete(todoUid);
                                  _chartController.makeRangeDate();
                                  _listController.setSearchTodoList(
                                      _listController.selectedDays);
                                  if (_listController
                                      .searchTodoList.value.todoList.isEmpty) {
                                    _listController.selectedDays.clear();
                                  }
                                  _todoController.setCurrentIndex(
                                      _todoController.currentDateTime.value);
                                },
                                child: Text('삭제'),
                              ),
                            ],
                          );
                        });
                  })
            ],
          ),
          content: Container(
            height: Get.mediaQuery.size.height * 0.1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${dateTime.year} .'
                  '${dateTime.month} .'
                  '${dateTime.day}'
                  ' ${getOfDay(dateTime.weekday)}',
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  '${timeRange.startTime.hour} : '
                  '${timeRange.startTime.minute} - '
                  '${timeRange.endTime.hour} : '
                  '${timeRange.endTime.minute}',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          actions: [
            MaterialButton(
              elevation: 0.0,
              color: primaryColor.withOpacity(0.4),
              onPressed: () {
                Get.back();
              },
              child: Text('취소'),
            ),
            MaterialButton(
              elevation: 0,
              color: primaryColor,
              onPressed: () {
                _todoController.titleTextController.value.text = title;
                _todoController.selectColorIndex(colorIndex);
                Get.off(() => AddTodo(
                      editMode: true,
                      todoUid: todoUid,
                    ));
              },
              child: Text('수정'),
            ),
          ],
        );
      },
    );
  }

  void todoFirebaseDelete(String todoUid) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('todos')
        .doc(todoUid)
        .delete()
        .then((value) {
      Get.back();
      Get.back();
      _chartController.makeRangeDate();
      Get.showSnackbar(GetBar(
        duration: Duration(seconds: 2),
        title: 'SUCCESS',
        message: '성공적으로 삭제되었습니다.',
        backgroundColor: successColor,
      ));
    }).catchError(
      (error) async => await Get.showSnackbar(
        GetBar(
          title: 'DELETE',
          message: 'ERROR!',
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: errorColor,
        ),
      ),
    );
  }

  void todoDelete(String todoUid) {
    _todoController.loadTodoUidList.value.todoList
        .removeWhere((element) => element.uid == todoUid);
    _todoController.todoUidList.value.todoList.clear();
    _todoController.loadTodoUidList.value.todoList.forEach((element) {
      _todoController.todoUidCheckAdd(element);
    });
  }
}
