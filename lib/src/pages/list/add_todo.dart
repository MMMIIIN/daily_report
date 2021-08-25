import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_report/color.dart';
import 'package:daily_report/src/data/todo/chart_date_data.dart';
import 'package:daily_report/src/data/todo/todo.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/chart/controller/chart_controller.dart';
import 'package:daily_report/src/pages/home.dart';
import 'package:daily_report/src/pages/list/controller/list_controller.dart';
import 'package:daily_report/src/pages/settings/controller/settings_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_range_picker/time_range_picker.dart';

class AddTodo extends StatefulWidget {
  String? todoUid;
  bool? editMode;

  AddTodo({this.editMode = false, this.todoUid});

  @override
  _AddTodoState createState() => _AddTodoState();
}

final ChartController _chartController = Get.put(ChartController());
final TodoController _todoController = Get.put(TodoController());
final ListController _listController = Get.put(ListController());
final SettingsController _settingsController = Get.put(SettingsController());

class _AddTodoState extends State<AddTodo> {
  bool isDarkMode = GetStorage().read('isDarkMode');
  final currentDay = DateTime(
      _todoController.currentDateTime.value.year,
      _todoController.currentDateTime.value.month,
      _todoController.currentDateTime.value.day);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Container(
            height: Get.mediaQuery.size.height * 0.85,
            width: Get.mediaQuery.size.width * 0.99,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  color: isDarkMode ? darkPrimaryColor : primaryColor),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                selectOfDate(),
                titleField(),
                Obx(() => Flexible(fit: FlexFit.tight, child: printTodo())),
                makeRule(),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Obx(
                          () => Expanded(
                            child: setTime(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                colorSelect(),
                actionButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget selectOfDate() {
    return GestureDetector(
      onTap: () {
        var _selectedDay = _todoController.selectDateTime.value;
        showDialog(
          context: context,
          builder: (_) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 120),
            child: Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 15),
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TableCalendar(
                        calendarBuilders: CalendarBuilders(
                          selectedBuilder: (context, date, events) => Container(
                            margin: const EdgeInsets.all(4),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: isDarkMode
                                    ? darkPrimaryColor
                                    : primaryColor,
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
                                color: isDarkMode
                                    ? darkTodayColor
                                    : Color(0xff95afc0),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                Text(
                                  'today',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.white),
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
                            if (isDarkMode && _.isNotEmpty) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white),
                                ),
                              );
                            }
                          },
                        ),
                        headerStyle: HeaderStyle(
                            formatButtonVisible: false, titleCentered: true),
                        locale: 'ko-KR',
                        firstDay: FirstDay,
                        lastDay: LastDay,
                        focusedDay: _todoController.selectDateTime.value,
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekendStyle: TextStyle(color: Colors.red),
                        ),
                        calendarStyle: CalendarStyle(
                          weekendTextStyle: TextStyle(color: Colors.red),
                        ),
                        eventLoader: (day) {
                          for (var todo in _todoController
                              .loadTodoUidList.value.todoList) {
                            if (day.year == todo.ymd.year &&
                                day.month == todo.ymd.month &&
                                day.day == todo.ymd.day) {
                              return [Container()];
                            }
                          }
                          return [];
                        },
                        onDaySelected:
                            (DateTime selectedDay, DateTime focusedDay) {
                          setState(() {
                            if (!isSameDay(_selectedDay, selectedDay)) {
                              _selectedDay = selectedDay;
                              _todoController.selectDateTime(_selectedDay);
                            }
                          });
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            Get.back();
                            _todoController.selectDateTime(
                                _todoController.currentDateTime.value);
                          },
                          color: primaryColor.withOpacity(0.5),
                          elevation: 0,
                          child: Text(
                            '취 소',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            _todoController.currentDateTime(
                                _todoController.selectDateTime.value);
                            Get.back();
                          },
                          color: primaryColor,
                          child: Text(
                            '확 인',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Obx(
          () => Container(
            width: Get.mediaQuery.size.width * 0.4,
            height: 30,
            decoration: BoxDecoration(
              color:
                  isDarkMode ? darkPrimaryColor.withOpacity(0.9) : primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${_todoController.currentDateTime.value.year} .'
                  '${_todoController.currentDateTime.value.month} .'
                  '${_todoController.currentDateTime.value.day}',
                  style: TextStyle(
                      fontSize: 20,
                      color: isDarkMode ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w300),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget titleField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isDarkMode
                ? darkPrimaryColor.withOpacity(0.9)
                : primaryColor.withOpacity(0.3)),
        child: TextField(
          style: TextStyle(color: isDarkMode ? Colors.black : primaryColor),
          controller: _todoController.titleTextController.value,
          cursorColor: isDarkMode ? Colors.black : primaryColor,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.title,
                color: isDarkMode ? Colors.black : primaryColor),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: isDarkMode ? Colors.black : primaryColor)),
            hintText: 'Title',
            hintStyle: TextStyle(
              color: isDarkMode ? Colors.black : primaryColor,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }

  Widget printTodo() {
    return Container(
      height: Get.mediaQuery.size.height * 0.15,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 50,
              mainAxisExtent: 30,
            ),
            itemCount: _todoController.todoTitleList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  _todoController.titleTextController.value.text =
                      _todoController.todoTitleList[index].title;
                  _todoController.selectColorIndex(
                      _todoController.todoTitleList[index].titleColor);
                },
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorList[_todoController
                                .todoTitleList[index].titleColor]),
                      ),
                      Text(
                        ' ${_todoController.todoTitleList[index].title}',
                        style: TextStyle(
                          fontSize: 16
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
        ),
      ),
    );
  }

  Widget setTime(BuildContext context) {
    var changeStartTime = _todoController.defaultTime.value.startTime;
    var changeEndTime = _todoController.defaultTime.value.endTime;
    return InkWell(
      customBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onTap: () async {
        await showDialog(
          context: context,
          builder: (_) => Padding(
            padding: EdgeInsets.symmetric(vertical: 100),
            child: Dialog(
              child: Column(
                children: [
                  TimeRangePicker(
                    hideButtons: true,
                    clockRotation: 180,
                    paintingStyle: PaintingStyle.fill,
                    fromText: 'START',
                    toText: 'END',
                    interval: Duration(
                        minutes:
                            _settingsController.timePickerOfInterval.value),
                    labels: ['0', '3', '6', '9', '12', '15', '18', '21']
                        .asMap()
                        .entries
                        .map((e) {
                      return ClockLabel.fromIndex(
                          idx: e.key, length: 8, text: e.value);
                    }).toList(),
                    snap: true,
                    start: _todoController.defaultTime.value.startTime,
                    end: _todoController.defaultTime.value.endTime,
                    onStartChange: (startTime) {
                      changeStartTime = startTime;
                    },
                    onEndChange: (endTime) {
                      changeEndTime = endTime;
                    },
                    ticks: 24,
                    handlerRadius: 8,
                    handlerColor: isDarkMode ? Colors.grey : primaryColor,
                    backgroundColor: isDarkMode
                        ? Colors.white.withOpacity(0.1)
                        : primaryColor.withOpacity(0.1),
                    strokeColor: isDarkMode
                        ? Colors.white.withOpacity(0.9)
                        : primaryColor.withOpacity(0.8),
                    ticksColor: isDarkMode
                        ? Colors.white.withOpacity(0.8)
                        : primaryColor,
                    labelOffset: 30,
                    rotateLabels: false,
                    padding: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          Get.back();
                        },
                        elevation: 0,
                        color: primaryColor.withOpacity(0.4),
                        child: Text(
                          '취 소',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          _todoController.setTime(TimeRange(
                              startTime: changeStartTime,
                              endTime: changeEndTime));
                          _todoController.defaultValue(_todoController.getValue(
                              _todoController.currentDateTime.value,
                              TimeRange(
                                  startTime: changeStartTime,
                                  endTime: changeEndTime)));
                          Get.back();
                        },
                        color: primaryColor,
                        child: Text(
                          '확 인',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
      child: Container(
        height: Get.mediaQuery.size.height * 0.1,
        decoration: BoxDecoration(
            color:
                isDarkMode ? darkPrimaryColor.withOpacity(0.9) : primaryColor,
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                SizedBox(width: 20),
                Text(
                  '${_todoController.defaultTime.value.startTime.hour} : '
                  '${_todoController.defaultTime.value.startTime.minute}',
                  style: TextStyle(
                      color: isDarkMode ? Colors.black : Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w200),
                ),
              ],
            ),
            Text(
              '~',
              style: TextStyle(
                  color: isDarkMode ? Colors.black : Colors.white,
                  fontSize: 20),
            ),
            Row(
              children: [
                Text(
                  '${_todoController.defaultTime.value.endTime.hour} : '
                  '${_todoController.defaultTime.value.endTime.minute}',
                  style: TextStyle(
                      color: isDarkMode ? Colors.black : Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w200),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget colorSelect() {
    return Container(
      height: Get.mediaQuery.size.height * 0.05,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: colorList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Obx(
                () => GestureDetector(
                  onTap: () {
                    _todoController.selectColorIndex(index);
                  },
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      border: _todoController.selectColorIndex.value == index
                          ? Border.all(
                              width: 3,
                              color: isDarkMode ? Colors.white : Colors.black)
                          : null,
                      shape: BoxShape.circle,
                      color: colorList[index],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget actionButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MaterialButton(
            onPressed: () {
              _todoController.titleTextController.value.clear();
              Get.back();
            },
            color: isDarkMode
                ? darkPrimaryColor.withOpacity(0.8)
                : primaryColor.withOpacity(0.4),
            elevation: 0,
            child: Text(
              '취 소',
              style: TextStyle(
                  color: isDarkMode ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w300),
            ),
          ),
          widget.editMode == true
              ? MaterialButton(
                  onPressed: () {
                    updateFireStore();
                  },
                  color: isDarkMode ? darkPrimaryColor : primaryColor,
                  elevation: 0,
                  child: Text(
                    '수 정',
                    style: TextStyle(
                        color: isDarkMode ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w300),
                  ),
                )
              : MaterialButton(
                  onPressed: () {
                    addFireStore();
                  },
                  color: isDarkMode ? darkPrimaryColor : primaryColor,
                  elevation: 0,
                  child: Text(
                    '추 가',
                    style: TextStyle(
                        color: isDarkMode ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w300),
                  ),
                ),
        ],
      ),
    );
  }

  Future<void> updateFireStore() async {
    return await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('todos')
        .doc(widget.todoUid)
        .update({
      'title': _todoController.titleTextController.value.text,
      'startHour': _todoController.defaultTime.value.startTime.hour,
      'startMinute': _todoController.defaultTime.value.startTime.minute,
      'endHour': _todoController.defaultTime.value.endTime.hour,
      'endMinute': _todoController.defaultTime.value.endTime.minute,
      'uid': widget.todoUid,
      'value': _todoController.defaultValue.value,
      'color': _todoController.selectColorIndex.value,
      'year': _todoController.currentDateTime.value.year,
      'month': _todoController.currentDateTime.value.month,
      'day': _todoController.currentDateTime.value.day,
      'hourMinute': '${_todoController.defaultValue.value.toInt() ~/ 60}h '
          '${_todoController.defaultValue.value.toInt() % 60}m'
    }).then((value) {
      _listController.initSearchResult();
      var todoIndex = _todoController.todoUidList.value.todoList
          .indexWhere((element) => element.uid == widget.todoUid);
      print('todoIndex = $todoIndex');
      if (todoIndex != -1) {
        _todoController.todoUidList.value.todoList[todoIndex].value =
            _todoController.defaultValue.value.toInt();
        _todoController.todoUidList.value.todoList[todoIndex].title =
            _todoController.titleTextController.value.text;
        _todoController.todoUidList.value.todoList[todoIndex].startHour =
            _todoController.defaultTime.value.startTime.hour;
        _todoController.todoUidList.value.todoList[todoIndex].startMinute =
            _todoController.defaultTime.value.startTime.minute;
        _todoController.todoUidList.value.todoList[todoIndex].endHour =
            _todoController.defaultTime.value.endTime.hour;
        _todoController.todoUidList.value.todoList[todoIndex].endMinute =
            _todoController.defaultTime.value.endTime.minute;
        _todoController.todoUidList.value.todoList[todoIndex].colorIndex =
            _todoController.selectColorIndex.value;
        _todoController.todoUidList.value.todoList[todoIndex].hourMinute =
            '${_todoController.defaultValue.value.toInt() ~/ 60}h '
            '${_todoController.defaultValue.value.toInt() % 60}m';
        _todoController.todoUidList.value.todoList[todoIndex].ymd = DateTime(
            _todoController.currentDateTime.value.year,
            _todoController.currentDateTime.value.month,
            _todoController.currentDateTime.value.day);
        _chartController.makeRangeDate();
      }
      Get.off(() => Home());
      Get.showSnackbar(GetBar(
        title: 'UPDATE',
        message: 'success!!',
        duration: Duration(seconds: 2),
        backgroundColor: successColor,
        snackPosition: SnackPosition.BOTTOM,
      ));
    }).catchError(
      (error) async => await Get.showSnackbar(
        GetBar(
          title: 'UPDATE',
          message: 'ERROR!',
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: errorColor,
        ),
      ),
    );
  }

  Future<void> addFireStore() async {
    return await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('todos')
        .add({
      'title': _todoController.titleTextController.value.text,
      'startHour': _todoController.defaultTime.value.startTime.hour,
      'startMinute': _todoController.defaultTime.value.startTime.minute,
      'endHour': _todoController.defaultTime.value.endTime.hour,
      'endMinute': _todoController.defaultTime.value.endTime.minute,
      'uid': 'NULL',
      'value': _todoController.defaultValue.value,
      'color': _todoController.selectColorIndex.value,
      'year': _todoController.currentDateTime.value.year,
      'month': _todoController.currentDateTime.value.month,
      'day': _todoController.currentDateTime.value.day,
      'hourMinute': '${_todoController.defaultValue.value.toInt() ~/ 60}h '
          '${_todoController.defaultValue.value.toInt() % 60}m'
    }).then((value) {
      _todoController.currentUid(value.id);
      FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('todos')
          .doc(value.id)
          .update({'uid': value.id});
      var addTodoDto = TestTodo(
          uid: _todoController.currentUid.value,
          ymd: DateTime(
              _todoController.currentDateTime.value.year,
              _todoController.currentDateTime.value.month,
              _todoController.currentDateTime.value.day),
          title: _todoController.titleTextController.value.text,
          startHour: _todoController.defaultTime.value.startTime.hour,
          startMinute: _todoController.defaultTime.value.startTime.minute,
          endHour: _todoController.defaultTime.value.endTime.hour,
          endMinute: _todoController.defaultTime.value.endTime.minute,
          value: _todoController.defaultValue.value,
          colorIndex: _todoController.selectColorIndex.value,
          hourMinute: '${_todoController.defaultValue.value.toInt() ~/ 60}h '
              '${_todoController.defaultValue.value.toInt() % 60}m');
      _todoController.loadTodoUidList.value.todoList.add(addTodoDto);
      _todoController.todoUidCheckAdd(addTodoDto);
      _todoController.setCurrentIndex(_todoController.currentDateTime.value);
      _todoController.titleTextController.value.clear();
      _chartController.makeRangeDate();
      _listController.initSearchResult();
      _listController.searchTitle('');
      Get.offAll(() => Home());
      Get.showSnackbar(GetBar(
        title: 'SUCCESS',
        message: '성공적으로 추가되었습니다.',
        duration: Duration(seconds: 1),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: successColor,
      ));
    }).catchError(
      (error) async => await Get.showSnackbar(
        GetBar(
          title: 'ERROR',
          message: '로그인 정보를 확인하세요',
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: errorColor,
        ),
      ),
    );
  }

  Widget makeRule() {
    return MaterialButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (_) => Dialog(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: Get.mediaQuery.size.height * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: primaryColor.withOpacity(0.2)),
                        child: TextField(
                          controller:
                              _todoController.makeRuleTitleController.value,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.title,
                              color: primaryColor,
                            ),
                            hintText: 'Title',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
                      ),
                      colorSelect(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              Get.back();
                            },
                            elevation: 0,
                            color: primaryColor.withOpacity(0.4),
                            child: Text(
                              '취 소',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              _todoController.addTodoTitle(
                                TodoTitle(
                                    title: _todoController
                                        .makeRuleTitleController.value.text,
                                    titleColor:
                                        _todoController.selectColorIndex.value),
                              );
                              Get.back();
                              _todoController.makeRuleTitleController.value
                                  .clear();
                            },
                            elevation: 0,
                            color: primaryColor.withOpacity(0.9),
                            child: Text(
                              '규칙추가',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        child: Text('규칙 만들기'));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _todoController.initDefaultValue();
  }
}
