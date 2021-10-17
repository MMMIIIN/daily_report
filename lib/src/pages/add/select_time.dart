import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';

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
                  decoration: BoxDecoration(
                    border: Border.all()
                  ),
                  child: TimePickerSpinner(
                    spacing: 10,
                    itemHeight: 20,
                    normalTextStyle: TextStyle(
                      fontSize: 20
                    ),
                    highlightedTextStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.red
                    ),
                    alignment: Alignment.center,
                    isForce2Digits: true,
                    minutesInterval: 10,
                    onTimeChange: (time) {
                      setState(() {
                        _todoController.startTime(TimeOfDay(
                          hour: time.hour,
                          minute: time.minute
                        ));
                      });
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all()
                  ),
                  child: TimePickerSpinner(
                    spacing: 10,
                    itemHeight: 20,
                    normalTextStyle: TextStyle(
                        fontSize: 20
                    ),
                    highlightedTextStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.red
                    ),
                    alignment: Alignment.center,
                    isForce2Digits: true,
                    minutesInterval: 10,
                    onTimeChange: (time) {
                      setState(() {
                        _todoController.startTime(TimeOfDay(
                            hour: time.hour,
                            minute: time.minute
                        ));
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
