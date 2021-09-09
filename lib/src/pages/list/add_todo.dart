import 'package:daily_report/color.dart';
import 'package:daily_report/icons.dart';
import 'package:daily_report/src/data/todo/todo.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/chart/controller/chart_controller.dart';
import 'package:daily_report/src/pages/home.dart';
import 'package:daily_report/src/pages/list/controller/list_controller.dart';
import 'package:daily_report/src/pages/settings/controller/settings_controller.dart';
import 'package:daily_report/src/service/firestore_service.dart';
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
            height: context.mediaQuery.size.height * 0.85,
            width: context.mediaQuery.size.width * 0.99,
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
                Obx(() => printTodo()),
                makeRule(),
                memoField(context),
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
                actionButton(context)
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
        var _selectedDay = _todoController.currentDateTime.value;
        showDialog(
          context: context,
          builder: (_) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
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
                                    ? Color(0xff95afc0)
                                    : primaryColor.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(10)),
                            child: date.year == DateTime.now().year &&
                                    date.month == DateTime.now().month &&
                                    date.day == DateTime.now().day
                                ? Column(
                                    children: [
                                      Text(
                                        'today',
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.white),
                                      ),
                                      date.weekday == 6 || date.weekday == 7
                                          ? Text(
                                              date.day.toString(),
                                              style: TextStyle(
                                                  color: Colors.redAccent),
                                            )
                                          : Text(
                                              date.day.toString(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                    ],
                                  )
                                : date.weekday == 6 || date.weekday == 7
                                    ? Text(
                                        date.day.toString(),
                                        style:
                                            TextStyle(color: Colors.redAccent),
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
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.red),
                                ),
                                date.weekday == 6 || date.weekday == 7
                                    ? Text(
                                        date.day.toString(),
                                        style:
                                            TextStyle(color: Colors.redAccent),
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
            width: context.mediaQuery.size.width * 0.4,
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
                  '${_todoController.currentDateTime.value.day} '
                  '${_listController.getOfDay(_todoController.currentDateTime.value.weekday)}',
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
      child: Obx(
        () => Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            onChanged: (text) {
              _todoController.titleText(text);
            },
            style: TextStyle(color: isDarkMode ? Colors.black : primaryColor),
            controller: _todoController.titleTextController.value,
            cursorColor: isDarkMode ? Colors.black : primaryColor,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.title,
                  color: isDarkMode ? Colors.black : primaryColor),
              suffixIcon: _todoController.titleText.value.isEmpty
                  ? null
                  : IconButton(
                      splashRadius: 16,
                      icon: Icon(IconsDB.cancle_outlined),
                      onPressed: () {
                        _todoController.titleText('');
                        _todoController.titleTextController.value.clear();
                      },
                    ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: isDarkMode ? Colors.black : Colors.transparent)),
              hintText: 'Title',
              hintStyle: TextStyle(
                color: isDarkMode ? Colors.black : primaryColor,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget makeRule() {
    return MaterialButton(
        onPressed: () async {
          _todoController.initCheckBoxBool();
          await showDialog(
            context: context,
            builder: (_) => Dialog(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  height: context.mediaQuery.size.height * 0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Obx(
                        () => Container(
                          padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            onChanged: (text) {
                              _todoController.setMakeRuleTitle(text);
                            },
                            controller:
                                _todoController.makeRuleTitleController.value,
                            cursorColor: primaryColor,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.title,
                                  color: primaryColor,
                                ),
                                suffixIcon:
                                    _todoController.makeRuleTitle.isEmpty
                                        ? null
                                        : IconButton(
                                            splashRadius: 16,
                                            icon: Icon(IconsDB.cancle_outlined,
                                            size: 20,
                                            color: Colors.black,
                                            ),
                                            onPressed: () {
                                              _todoController
                                                  .makeRuleTitleController.value
                                                  .clear();
                                              _todoController.makeRuleTitle('');
                                            },
                                          ),
                                hintText: 'Title',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent))),
                          ),
                        ),
                      ),
                      colorSelect(),
                      Obx(
                        () => Row(
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              activeColor: primaryColor,
                              value: _todoController.checkBoxBool.value,
                              onChanged: (check) {
                                _todoController.checkBoxBool(check);
                              },
                            ),
                            InkWell(
                              onTap: _todoController.checkBoxBool.value
                                  ? () {
                                      setTimeRange();
                                    }
                                  : () {},
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                width: context.mediaQuery.size.width * 0.55,
                                height: context.mediaQuery.size.height * 0.05,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: _todoController.checkBoxBool.value
                                      ? primaryColor.withOpacity(0.2)
                                      : primaryColor.withOpacity(0.05),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                        '${_todoController.defaultTime.value.startTime.hour} : '
                                        '${_todoController.defaultTime.value.startTime.minute}'),
                                    Text(' ~ '),
                                    Text(
                                        '${_todoController.defaultTime.value.endTime.hour} : '
                                        '${_todoController.defaultTime.value.endTime.minute}'),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              _todoController.makeRuleTitle('');
                              _todoController.makeRuleTitleController.value
                                  .clear();
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
                            onPressed: () async {
                              await addTodoTitle(
                                TodoTitle(
                                  title: _todoController.makeRuleTitle.value,
                                  titleColor:
                                      _todoController.selectColorIndex.value,
                                  boolOfTime:
                                      _todoController.checkBoxBool.value,
                                  timeRange: _todoController.checkBoxBool.value
                                      ? _todoController.defaultTime.value
                                      : TimeRange(
                                          startTime:
                                              TimeOfDay(hour: 0, minute: 0),
                                          endTime:
                                              TimeOfDay(hour: 1, minute: 0),
                                        ),
                                ),
                              );
                              _todoController.addTodoTitle(
                                TodoTitle(
                                    title: _todoController.makeRuleTitle.value,
                                    titleColor:
                                        _todoController.selectColorIndex.value,
                                    uid: currentTodoTitleUid,
                                    timeRange:
                                        _todoController.checkBoxBool.value
                                            ? TimeRange(
                                                startTime: TimeOfDay(
                                                    hour: _todoController
                                                        .defaultTime
                                                        .value
                                                        .startTime
                                                        .hour,
                                                    minute: _todoController
                                                        .defaultTime
                                                        .value
                                                        .startTime
                                                        .minute),
                                                endTime: TimeOfDay(
                                                    hour: _todoController
                                                        .defaultTime
                                                        .value
                                                        .endTime
                                                        .hour,
                                                    minute: _todoController
                                                        .defaultTime
                                                        .value
                                                        .endTime
                                                        .minute),
                                              )
                                            : null,
                                    boolOfTime:
                                        _todoController.checkBoxBool.value),
                              );
                              _todoController.titleTextController.value.text =
                                  _todoController.makeRuleTitle.value;
                              _todoController.makeRuleTitle('');
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
        child: Icon(Icons.add));
  }

  Widget printTodo() {
    return Container(
      // height: context.mediaQuery.size.height * 0.15,
      // color: Colors.red.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 50,
            mainAxisExtent: 30,
          ),
          itemCount: _todoController.todoTitleList.length,
          itemBuilder: (context, index) {
            return Align(
              alignment: Alignment.topCenter,
              child: InkWell(
                onTap: () {
                  _todoController.titleTextController.value.text =
                      _todoController.todoTitleList[index].title;
                  _todoController.selectColorIndex(
                      _todoController.todoTitleList[index].titleColor);
                  _todoController.todoTitleList[index].boolOfTime
                      ? _todoController.setTime(
                          TimeRange(
                            startTime: TimeOfDay(
                              hour: _todoController.todoTitleList[index]
                                  .timeRange!.startTime.hour,
                              minute: _todoController.todoTitleList[index]
                                  .timeRange!.startTime.minute,
                            ),
                            endTime: TimeOfDay(
                              hour: _todoController
                                  .todoTitleList[index].timeRange!.endTime.hour,
                              minute: _todoController.todoTitleList[index]
                                  .timeRange!.endTime.minute,
                            ),
                          ),
                        )
                      : null;
                  _todoController.todoTitleList[index].boolOfTime
                      ? _todoController.defaultValue(
                          _todoController.getValue(DateTime.now(),
                              _todoController.todoTitleList[index].timeRange!),
                        )
                      : null;
                },
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorList[_todoController
                                  .todoTitleList[index].titleColor],
                            ),
                          ),
                          Flexible(
                            child: Text(
                              ' ${_todoController.todoTitleList[index].title}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              Get.back();
                            },
                            elevation: 0,
                            color: primaryColor.withOpacity(0.4),
                            child: Text(
                              '취소',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              deleteTodoTitle(
                                  _todoController.todoTitleList[index].uid);
                              _todoController.todoTitleList.removeWhere(
                                  (element) =>
                                      element.uid ==
                                      _todoController.todoTitleList[index].uid);
                              Get.back();
                            },
                            elevation: 0,
                            color: primaryColor,
                            child: Text(
                              '규칙 삭제',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorList[_todoController
                                .todoTitleList[index].titleColor]),
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            ' ${_todoController.todoTitleList[index].title}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
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

  Widget memoField(BuildContext context) {
    return Container(
      width: context.mediaQuery.size.width * 0.85,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: (text) {
            _todoController.memoText(text);
          },
          controller: _todoController.memoController.value,
          maxLines: 2,
          cursorColor: primaryColor,
          decoration: InputDecoration(
            hintText: '메모',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
          ),
        ),
      ),
    );
  }

  Widget setTime(BuildContext context) {
    return InkWell(
      customBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onTap: () {
        setTimeRange();
      },
      child: Container(
        height: context.mediaQuery.size.height * 0.1,
        decoration: BoxDecoration(
            color: isDarkMode
                ? darkPrimaryColor.withOpacity(0.9)
                : primaryColor.withOpacity(0.9),
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
      height: context.mediaQuery.size.height * 0.05,
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

  Widget actionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MaterialButton(
            minWidth: context.mediaQuery.size.width * 0.225,
            height: context.mediaQuery.size.height * 0.045,
            onPressed: () {
              _todoController.titleTextController.value.clear();
              _todoController.clearMemoController();
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
                  minWidth: context.mediaQuery.size.width * 0.225,
                  height: context.mediaQuery.size.height * 0.045,
                  onPressed: () async {
                    var todoUpdateDto = TestTodo(
                        uid: widget.todoUid!,
                        ymd: DateTime(
                            _todoController.currentDateTime.value.year,
                            _todoController.currentDateTime.value.month,
                            _todoController.currentDateTime.value.day),
                        title: _todoController.titleTextController.value.text,
                        memoText: _todoController.memoText.value,
                        startHour:
                            _todoController.defaultTime.value.startTime.hour,
                        startMinute:
                            _todoController.defaultTime.value.startTime.minute,
                        endHour: _todoController.defaultTime.value.endTime.hour,
                        endMinute:
                            _todoController.defaultTime.value.endTime.minute,
                        value: _todoController.defaultValue.value,
                        colorIndex: _todoController.selectColorIndex.value,
                        hourMinute: _todoController.defaultValue.value % 60 == 0
                            ? '${_todoController.defaultValue.value.toInt() ~/ 60}시간 '
                            : '${_todoController.defaultValue.value.toInt() ~/ 60}시간 '
                                '${_todoController.defaultValue.value.toInt() % 60}분');
                    await updateFireStore(todoUpdateDto);
                    var todoIndex = _todoController.todoUidList.value.todoList
                        .indexWhere((element) => element.uid == widget.todoUid);
                    if (todoIndex != -1) {
                      _todoController.todoUidList.value.todoList[todoIndex]
                          .value = todoUpdateDto.value;
                      _todoController.todoUidList.value.todoList[todoIndex]
                          .title = todoUpdateDto.title;
                      _todoController.todoUidList.value.todoList[todoIndex]
                          .memoText = todoUpdateDto.memoText;
                      _todoController.todoUidList.value.todoList[todoIndex]
                          .startHour = todoUpdateDto.startHour;
                      _todoController.todoUidList.value.todoList[todoIndex]
                          .startMinute = todoUpdateDto.startMinute;
                      _todoController.todoUidList.value.todoList[todoIndex]
                          .endHour = todoUpdateDto.endHour;
                      _todoController.todoUidList.value.todoList[todoIndex]
                          .endMinute = todoUpdateDto.endMinute;
                      _todoController.todoUidList.value.todoList[todoIndex]
                          .colorIndex = todoUpdateDto.colorIndex;
                      _todoController.todoUidList.value.todoList[todoIndex]
                          .hourMinute = todoUpdateDto.hourMinute;
                      _todoController.todoUidList.value.todoList[todoIndex]
                          .ymd = todoUpdateDto.ymd;
                      _chartController.makeRangeDate();
                      _todoController.clearMemoController();
                      await Get.off(() => Home());
                    }
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
                  minWidth: context.mediaQuery.size.width * 0.225,
                  height: context.mediaQuery.size.height * 0.045,
                  onPressed: () async {
                    var todoAddDto = TestTodo(
                        uid: 'NULL',
                        ymd: DateTime(
                            _todoController.currentDateTime.value.year,
                            _todoController.currentDateTime.value.month,
                            _todoController.currentDateTime.value.day),
                        title: _todoController.titleTextController.value.text,
                        memoText: _todoController.memoText.value,
                        startHour:
                            _todoController.defaultTime.value.startTime.hour,
                        startMinute:
                            _todoController.defaultTime.value.startTime.minute,
                        endHour: _todoController.defaultTime.value.endTime.hour,
                        endMinute:
                            _todoController.defaultTime.value.endTime.minute,
                        value: _todoController.defaultValue.value,
                        colorIndex: _todoController.selectColorIndex.value,
                        hourMinute: _todoController.defaultValue.value % 60 == 0
                            ? '${_todoController.defaultValue.value.toInt() ~/ 60}시간 '
                            : '${_todoController.defaultValue.value.toInt() ~/ 60}시간 '
                                '${_todoController.defaultValue.value.toInt() % 60}분');
                    await addFireStore(todoAddDto);
                    _todoController.addTodo(todoAddDto..uid = currentTodoUid);
                    _chartController.makeRangeDate();
                    await _listController.initSearchResult();
                    _listController.searchTitle('');
                    _todoController.clearMemoController();
                    await Get.offAll(() => Home());
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

  void setTimeRange() async {
    var changeStartTime = _todoController.defaultTime.value.startTime;
    var changeEndTime = _todoController.defaultTime.value.endTime;
    return await showDialog(
      context: context,
      builder: (_) => Padding(
        padding: EdgeInsets.symmetric(vertical: 80),
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
                    minutes: _settingsController.timePickerOfInterval.value),
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
                ticksColor:
                    isDarkMode ? Colors.white.withOpacity(0.8) : primaryColor,
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
                          startTime: changeStartTime, endTime: changeEndTime));
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
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _todoController.initDefaultValue();
  }
}
