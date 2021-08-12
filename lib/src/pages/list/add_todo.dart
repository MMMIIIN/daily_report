import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_report/color.dart';
import 'package:daily_report/src/data/todo/chart_date_data.dart';
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

class _AddTodoState extends State<AddTodo> {
  bool isDarkMode = GetStorage().read('isDarkMode');
  final TodoController _todoController = Get.put(TodoController());
  final ListController _listController = Get.put(ListController());
  final SettingsController _settingsController = Get.put(SettingsController());

  Widget selectOfDate() {
    var _selectedDay = _todoController.currentDateTime.value;
    return GestureDetector(
      onTap: () {
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
                        focusedDay: _todoController.currentDateTime.value,
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        calendarStyle: CalendarStyle(
                          weekendTextStyle: TextStyle(color: Colors.red),
                          holidayTextStyle: TextStyle(color: Colors.blue),
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
                              _todoController.currentDateTime(selectedDay);
                            }
                          });
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            Get.back();
                          },
                          color: primaryColor,
                          child: Text(
                            '취 소',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
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
        child: Container(
          width: Get.mediaQuery.size.width * 0.4,
          height: 30,
          decoration: BoxDecoration(
            color: primaryColor,
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
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              )
            ],
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
            color: primaryColor.withOpacity(0.3)),
        child: TextField(
          controller: _todoController.titleTextController.value,
          decoration: InputDecoration(
            focusColor: primaryColor,
            prefixIcon: Icon(Icons.title, color: primaryColor),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor)),
            hintText: 'Title',
            hintStyle: TextStyle(
              color: primaryColor,
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
                },
                child: Card(
                    color: primaryColor,
                    child: Text(
                      '${_todoController.todoTitleList[index].title}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w200),
                    )),
              );
            }),
      ),
    );
  }

  Widget setTime(BuildContext context) {
    return InkWell(
      customBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onTap: () async {
        TimeRange result = await showTimeRangePicker(
          context: context,
          clockRotation: 180,
          paintingStyle: PaintingStyle.fill,
          interval:
              Duration(minutes: _settingsController.timePickerOfInterval.value),
          labels: ['0', '3', '6', '9', '12', '15', '18', '21']
              .asMap()
              .entries
              .map((e) {
            return ClockLabel.fromIndex(idx: e.key, length: 8, text: e.value);
          }).toList(),
          snap: true,
          start: TimeOfDay(
              hour: widget.editMode == true
                  ? _todoController.defaultTime.value.startTime.hour
                  : _todoController.defaultTime.value.endTime.hour,
              minute: widget.editMode == true
                  ? _todoController.defaultTime.value.startTime.minute
                  : _todoController.defaultTime.value.endTime.minute),
          end: TimeOfDay(
              hour: widget.editMode == true
                  ? _todoController.defaultTime.value.endTime.hour
                  : (_todoController.defaultTime.value.endTime.hour + 2) > 24
                      ? 0
                      : _todoController.defaultTime.value.endTime.hour + 2,
              minute: widget.editMode == true
                  ? _todoController.defaultTime.value.endTime.minute
                  : _todoController.defaultTime.value.endTime.minute),
          ticks: 24,
          handlerRadius: 8,
          handlerColor: isDarkMode ? Colors.grey : primaryColor,
          backgroundColor: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : primaryColor.withOpacity(0.1),
          strokeColor: isDarkMode
              ? Colors.white.withOpacity(0.9)
              : primaryColor.withOpacity(0.8),
          ticksColor: isDarkMode ? Colors.white.withOpacity(0.8) : primaryColor,
          labelOffset: 30,
          rotateLabels: false,
          padding: 60,
        );
        _todoController.setTime(result);
        _todoController.defaultValue(_todoController.getValue(
            _todoController.currentDateTime.value, result));
        print(_todoController.defaultValue.value);
      },
      child: Container(
        height: Get.mediaQuery.size.height * 0.1,
        decoration: BoxDecoration(
            color: primaryColor.withOpacity(1),
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
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w200),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '${_todoController.defaultTime.value.endTime.hour} : '
                  '${_todoController.defaultTime.value.endTime.minute}',
                  style: TextStyle(
                      color: Colors.white,
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
            color: primaryColor,
            child: Text(
              'CANCLE',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
            ),
          ),
          widget.editMode == true
              ? MaterialButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('todo')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('todos')
                        .doc(widget.todoUid)
                        .update({
                      'title': _todoController.titleTextController.value.text,
                      'startHour':
                          _todoController.defaultTime.value.startTime.hour,
                      'startMinute':
                          _todoController.defaultTime.value.startTime.minute,
                      'endHour': _todoController.defaultTime.value.endTime.hour,
                      'endMinute':
                          _todoController.defaultTime.value.endTime.minute,
                      'uid': widget.todoUid,
                      'value': _todoController.defaultValue.value,
                      'color': _todoController.selectColorIndex.value,
                      'year': _todoController.currentDateTime.value.year,
                      'month': _todoController.currentDateTime.value.month,
                      'day': _todoController.currentDateTime.value.day
                    }).then((value) {
                      _listController.initSearchResult();
                      var todoIndex = _todoController.todoUidList.value.todoList
                          .indexWhere(
                              (element) => element.uid == widget.todoUid);
                      if (todoIndex != -1) {
                        _todoController.todoUidList.value.todoList[todoIndex]
                            .value = _todoController.defaultValue.value.toInt();
                        _todoController
                                .todoUidList.value.todoList[todoIndex].title =
                            _todoController.titleTextController.value.text;
                        _todoController.todoUidList.value.todoList[todoIndex]
                                .startHour =
                            _todoController.defaultTime.value.startTime.hour;
                        _todoController.todoUidList.value.todoList[todoIndex]
                                .startMinute =
                            _todoController.defaultTime.value.startTime.minute;
                        _todoController
                                .todoUidList.value.todoList[todoIndex].endHour =
                            _todoController.defaultTime.value.endTime.hour;
                        _todoController.todoUidList.value.todoList[todoIndex]
                                .endMinute =
                            _todoController.defaultTime.value.endTime.minute;
                        _todoController.todoUidList.value.todoList[todoIndex]
                                .colorIndex =
                            _todoController.selectColorIndex.value;
                        _todoController
                                .todoUidList.value.todoList[todoIndex].ymd =
                            DateTime(
                                _todoController.currentDateTime.value.year,
                                _todoController.currentDateTime.value.month,
                                _todoController.currentDateTime.value.day);
                      }
                      Get.off(() => Home());
                      Get.showSnackbar(GetBar(
                        title: 'UPDATE',
                        message: 'success!!',
                        duration: Duration(seconds: 2),
                        snackPosition: SnackPosition.BOTTOM,
                      ));
                    }).catchError((error) => Get.showSnackbar(GetBar(
                              title: 'UPDATE',
                              message: 'ERROR!',
                              duration: Duration(seconds: 2),
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.redAccent,
                            )));
                  },
                  color: primaryColor,
                  child: Text(
                    'UPDATE',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300),
                  ),
                )
              : MaterialButton(
                  onPressed: () async {
                    var addTodoDto = TestTodo(
                        uid: 'NULL',
                        ymd: DateTime(
                            _todoController.currentDateTime.value.year,
                            _todoController.currentDateTime.value.month,
                            _todoController.currentDateTime.value.day),
                        title: _todoController.titleTextController.value.text,
                        startHour:
                            _todoController.defaultTime.value.startTime.hour,
                        startMinute:
                            _todoController.defaultTime.value.startTime.minute,
                        endHour: _todoController.defaultTime.value.endTime.hour,
                        endMinute:
                            _todoController.defaultTime.value.endTime.minute,
                        value: _todoController.defaultValue.value.toInt(),
                        colorIndex: _todoController.selectColorIndex.value,
                        hourMinute:
                            '${_todoController.defaultValue.value.toInt() ~/ 60}h '
                            '${_todoController.defaultValue.value.toInt() % 60}m');
                    await FirebaseFirestore.instance
                        .collection('todo')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('todos')
                        .add({
                      'title': _todoController.titleTextController.value.text,
                      'startHour':
                          _todoController.defaultTime.value.startTime.hour,
                      'startMinute':
                          _todoController.defaultTime.value.startTime.minute,
                      'endHour': _todoController.defaultTime.value.endTime.hour,
                      'endMinute':
                          _todoController.defaultTime.value.endTime.minute,
                      'uid': 'NULL',
                      'value': _todoController.defaultValue.value,
                      'color': _todoController.selectColorIndex.value,
                      'year': _todoController.currentDateTime.value.year,
                      'month': _todoController.currentDateTime.value.month,
                      'day': _todoController.currentDateTime.value.day
                    }).then((value) {
                      FirebaseFirestore.instance
                          .collection('todo')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('todos')
                          .doc(value.id)
                          .update({'uid': value.id});
                      _chartController.makeRangeDate();
                      _todoController.loadTodoUidList.value.todoList
                          .add(addTodoDto);
                      _todoController.todoUidCheckAdd(addTodoDto);
                      _todoController.setCurrentIndex(
                          _todoController.currentDateTime.value);
                      _chartController.makeRangeDate();
                      Get.offAll(() => Home());
                      Get.showSnackbar(GetBar(
                        title: 'ADD',
                        message: 'success!!',
                        duration: Duration(seconds: 1),
                        snackPosition: SnackPosition.BOTTOM,
                      ));
                    }).catchError(
                      (error) async => await Get.showSnackbar(
                        GetBar(
                          title: 'ERROR',
                          message: '로그인 정보를 확인하세요',
                          duration: Duration(seconds: 2),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent,
                        ),
                      ),
                    );
                    _todoController.titleTextController.value.clear();
                  },
                  color: primaryColor,
                  child: Text(
                    'ADD',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300),
                  ),
                ),
        ],
      ),
    );
  }

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
              border: Border.all(color: primaryColor),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                selectOfDate(),
                titleField(),
                Flexible(fit: FlexFit.tight, child: printTodo()),
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
}
