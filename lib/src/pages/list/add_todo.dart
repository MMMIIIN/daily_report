import 'package:daily_report/color.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_range_picker/time_range_picker.dart';

class AddTodo extends StatefulWidget {
  String? uid;
  int? year;
  int? month;
  int? day;
  bool? editMode;

  AddTodo({this.year, this.month, this.day, this.uid, this.editMode = false});

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  bool isDarkMode = GetStorage().read('isDarkMode');

  final TodoController _todoController = Get.put(TodoController());

  Widget selectOfDate() {
    DateTime _selectedDay = _todoController.currentDateTime.value;
    // void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    //   if (!isSameDay(_selectedDay, selectedDay)) {
    //     setState(() {
    //       _selectedDay = selectedDay;
    //       _focusedDay = focusedDay;
    //       _todoController.currentDateTime(selectedDay);
    //       print('_selectedDay = $_selectedDay');
    //       print('_focusedDay = $_focusedDay');
    //       // _todoController.setCurrentIndex(_selectedDay);
    //       _todoController.setCurrentIndex(_selectedDay);
    //       _todoController.currentDateTime(_selectedDay);
    //       print('todoDateTime ${_todoController.currentDateTime.value}');
    //     });
    //   }
    // }
    return InkWell(
      onTap: () {
        Get.dialog(
          Dialog(
            child: Obx(
              () => TableCalendar(
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
                      }),
                  firstDay: FirstDay,
                  lastDay: LastDay,
                  focusedDay: _todoController.currentDateTime.value,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  // calendarFormat: CalendarFormat.month,
                  calendarStyle: CalendarStyle(
                    weekendTextStyle: TextStyle(color: Colors.red),
                    holidayTextStyle: TextStyle(color: Colors.blue),
                  ),
                  eventLoader: (day) {
                    for (var todo
                        in _todoController.loadTodoUidList.value.todoList) {
                      if (day == todo.ymd) {
                        return [Container()];
                      }
                    }
                    return [];
                  },
                  onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                    setState(() {
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        _selectedDay = selectedDay;
                        _todoController.currentDateTime(_selectedDay);
                      }
                    });
                  }),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(border: Border.all()),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${_todoController.currentDateTime.value.year} '
                '${_todoController.currentDateTime.value.month} '
                '${_todoController.currentDateTime.value.day}')
          ],
        ),
      ),
    );
  }

  Widget titleField() {
    return Container(
      padding: EdgeInsets.all(8),
      child: TextField(
        controller: _todoController.titleTextController.value,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            hintText: 'Title'),
      ),
    );
  }

  Widget printTodo() {
    return Padding(
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
                // _todoController.titleTextController.value.text(_todoController.defaultText);
                _todoController.titleTextController.value.text =
                    _todoController.todoTitleList[index].title;
              },
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(15)),
                child: Text('${_todoController.todoTitleList[index].title}'),
              ),
            );
          }),
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
          // backgroundColor: Colors.grey.withOpacity(0.2),
          backgroundColor: Colors.yellow[100],
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
          strokeColor: Colors.orangeAccent[200],
          ticksColor: Theme.of(context).primaryColor,
          labelOffset: 30,
          rotateLabels: false,
          padding: 60,
        );
        _todoController.setTime(result);
        _todoController.defaultValue(_todoController.getValue(
            _todoController.currentDateTime.value, result));
        print(_todoController.defaultValue.value);
        // controller.listeners;
        // controller.change(result);
      },
      child: Container(
        height: Get.mediaQuery.size.height * 0.1,
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                // Text('${timeRange?.startTime.hour}'),
                SizedBox(width: 20),
                Text('${_todoController.defaultTime.value.startTime.hour} : '),
                Text('${_todoController.defaultTime.value.startTime.minute}'),
                // Text('${Get.parameters['title']}')
                // Text('${_todoController.chartClassList[_todoController.currentIndex.value].data.last.timeRange.startTime.hour} : '),
                // Text('${_todoController.chartClassList[_todoController.currentIndex.value].data.last.timeRange.startTime.minute}')
              ],
            ),
            Row(
              children: [
                Text('${_todoController.defaultTime.value.endTime.hour} : '),
                Text('${_todoController.defaultTime.value.endTime.minute}'),
                // Text('${_todoController.chartClassList[_todoController.currentIndex.value].data.last.timeRange.endTime.hour} : '),
                // Text('${_todoController.chartClassList[_todoController.currentIndex.value].data.last.timeRange.endTime.minute}')
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget colorSelect() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
            color: Colors.white,
            child: Text('CANCLE'),
          ),
          MaterialButton(
            onPressed: () {
              _todoController.addTodo(
                  widget.uid ?? '',
                  YMD(
                      year: widget.year ?? 0,
                      month: widget.month ?? 0,
                      day: widget.day ?? 0),
                  _todoController.titleTextController.value.text,
                  _todoController.defaultTime.value,
                  _todoController.defaultValue.value,
                  _todoController.selectColorIndex.value);
              _todoController.titleTextController.value.clear();
              Get.off(() => Home());
            },
            color: Colors.white,
            child: Text('ADD'),
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
                Flexible(
                  flex: 1,
                  child: titleField(),
                ),
                Flexible(child: printTodo()),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: setTime(context),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: colorSelect(),
                ),
                actionButton()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
