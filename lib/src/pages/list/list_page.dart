import 'package:daily_report/color.dart';
import 'package:daily_report/icons.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/chart/controller/chart_controller.dart';
import 'package:daily_report/src/pages/list/add_todo.dart';
import 'package:daily_report/src/pages/list/controller/list_controller.dart';
import 'package:daily_report/src/service/firestore_service.dart';
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

class _ListPageState extends State<ListPage> {
  int touchedIndex = -1;
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  bool isDarkMode = GetStorage().read('isDarkMode') ?? false;
  bool isListPageBool = GetStorage().read('isListPageBool') ?? false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        height: context.mediaQuery.size.height * 0.85,
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
      height: context.mediaQuery.size.height * 0.06,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), border: Border.all()),
      child: TextField(
        onChanged: (text) {
          _listController.searchTerm(text);
          _listController.searchTitle(text);
          if (text.isNotEmpty) {
            _listController.selectedDays.clear();
          }
        },
        cursorColor: Colors.black,
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
              color: Colors.black,
            ),
            suffixIcon: _listController.searchTerm.value != ''
                ? IconButton(
                    splashRadius: 13,
                    icon: Icon(
                      IconsDB.cancle_outlined,
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
            hintStyle: TextStyle(color: Colors.black)),
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
              color: isDarkMode
                  ? Color(0xff95afc0)
                  : context.theme.primaryColor.withOpacity(0.9),
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
                      style: TextStyle(color: Colors.redAccent),
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
                    color: isDarkMode ? Colors.white : markerColor),
              ),
            );
          }
        },
      ),
      rowHeight: 45,
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
    var listCount = _listController.searchTodoList.value.todoList.isEmpty
        ? _listController.searchResult.length
        : _listController.searchTodoList.value.todoList.length;
    print(_listController.searchTodoList.value.todoList.isEmpty);
    return Expanded(
      child: RefreshIndicator(
        color: context.theme.primaryColor,
        onRefresh: () async {
          setState(() {
            Future.delayed(Duration(seconds: 1));
            listCount = _listController.searchTodoList.value.todoList.isEmpty
                ? _listController.searchResult.length
                : _listController.searchTodoList.value.todoList.length;
          });
        },
        child: ListView.builder(
          itemCount: listCount,
          itemBuilder: (context, index) {
            var currentValue = _listController
                    .searchTodoList.value.todoList.isEmpty
                ? _listController.searchResult[index].value
                : _listController.searchTodoList.value.todoList[index].value;
            var currentTimeRange = TimeRange(
                startTime: TimeOfDay(
                    hour: _listController.searchTodoList.value.todoList.isEmpty
                        ? _listController.searchResult[index].startHour
                        : _listController
                            .searchTodoList.value.todoList[index].startHour,
                    minute:
                        _listController.searchTodoList.value.todoList.isEmpty
                            ? _listController.searchResult[index].startMinute
                            : _listController.searchTodoList.value
                                .todoList[index].startMinute),
                endTime: TimeOfDay(
                    hour: _listController.searchTodoList.value.todoList.isEmpty
                        ? _listController.searchResult[index].endHour
                        : _listController
                            .searchTodoList.value.todoList[index].endHour,
                    minute:
                        _listController.searchTodoList.value.todoList.isEmpty
                            ? _listController.searchResult[index].endMinute
                            : _listController.searchTodoList.value
                                .todoList[index].endMinute));
            var currentTitle = _listController
                    .searchTodoList.value.todoList.isEmpty
                ? _listController.searchResult[index].title
                : _listController.searchTodoList.value.todoList[index].title;
            var currentColorIndex =
                _listController.searchTodoList.value.todoList.isEmpty
                    ? _listController.searchResult[index].colorIndex
                    : _listController
                        .searchTodoList.value.todoList[index].colorIndex;
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
            var memoTitle = _listController
                    .searchTodoList.value.todoList.isEmpty
                ? _listController.searchResult[index].memoText
                : _listController.searchTodoList.value.todoList[index].memoText;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                onTap: () {
                  _todoController.setTime(
                    currentTimeRange,
                  );
                  _todoController.initHome(currentDateTime);
                  todoDialog(context, currentTitle, memoTitle, currentDateTime,
                      currentTimeRange, currentColorIndex, todoUid);
                },
                child: Container(
                  width: context.mediaQuery.size.width * 0.8,
                  height: context.mediaQuery.size.height * 0.05,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
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
                                SizedBox(
                                    width:
                                        context.mediaQuery.size.width * 0.03),
                                Text('${currentDateTime.year}.'
                                    '${currentDateTime.month}.'
                                    '${currentDateTime.day}'
                                    ' ${_listController.getOfDay(currentDateTime.weekday)}'),
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
                      isListPageBool
                          ? Container(
                              width: context.mediaQuery.size.width * 0.23,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('${currentValue ~/ 60}시간 '),
                                  currentValue % 60 == 0
                                      ? Text('')
                                      : Text('${currentValue % 60}분')
                                ],
                              ),
                            )
                          : Container(
                              width: context.mediaQuery.size.width * 0.4,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${currentTimeRange.startTime.hour < 12 ? '오전' : '오후'} '
                                    '${currentTimeRange.startTime.hour < 13 ? '${currentTimeRange.startTime.hour < 10 ? '0${currentTimeRange.startTime.hour} : ' : '${currentTimeRange.startTime.hour} : '}' : '${currentTimeRange.startTime.hour - 12 < 10 ? '0${currentTimeRange.startTime.hour - 12}' : '${currentTimeRange.startTime.hour - 12}'} : '}'
                                    '${currentTimeRange.startTime.minute.toString() == '0' ? '00' : currentTimeRange.startTime.minute}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '${currentTimeRange.endTime.hour < 12 ? '오전' : '오후'} '
                                    '${currentTimeRange.endTime.hour < 13 ? '${currentTimeRange.endTime.hour < 10 ? '0${currentTimeRange.endTime.hour} : ' : '${currentTimeRange.endTime.hour} : '}' : '${currentTimeRange.endTime.hour - 12 < 10 ? '0${currentTimeRange.endTime.hour - 12}' : '${currentTimeRange.endTime.hour - 12}'} : '}'
                                    '${currentTimeRange.endTime.minute.toString() == '0' ? '00' : currentTimeRange.endTime.minute}',
                                    style: TextStyle(fontSize: 14),
                                  ),
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
      ),
    );
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
      _listController.searchTerm('');
      if (_listController.selectedDays.isEmpty) {
        _listController.searchTitle('');
      }
    });
  }

  Future<void> todoDialog(
      BuildContext context,
      String title,
      String memoTitle,
      DateTime dateTime,
      TimeRange timeRange,
      int colorIndex,
      String todoUid) async {
    await showDialog(
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
                    width: context.mediaQuery.size.width * 0.4,
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              IconButton(
                  icon: Icon(IconsDB.trash, size: 26),
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
                                color: context.theme.primaryColor,
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text(
                                  '취소',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              MaterialButton(
                                elevation: 0,
                                color: context.theme.primaryColor,
                                onPressed: () async {
                                  _todoController.todoDelete(todoUid);
                                  await todoFirebaseDelete(todoUid)
                                      .then((value) {
                                    _chartController.makeRangeDate();
                                    if (_listController
                                        .searchTerm.value.isEmpty) {
                                      _listController.searchTitle('');
                                    } else if (_listController
                                        .searchTerm.value.isNotEmpty) {
                                      _listController.searchTitle(
                                          _listController.searchTerm.value);
                                    }
                                    if (_listController
                                        .selectedDays.isNotEmpty) {
                                      _listController.setSearchTodoList(
                                          _listController.selectedDays);
                                    }
                                    if (_listController.searchTodoList.value
                                        .todoList.isEmpty) {
                                      _listController.selectedDays.clear();
                                    }
                                    _todoController.setCurrentIndex(
                                        _todoController.currentDateTime.value);
                                  });
                                  Get.back();
                                  Get.back();
                                  await Get.showSnackbar(GetBar(
                                    duration: Duration(seconds: 2),
                                    title: 'SUCCESS',
                                    message: '성공적으로 삭제되었습니다.',
                                    backgroundColor: successColor,
                                  ));
                                },
                                child: Text('삭제',
                                style: TextStyle(
                                  color: Colors.white
                                ),),
                              ),
                            ],
                          );
                        });
                  })
            ],
          ),
          content: Container(
            height: memoTitle.isEmpty
                ? context.mediaQuery.size.height * 0.13
                : context.mediaQuery.size.height * 0.18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${dateTime.year} .'
                  '${dateTime.month} .'
                  '${dateTime.day}'
                  ' ${_listController.getOfDay(dateTime.weekday)}',
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(height: 10),
                memoTitle.isEmpty
                    ? Container()
                    : Text(
                        memoTitle,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 25),
                      ),
                SizedBox(height: 15),
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
              color: context.theme.primaryColor,
              onPressed: () {
                Get.back();
              },
              child: Text(
                '취소',
                style: TextStyle(color: Colors.white),
              ),
            ),
            MaterialButton(
              elevation: 0,
              color: context.theme.primaryColor,
              onPressed: () {
                _todoController.titleTextController.value.text = title;
                _todoController.selectColorIndex(colorIndex);
                _todoController.memoText(memoTitle);
                _todoController.memoController.value.text = memoTitle;
                _todoController.isEditMode(true);
                _todoController.editTodoUid(todoUid);
                _todoController.clickedAddButton(false);
                Get.to(
                  () => AddTodo(),
                );
              },
              child: Text(
                '수정',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
