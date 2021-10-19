import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:time_range_picker/time_range_picker.dart';

final TodoController _todoController = Get.put(TodoController());

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
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      _todoController.startTime(
                        await showTimePicker(
                          context: context,
                          initialTime: _todoController.startTime.value,
                          initialEntryMode: TimePickerEntryMode.input,
                        ),
                      );
                    },
                    child: Container(
                      width: context.mediaQuery.size.width * 0.35,
                      height: context.mediaQuery.size.height * 0.07,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child:
                              Text('${_todoController.startTime.value.hour} : '
                                  '${_todoController.startTime.value.minute}')),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      _todoController.endTime(
                        await showTimePicker(
                          context: context,
                          initialTime: _todoController.endTime.value,
                          initialEntryMode: TimePickerEntryMode.input,
                        ),
                      );
                    },
                    child: Container(
                      width: context.mediaQuery.size.width * 0.35,
                      height: context.mediaQuery.size.height * 0.07,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text('${_todoController.endTime.value.hour} : '
                            '${_todoController.endTime.value.minute}'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(border: Border.all()),
                  child: TimePickerSpinner(
                    time: DateTime(
                        2021,
                        1,
                        1,
                        _todoController.startTime.value.hour,
                        _todoController.startTime.value.minute),
                    itemWidth: 40,
                    spacing: 10,
                    itemHeight: 20,
                    normalTextStyle: TextStyle(fontSize: 20),
                    highlightedTextStyle: TextStyle(
                        fontSize: 20,
                        color: context.theme.primaryColor,
                        fontWeight: FontWeight.bold),
                    alignment: Alignment.center,
                    isForce2Digits: true,
                    // is24HourMode: false,
                    minutesInterval: 10,
                    onTimeChange: (time) {
                      setState(() {
                        _todoController.startTime(
                            TimeOfDay(hour: time.hour, minute: time.minute));
                      });
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(border: Border.all()),
                  child: TimePickerSpinner(
                    time: DateTime(
                        2021,
                        1,
                        1,
                        _todoController.endTime.value.hour,
                        _todoController.endTime.value.minute),
                    spacing: 10,
                    itemHeight: 20,
                    normalTextStyle: TextStyle(fontSize: 20),
                    highlightedTextStyle:
                        TextStyle(fontSize: 20, color: Colors.red),
                    alignment: Alignment.center,
                    isForce2Digits: true,
                    // is24HourMode: false,
                    minutesInterval: 10,
                    onTimeChange: (time) {
                      setState(
                        () {
                          _todoController.endTime(
                            TimeOfDay(hour: time.hour, minute: time.minute),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            inputTimeField(),
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

  Widget inputTimeField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: context.width * 0.3,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: context.mediaQuery.size.width * 0.1,
                child: TextField(
                  textAlign: TextAlign.center,
                  onChanged: (number) {
                    _todoController.startHour(int.parse(number));
                  },
                  maxLength: 2,
                  decoration: InputDecoration(counterText: ''),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
              ),
              Text(
                ':',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                width: context.mediaQuery.size.width * 0.1,
                child: TextField(
                  textAlign: TextAlign.center,
                  onChanged: (number) {
                    _todoController.startMinute(int.parse(number));
                  },
                  onSubmitted: (text) {
                    _todoController.startTime(
                      TimeOfDay(
                          hour: _todoController.startHour.value,
                          minute: _todoController.startMinute.value),
                    );
                  },
                  maxLength: 2,
                  decoration: InputDecoration(counterText: ''),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: context.width * 0.3,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: context.mediaQuery.size.width * 0.1,
                child: TextField(
                  textAlign: TextAlign.center,
                  onChanged: (number) {
                    _todoController.endHour(int.parse(number));
                  },
                  maxLength: 2,
                  decoration: InputDecoration(counterText: ''),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
              ),
              Text(
                ':',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                width: context.mediaQuery.size.width * 0.1,
                child: TextField(
                  textAlign: TextAlign.center,
                  onChanged: (number) {
                    _todoController.endMinute(int.parse(number));
                  },
                  maxLength: 2,
                  decoration: InputDecoration(counterText: ''),
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
}
