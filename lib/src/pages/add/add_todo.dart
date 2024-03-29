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
import 'package:table_calendar/table_calendar.dart';
import 'package:time_range_picker/time_range_picker.dart';

final ChartController _chartController = Get.put(ChartController());
final TodoController _todoController = Get.put(TodoController());
final ListController _listController = Get.put(ListController());
final SettingsController _settingsController = Get.put(SettingsController());

class AddTodo extends StatefulWidget {
  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final currentDay = DateTime(
      _todoController.currentDateTime.value.year,
      _todoController.currentDateTime.value.month,
      _todoController.currentDateTime.value.day);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  backButton(),
                  selectOfDate(),
                  SizedBox(width: 40, height: 40)
                ],
              ),
              titleField(),
              Obx(() => printTodo()),
              makeRule(),
              memoField(context),
              setTime(),
              Obx(() => printHourMinuteOfValue()),
              colorSelect(),
              completeButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget backButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        Get.back();
      },
      child: Container(
        width: 40,
        height: 40,
        child: Center(
          child: Text(
            '<',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget selectOfDate() {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        var _selectedDay = _todoController.currentDateTime.value;
        showDialog(
          context: context,
          builder: (_) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: Obx(
              () => Dialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TableCalendar(
                        calendarBuilders: CalendarBuilders(
                          selectedBuilder: (context, date, events) => Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: colorList[_settingsController
                                        .selectPrimaryColorIndex.value]
                                    .withOpacity(0.9),
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
                                      Text(
                                        date.day.toString(),
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
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
                            if (_.isNotEmpty) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: markerColorList[_settingsController
                                          .selectPrimaryColorIndex.value]),
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
                        InkWell(
                          splashColor:
                              context.theme.primaryColor.withOpacity(0.4),
                          highlightColor:
                              context.theme.primaryColor.withOpacity(0.2),
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            width: context.mediaQuery.size.width * 0.225,
                            height: context.mediaQuery.size.height * 0.043,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: context.theme.primaryColor)),
                            child: Center(
                              child: Text(
                                '취소',
                                style: TextStyle(
                                    color: context.theme.primaryColor),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _todoController.currentDateTime(
                                _todoController.selectDateTime.value);
                            Get.back();
                          },
                          child: Container(
                            width: context.mediaQuery.size.width * 0.225,
                            height: context.mediaQuery.size.height * 0.043,
                            decoration: BoxDecoration(
                                color: context.theme.primaryColor),
                            child: Center(
                              child: Text(
                                '확인',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
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
      child: Obx(
        () => Container(
          width: context.mediaQuery.size.width * 0.5,
          height: 35,
          decoration: BoxDecoration(
            border: Border.all(color: context.theme.primaryColor),
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
                  color: Colors.black.withOpacity(0.8),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget titleField() {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: context.theme.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          onChanged: (text) {
            _todoController.titleText(text);
          },
          style: TextStyle(color: Colors.black),
          controller: _todoController.titleTextController.value,
          cursorColor: Colors.black,
          decoration: InputDecoration(
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
                borderSide: BorderSide(color: Colors.transparent)),
            hintText: 'ex) 회사',
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.4),
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }

  Widget makeRule() {
    _todoController.clickedRuleAddButton(false);
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
                            color: context.theme.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            onChanged: (text) {
                              _todoController.setMakeRuleTitle(text);
                            },
                            controller:
                                _todoController.makeRuleTitleController.value,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                                suffixIcon:
                                    _todoController.makeRuleTitle.isEmpty
                                        ? null
                                        : IconButton(
                                            splashRadius: 16,
                                            icon: Icon(
                                              IconsDB.cancle_outlined,
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
                                hintText: 'ex) 회사',
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
                              activeColor: context.theme.primaryColor,
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
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                width: context.mediaQuery.size.width * 0.55,
                                height: context.mediaQuery.size.height * 0.05,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: _todoController.checkBoxBool.value
                                      ? context.theme.primaryColor
                                          .withOpacity(0.2)
                                      : context.theme.primaryColor
                                          .withOpacity(0.05),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                        '${_todoController.defaultTime.value.startTime.hour < 12 ? '오전' : '오후'} '
                                        '${_todoController.defaultTime.value.startTime.hour < 13 ? '${_todoController.defaultTime.value.startTime.hour}' : '${_todoController.defaultTime.value.startTime.hour - 12}'} : '
                                        '${_todoController.defaultTime.value.startTime.minute}'),
                                    Text(' ~ '),
                                    Text(
                                        '${_todoController.defaultTime.value.endTime.hour < 12 ? '오전' : '오후'} '
                                        '${_todoController.defaultTime.value.endTime.hour < 13 ? '${_todoController.defaultTime.value.endTime.hour}' : '${_todoController.defaultTime.value.endTime.hour - 12}'} : '
                                        '${_todoController.defaultTime.value.endTime.minute}'),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              splashColor:
                                  context.theme.primaryColor.withOpacity(0.4),
                              highlightColor:
                                  context.theme.primaryColor.withOpacity(0.2),
                              onTap: () {
                                _todoController.makeRuleTitle('');
                                _todoController.makeRuleTitleController.value
                                    .clear();
                                Get.back();
                              },
                              child: Container(
                                width: context.mediaQuery.size.width * 0.225,
                                height: context.mediaQuery.size.height * 0.043,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: context.theme.primaryColor)),
                                child: Center(
                                  child: Text(
                                    '취소',
                                    style: TextStyle(
                                        color: context.theme.primaryColor),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: _todoController
                                          .clickedRuleAddButton.value ==
                                      false
                                  ? () async {
                                      _todoController
                                          .clickedRuleAddButton(true);
                                      await addTodoTitle(
                                        TodoTitle(
                                          title: _todoController
                                              .makeRuleTitle.value,
                                          titleColor: _todoController
                                              .selectColorIndex.value,
                                          boolOfTime: _todoController
                                              .checkBoxBool.value,
                                          timeRange:
                                              _todoController.checkBoxBool.value
                                                  ? _todoController
                                                      .defaultTime.value
                                                  : TimeRange(
                                                      startTime: TimeOfDay(
                                                          hour: 0, minute: 0),
                                                      endTime: TimeOfDay(
                                                          hour: 1, minute: 0),
                                                    ),
                                        ),
                                      );
                                      _todoController.addTodoTitle(
                                        TodoTitle(
                                            title: _todoController
                                                .makeRuleTitle.value,
                                            titleColor: _todoController
                                                .selectColorIndex.value,
                                            uid: currentTodoTitleUid,
                                            timeRange: _todoController
                                                    .checkBoxBool.value
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
                                            boolOfTime: _todoController
                                                .checkBoxBool.value),
                                      );
                                      _todoController.sortTodoTitleList();
                                      _todoController
                                              .titleTextController.value.text =
                                          _todoController.makeRuleTitle.value;
                                      _todoController.titleText(
                                          _todoController.makeRuleTitle.value);
                                      _todoController.makeRuleTitle('');
                                      _todoController
                                          .makeRuleTitleController.value
                                          .clear();
                                      _todoController
                                          .clickedRuleAddButton(false);
                                    }
                                  : null,
                              child: _todoController.clickedRuleAddButton.value
                                  ? Container(
                                      width:
                                          context.mediaQuery.size.width * 0.27,
                                      height: context.mediaQuery.size.height *
                                          0.043,
                                      decoration: BoxDecoration(
                                          color: context.theme.primaryColor
                                              .withOpacity(0.6)),
                                      child: Center(
                                        child: Text(
                                          'loading...',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width:
                                          context.mediaQuery.size.width * 0.225,
                                      height: context.mediaQuery.size.height *
                                          0.043,
                                      decoration: BoxDecoration(
                                          color: context.theme.primaryColor),
                                      child: Center(
                                        child: Text(
                                          '규칙추가',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
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
      height: context.mediaQuery.size.height * 0.2,
      child: ListView.builder(
        itemCount: _todoController.todoTitleList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              _todoController.titleTextController.value.text =
                  _todoController.todoTitleList[index].title;
              _todoController
                  .titleText(_todoController.todoTitleList[index].title);
              _todoController.selectColorIndex(
                  _todoController.todoTitleList[index].titleColor);
              _todoController.todoTitleList[index].boolOfTime
                  ? _todoController.setTime(
                      TimeRange(
                        startTime: TimeOfDay(
                          hour: _todoController
                              .todoTitleList[index].timeRange!.startTime.hour,
                          minute: _todoController
                              .todoTitleList[index].timeRange!.startTime.minute,
                        ),
                        endTime: TimeOfDay(
                          hour: _todoController
                              .todoTitleList[index].timeRange!.endTime.hour,
                          minute: _todoController
                              .todoTitleList[index].timeRange!.endTime.minute,
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
                          color: colorList[
                              _todoController.todoTitleList[index].titleColor],
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
                      InkWell(
                        splashColor:
                            context.theme.primaryColor.withOpacity(0.4),
                        highlightColor:
                            context.theme.primaryColor.withOpacity(0.2),
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          width: context.mediaQuery.size.width * 0.225,
                          height: context.mediaQuery.size.height * 0.043,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: context.theme.primaryColor)),
                          child: Center(
                            child: Text(
                              '취소',
                              style: TextStyle(
                                  color: context.theme.primaryColor,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          deleteTodoTitle(
                              _todoController.todoTitleList[index].uid);
                          _todoController.todoTitleList.removeWhere((element) =>
                              element.uid ==
                              _todoController.todoTitleList[index].uid);
                          Get.back();
                        },
                        child: Container(
                          width: context.mediaQuery.size.width * 0.225,
                          height: context.mediaQuery.size.height * 0.043,
                          decoration:
                              BoxDecoration(color: context.theme.primaryColor),
                          child: Center(
                            child: Text(
                              '규칙 삭제',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            customBorder:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorList[_todoController
                                  .todoTitleList[index].titleColor]),
                        ),
                        Container(
                          width: context.mediaQuery.size.width * 0.35,
                          child: Text(
                            ' ${_todoController.todoTitleList[index].title}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    Text('${_todoController.todoTitleList[index].boolOfTime ? '${_todoController.todoTitleList[index].timeRange!.startTime.hour < 12 ? '오전' : '오후'} '
                        '${_todoController.todoTitleList[index].timeRange!.startTime.hour < 13 ? '${_todoController.todoTitleList[index].timeRange!.startTime.hour}' : '${_todoController.todoTitleList[index].timeRange!.startTime.hour - 12}'} : '
                        '${_todoController.todoTitleList[index].timeRange!.startTime.minute}  - '
                        '${_todoController.todoTitleList[index].timeRange!.endTime.hour < 12 ? '오전' : '오후'} : '
                        '${_todoController.todoTitleList[index].timeRange!.endTime.hour < 13 ? '${_todoController.todoTitleList[index].timeRange!.endTime.hour}' : '${_todoController.todoTitleList[index].timeRange!.endTime.hour - 12}'} : '
                        '${_todoController.todoTitleList[index].timeRange!.endTime.minute}' : ''}'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget memoField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: (text) {
            _todoController.memoText(text);
          },
          textInputAction: TextInputAction.done,
          controller: _todoController.memoController.value,
          maxLines: 2,
          cursorColor: Colors.black,
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

  Widget setTime() {
    return Container(
      width: double.infinity,
      height: context.mediaQuery.size.height * 0.11,
      child: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('시간 설정'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    showDatePicker(
                        DateTime(
                            2022,
                            1,
                            1,
                            _todoController.startTime.value.hour,
                            _todoController.startTime.value.minute),
                        0);
                  },
                  child: Container(
                    width: context.mediaQuery.size.width * 0.3,
                    height: context.mediaQuery.size.height * 0.05,
                    decoration: BoxDecoration(
                      border: Border.all(color: context.theme.primaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                          '${_todoController.startTime.value.hour < 12 ? '오전' : '오후'} '
                          '${_todoController.startTime.value.hour < 13 ? '${_todoController.startTime.value.hour}' : '${_todoController.startTime.value.hour - 12}'} : '
                          '${_todoController.startTime.value.minute}'),
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    showDatePicker(
                        DateTime(2022, 1, 1, _todoController.endTime.value.hour,
                            _todoController.endTime.value.minute),
                        1);
                  },
                  child: Container(
                    width: context.mediaQuery.size.width * 0.3,
                    height: context.mediaQuery.size.height * 0.05,
                    decoration: BoxDecoration(
                      border: Border.all(color: context.theme.primaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                          '${_todoController.endTime.value.hour < 12 ? '오전' : '오후'} '
                          '${_todoController.endTime.value.hour < 13 ? '${_todoController.endTime.value.hour}' : '${_todoController.endTime.value.hour - 12}'} : '
                          '${_todoController.endTime.value.minute}'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget printHourMinuteOfValue() {
    var value = _todoController.getCurrentTimeOfValue();
    if (value < 0) {
      value += 1440;
    }
    if (value < 60) {
      return Text(
        '$value분',
        style: TextStyle(fontSize: 20),
      );
    } else if (value % 60 == 0) {
      return Text(
        '${(value / 60).floor().toDouble().toStringAsFixed(0)}시간',
        style: TextStyle(fontSize: 20),
      );
    } else {
      return Text(
        '${(value / 60).floor().toDouble().toStringAsFixed(0)}시간 ${value % 60}분',
        style: TextStyle(fontSize: 20),
      );
    }
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
                          ? Border.all(width: 3, color: Colors.black)
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

  Widget completeButton() {
    return Obx(
      () => GestureDetector(
        onTap: _todoController.isEditMode.value
            ? _todoController.clickedAddButton.value
                ? null
                : () async {
                    _todoController.clickedAddButton(true);
                    var todoUpdateDto = TestTodo(
                        uid: _todoController.editTodoUid.value,
                        ymd: DateTime(
                            _todoController.currentDateTime.value.year,
                            _todoController.currentDateTime.value.month,
                            _todoController.currentDateTime.value.day),
                        title: _todoController.titleTextController.value.text,
                        memoText: _todoController.memoController.value.text,
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
                        .indexWhere(
                            (element) => element.uid == todoUpdateDto.uid);
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
                      _todoController
                          .initHome(_todoController.currentDateTime.value);
                      _todoController.titleTextController.value.clear();
                      _todoController.titleText('');
                      var titleListIndex = _chartController.titleList
                          .indexWhere((listOfTitle) =>
                              listOfTitle.title == todoUpdateDto.title);
                      if (titleListIndex == -1) {
                        _chartController.titleList
                            .add(TitleList(title: todoUpdateDto.title));
                      }
                      await Get.off(() => Home());
                    }
                  }
            : _todoController.clickedAddButton.value
                ? null
                : () async {
                    _todoController.clickedAddButton(true);
                    var todoAddDto = TestTodo(
                        uid: 'NULL',
                        ymd: DateTime(
                            _todoController.currentDateTime.value.year,
                            _todoController.currentDateTime.value.month,
                            _todoController.currentDateTime.value.day),
                        title: _todoController.titleTextController.value.text,
                        memoText: _todoController.memoController.value.text,
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
                    await _listController.initSearchResult();
                    _todoController.clearMemoController();
                    _todoController
                        .initHome(_todoController.currentDateTime.value);
                    var titleListIndex = _chartController.titleList.indexWhere(
                        (listOfTitle) => listOfTitle.title == todoAddDto.title);
                    if (titleListIndex == -1) {
                      _chartController.titleList
                          .add(TitleList(title: todoAddDto.title));
                    }
                    await Get.offAll(() => Home());
                    _todoController.titleTextController.value.clear();
                    _todoController.titleText('');
                  },
        child: Container(
          width: double.infinity,
          height: context.mediaQuery.size.height * 0.06,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _todoController.clickedAddButton.value
                ? context.theme.primaryColor.withOpacity(0.6)
                : context.theme.primaryColor,
          ),
          child: Center(child: clickedText()),
        ),
      ),
    );
  }

  Widget clickedText() {
    return Obx(
      () => Container(
        width: context.mediaQuery.size.width * 0.4,
        child: _todoController.clickedAddButton.value
            ? Row(
                children: [
                  Transform.scale(
                    scale: 0.5,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  Text(
                    ' loading...',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              )
            : Center(
                child: Container(
                  child: _todoController.isEditMode.value
                      ? Text(
                          '수   정',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        )
                      : Text(
                          '추   가',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
      ),
    );
  }

  void setTimeRange() async {
    var changeStartTime = _todoController.defaultTime.value.startTime;
    var changeEndTime = _todoController.defaultTime.value.endTime;
    return await showDialog(
      context: context,
      builder: (_) => Obx(
        () => Padding(
          padding: EdgeInsets.symmetric(vertical: 80),
          child: Dialog(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TimeRangePicker(
                    use24HourFormat: false,
                    timeTextStyle: TextStyle(
                        fontSize: context.mediaQuery.size.width * 0.06,
                        color: Colors.white),
                    activeTimeTextStyle: TextStyle(
                        fontSize: context.mediaQuery.size.width * 0.06,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    hideButtons: true,
                    clockRotation: 180,
                    paintingStyle: PaintingStyle.fill,
                    fromText: 'START',
                    toText: 'END',
                    interval: Duration(
                        minutes:
                            _settingsController.timePickerOfInterval.value),
                    labels: ['0', '3', '6', '9', '12', '3', '6', '9']
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
                      _todoController.startTime(startTime);
                    },
                    onEndChange: (endTime) {
                      changeEndTime = endTime;
                      _todoController.endTime(endTime);
                    },
                    ticks: 24,
                    handlerRadius: 8,
                    handlerColor: context.theme.primaryColor,
                    backgroundColor:
                        context.theme.primaryColor.withOpacity(0.1),
                    strokeColor: context.theme.primaryColor.withOpacity(0.8),
                    ticksColor: context.theme.primaryColor,
                    labelOffset: 30,
                    rotateLabels: false,
                    padding: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        splashColor:
                            context.theme.primaryColor.withOpacity(0.4),
                        highlightColor:
                            context.theme.primaryColor.withOpacity(0.2),
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          width: context.mediaQuery.size.width * 0.2,
                          height: context.mediaQuery.size.height * 0.043,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: context.theme.primaryColor)),
                          child: Center(
                            child: Text(
                              '취소',
                              style:
                                  TextStyle(color: context.theme.primaryColor),
                            ),
                          ),
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
                        color: context.theme.primaryColor,
                        elevation: 0,
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
        ),
      ),
    );
  }

  void showDatePicker(DateTime dateTime, int changeIndex) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: context.mediaQuery.size.height * 0.35,
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        '취소',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    SizedBox(width: 30),
                    CupertinoButton(
                      onPressed: () {
                        if (changeIndex == 0) {
                          _todoController
                              .startTime(_todoController.dummyStartTime.value);
                          Get.back();
                        } else {
                          _todoController
                              .endTime(_todoController.dummyEndTime.value);
                          Get.back();
                        }
                      },
                      child: Text('확인'),
                    ),
                  ],
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    minuteInterval:
                        _settingsController.timePickerOfInterval.value,
                    initialDateTime: dateTime,
                    onDateTimeChanged: (value) {
                      if (value != null && value != dateTime) {
                        setState(() {
                          if (changeIndex == 0) {
                            _todoController.dummyStartTime(TimeOfDay(
                                hour: value.hour, minute: value.minute));
                          } else {
                            _todoController.dummyEndTime(TimeOfDay(
                                hour: value.hour, minute: value.minute));
                          }
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (_todoController.isEditMode.value == false) {
      _todoController.initCurrentTimeInterval(
          _settingsController.timePickerOfInterval.value);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
