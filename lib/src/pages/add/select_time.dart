import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_range_picker/time_range_picker.dart';

final TodoController _todoController = Get.put(TodoController());
final FocusNode _startHourFocus = FocusNode();
final FocusNode _startMinuteFocus = FocusNode();
final FocusNode _endHourFocus = FocusNode();
final FocusNode _endMinuteFocus = FocusNode();

class SelectTimePage extends StatefulWidget {
  @override
  _SelectTimePageState createState() => _SelectTimePageState();
}

class _SelectTimePageState extends State<SelectTimePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          children: [
            selectTime(),
            MaterialButton(
              onPressed: () {
                var result = _todoController.getValue(
                    DateTime.now(),
                    TimeRange(
                        startTime: _todoController.startTime.value,
                        endTime: _todoController.endTime.value));
                print(result);
              },
              color: Colors.deepPurpleAccent,
            )
          ],
        ),
      ),
    );
  }

  Widget selectTime() {
    return Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: context.mediaQuery.size.width * 0.6,
            height: context.mediaQuery.size.height * 0.1,
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _todoController.selectTime.value == 0
                    ? Container(
                        width: context.mediaQuery.size.width * 0.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${_todoController.startTime.value.hour} : '
                                '${_todoController.startTime.value.minute}'),
                            Text('${_todoController.endTime.value.hour} : '
                                '${_todoController.endTime.value.minute}'),
                          ],
                        ),
                      )
                    : inputTimeField(),
              ],
            ),
          ),
          Container(
            width: context.mediaQuery.size.width * 0.2,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    _todoController.selectTime(0);
                  },
                  child: Container(
                    child: Center(child: Text('시계')),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _todoController.selectTime(1);
                  },
                  child: Container(
                    child: Center(child: Text('직접 입력')),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: context.mediaQuery.size.width * 0.05,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.check,
                    color: _todoController.selectTime.value == 0
                        ? context.theme.primaryColor
                        : Colors.transparent),
                Icon(Icons.check,
                    color: _todoController.selectTime.value == 1
                        ? context.theme.primaryColor
                        : Colors.transparent),
              ],
            ),
          ),
        ],
    );
  }

  Widget inputTimeField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: context.mediaQuery.size.width * 0.3,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: context.mediaQuery.size.width * 0.1,
                child: TextField(
                  focusNode: _startHourFocus,
                  textAlign: TextAlign.center,
                  onChanged: (number) {
                    if (number.isNotEmpty) {
                      _todoController.startHour(int.parse(number));
                    }
                    if (number.length == 2) {
                      _fieldFocusChange(
                          context, _startHourFocus, _startMinuteFocus);
                    }
                  },
                  maxLength: 2,
                  decoration: InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.only(top: 20)),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
              ),
              Text(
                ':',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              Container(
                width: context.mediaQuery.size.width * 0.1,
                child: TextField(
                  focusNode: _startMinuteFocus,
                  textAlign: TextAlign.center,
                  onChanged: (number) {
                    if (number.isNotEmpty) {
                      _todoController.startMinute(int.parse(number));
                    }
                    if (number.length == 2) {
                      _fieldFocusChange(
                          context, _startMinuteFocus, _endHourFocus);
                      _todoController.startTime(
                        TimeOfDay(
                            hour: _todoController.startHour.value,
                            minute: _todoController.startMinute.value),
                      );
                    }
                  },
                  onSubmitted: (text) {},
                  maxLength: 2,
                  decoration: InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.only(top: 20)),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: context.mediaQuery.size.width * 0.3,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: context.mediaQuery.size.width * 0.1,
                child: TextField(
                  focusNode: _endHourFocus,
                  textAlign: TextAlign.center,
                  onChanged: (number) {
                    if (number.isNotEmpty) {
                      _todoController.endHour(int.parse(number));
                    }
                    if (number.length == 2) {
                      _fieldFocusChange(
                          context, _endHourFocus, _endMinuteFocus);
                    }
                  },
                  maxLength: 2,
                  decoration: InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.only(top: 20)),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
              ),
              Text(
                ':',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              Container(
                width: context.mediaQuery.size.width * 0.1,
                child: TextField(
                  focusNode: _endMinuteFocus,
                  textAlign: TextAlign.center,
                  onChanged: (number) {
                    if (number.isNotEmpty) {
                      _todoController.endMinute(int.parse(number));
                    }
                    if (number.length == 2) {
                      _endMinuteFocus.unfocus();
                      _todoController.endTime(TimeOfDay(
                          hour: _todoController.endHour.value,
                          minute: _todoController.endMinute.value));
                      var result = _todoController.getValue(
                        DateTime.now(),
                        TimeRange(
                          startTime: TimeOfDay(
                              hour: _todoController.startHour.value,
                              minute: _todoController.startMinute.value),
                          endTime: TimeOfDay(
                              hour: _todoController.endHour.value,
                              minute: _todoController.endMinute.value),
                        ),
                      );
                      print(result);
                    }
                  },
                  maxLength: 2,
                  decoration: InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.only(top: 20)),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (number) {
                    var result = _todoController.getValue(
                      DateTime.now(),
                      TimeRange(
                        startTime: TimeOfDay(
                            hour: _todoController.startHour.value,
                            minute: _todoController.startMinute.value),
                        endTime: TimeOfDay(
                            hour: _todoController.endHour.value,
                            minute: _todoController.endMinute.value),
                      ),
                    );
                    print(result);
                    _todoController.endTime(TimeOfDay(
                        hour: _todoController.endHour.value,
                        minute: _todoController.endMinute.value));
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
