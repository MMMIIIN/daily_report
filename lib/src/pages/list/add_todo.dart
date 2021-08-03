import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_report/color.dart';
import 'package:daily_report/src/data/todo/chart_date_data.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_range_picker/time_range_picker.dart';

class AddTodo extends StatefulWidget {
  int? year;
  int? month;
  int? day;
  bool? editMode;

  AddTodo({this.year, this.month, this.day, this.editMode = false});

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  bool isDarkMode = GetStorage().read('isDarkMode');

  final TodoController _todoController = Get.put(TodoController());

  Widget selectOfDate() {
    var _selectedDay = _todoController.currentDateTime.value;
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 120),
            child: Dialog(
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TableCalendar(
                        calendarBuilders: CalendarBuilders(
                            selectedBuilder: (context, date, events) =>
                                Container(
                                  margin: const EdgeInsets.all(4),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: isDarkMode
                                          ? Colors.grey
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
                            }),
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
                            if (day == todo.ymd) {
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
          interval: Duration(minutes: 10),
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
          MaterialButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('todo')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('todos')
                  .add({
                'title': _todoController.titleTextController.value.text,
                'startHour': _todoController.defaultTime.value.startTime.hour,
                'startMinute':
                    _todoController.defaultTime.value.startTime.minute,
                'endHour': _todoController.defaultTime.value.endTime.hour,
                'endMinute': _todoController.defaultTime.value.endTime.minute,
                'uid': 'NULL',
                'value': _todoController.defaultValue.value,
                'color': _todoController.selectColorIndex.value,
                'year': _todoController.currentDateTime.value.year,
                'month': _todoController.currentDateTime.value.month,
                'day': _todoController.currentDateTime.value.day
              }).then((value) {
                print(value.id);
                FirebaseFirestore.instance
                    .collection('todo')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('todos')
                    .doc(value.id)
                    .update({'uid': value.id});
                Get.off(() => Home());
                Get.showSnackbar(GetBar(
                  title: 'Success',
                  message: 'good!',
                  duration: Duration(seconds: 2),
                  snackPosition: SnackPosition.BOTTOM,
                ));
                _todoController.todoUidCheckAdd(TestTodo(
                    uid: FirebaseAuth.instance.currentUser!.uid,
                    ymd: DateTime(
                        _todoController.currentDateTime.value.year,
                        _todoController.currentDateTime.value.month,
                        _todoController.currentDateTime.value.day),
                    title: _todoController.titleTextController.value.text,
                    startHour: _todoController.defaultTime.value.startTime.hour,
                    startMinute:
                        _todoController.defaultTime.value.startTime.minute,
                    endHour: _todoController.defaultTime.value.endTime.hour,
                    endMinute: _todoController.defaultTime.value.endTime.minute,
                    value: _todoController.defaultValue.value.toInt(),
                    colorIndex: _todoController.selectColorIndex.value));
              }).catchError((error) => Get.showSnackbar(GetBar(
                        title: 'ERROR',
                        message: '로그인 정보를 확인하세요',
                        duration: Duration(seconds: 2),
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.redAccent,
                      )));
              _todoController.titleTextController.value.clear();
            },
            color: primaryColor,
            child: Text(
              'ADD',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
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
                borderRadius: BorderRadius.circular(15), border: Border.all()),
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
