import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_report/src/data/todo/todo.dart';
import 'package:daily_report/src/pages/list/controller/list_controller.dart';
import 'package:daily_report/src/service/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_range_picker/time_range_picker.dart';

enum CATEGORY { DEFAULT, STUDY, SHOPPING, EXERCISE, SLEEP }

final now = DateTime.now();
final FirstDay = DateTime(2020, 1, 1);
final LastDay = DateTime(now.year + 5, 12, 31);

final ListController _listController = Get.put(ListController());

class TodoController extends GetxController {
  final currentIndexList = [].obs;
  Rx<DateTime> currentDateTime = DateTime.now().obs;
  Rx<DateTime> selectDateTime = DateTime.now().obs;
  final Rx<TodoUidList> loadTodoUidList = TodoUidList(todoList: []).obs;
  final Rx<TodoUidList> todoUidList = TodoUidList(todoList: []).obs;
  Rx<TodoUidList> currentUidList = TodoUidList(todoList: []).obs;
  int valueSum = 0;
  var titleTextController = TextEditingController().obs;
  var makeRuleTitleController = TextEditingController().obs;
  var memoController = TextEditingController().obs;
  final todoTitleList = <TodoTitle>[].obs;
  RxString currentUid = ''.obs;
  RxString titleText = ''.obs;
  RxString makeRuleTitle = ''.obs;
  RxString memoText = ''.obs;
  RxBool checkBoxBool = false.obs;
  RxBool clickedAddButton = false.obs;
  RxBool isEditMode = false.obs;
  RxString editTodoUid = ''.obs;

  Rx<TimeRange> defaultTime = TimeRange(
          startTime: TimeOfDay(hour: 0, minute: 0),
          endTime: TimeOfDay(hour: 1, minute: 0))
      .obs;
  RxInt defaultValue = 0.obs;
  RxInt selectColorIndex = 0.obs;

  void addTodo(TestTodo todo) {
    loadTodoUidList.value.todoList.add(todo);
    todoUidCheckAdd(todo);
    setCurrentIndex(currentDateTime.value);

    titleTextController.value.clear();
  }

  void todoUidCheckAdd(TestTodo data) {
    var addIndex = todoUidList.value.todoList.indexWhere(
        (element) => element.ymd == data.ymd && element.title == data.title);
    if (addIndex != -1) {
      todoUidList.value.todoList[addIndex].value += data.value;
    } else {
      todoUidList.value.todoList.add(data);
    }
  }

  void setHourMinute() {
    for (var i = 0; i < todoUidList.value.todoList.length; i++) {
      if (todoUidList.value.todoList[i].value % 60 == 0) {
        todoUidList.value.todoList[i].hourMinute =
            '${todoUidList.value.todoList[i].value ~/ 60}시간 ';
      } else {
        todoUidList.value.todoList[i].hourMinute =
            '${todoUidList.value.todoList[i].value ~/ 60}시간 '
            '${todoUidList.value.todoList[i].value % 60}분';
      }
    }
  }

  void setPercent() {
    valueSum = 0;
    for (var i = 0; i < currentIndexList.length; i++) {
      valueSum += currentUidList.value.todoList[i].value;
    }
    for (var j = 0; j < currentIndexList.length; j++) {
      currentUidList.value.todoList[j].percent =
          currentUidList.value.todoList[j].value / valueSum * 100;
    }
  }

  void setCurrentIndex(DateTime time) {
    currentIndexList.clear();
    for (var i = 0; i < todoUidList.value.todoList.length; i++) {
      if (todoUidList.value.todoList[i].ymd.year == time.year &&
          todoUidList.value.todoList[i].ymd.month == time.month &&
          todoUidList.value.todoList[i].ymd.day == time.day) {
        currentIndexList.add(i);
      }
    }
    setCurrentList();
    setPercent();
    sortCurrentList();
  }

  void setCurrentList() {
    currentUidList.value.todoList.clear();
    for (var i = 0; i < currentIndexList.length; i++) {
      currentUidList.value.todoList
          .add(todoUidList.value.todoList[currentIndexList[i]]);
    }
  }

  void sortCurrentList() {
    currentUidList.value.todoList
        .sort((a, b) => b.percent.compareTo(a.percent));
  }

  void setTime(TimeRange time) {
    defaultTime.update((val) {
      val!.startTime = time.startTime;
      val.endTime = time.endTime;
    });
  }

  void initDefaultValue() {
    defaultValue(
      getValue(
        currentDateTime.value,
        TimeRange(
            startTime: defaultTime.value.startTime,
            endTime: defaultTime.value.endTime),
      ),
    );
  }

  int getValue(DateTime _datetime, TimeRange time) {
    var time1 = DateTime(_datetime.year, _datetime.month, _datetime.day,
        time.startTime.hour, time.startTime.minute);
    var time2 = DateTime(_datetime.year, _datetime.month, _datetime.day,
        time.endTime.hour, time.endTime.minute);
    var result = time2.difference(time1).inMinutes;
    if (result < 0) {
      result += 1440;
    }
    return result;
  }

  void addTodoTitle(TodoTitle todoTitle) {
    todoTitleList.add(todoTitle);
  }

  Future<void> initUidTodoList() async {
    print('initUid');
    print(FirebaseAuth.instance.currentUser!.uid);
    clearAllData();
    TestTodo sampleTodo;
    await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('todos')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        sampleTodo = TestTodo(
            uid: element['uid'],
            ymd: DateTime(element['year'], element['month'], element['day']),
            title: element['title'],
            memoText: element['memoText'],
            startHour: element['startHour'],
            startMinute: element['startMinute'],
            endHour: element['endHour'],
            endMinute: element['endMinute'],
            value: element['value'].toInt(),
            colorIndex: element['color'],
            hourMinute: element['hourMinute']);
        loadTodoUidList.value.todoList.add(TestTodo(
            uid: sampleTodo.uid,
            ymd: sampleTodo.ymd,
            title: sampleTodo.title,
            memoText: sampleTodo.memoText,
            startHour: sampleTodo.startHour,
            startMinute: sampleTodo.startMinute,
            endHour: sampleTodo.endHour,
            endMinute: sampleTodo.endMinute,
            value: sampleTodo.value,
            colorIndex: sampleTodo.colorIndex,
            hourMinute: sampleTodo.hourMinute));
      });
      loadTodoUidList.value.todoList.forEach((element) {
        todoUidCheckAdd(element);
      });
    });
    setHourMinute();
  }

  void clearAllData() {
    loadTodoUidList.value.todoList.clear();
    currentIndexList.clear();
    todoUidList.value.todoList.clear();
    todoTitleList.clear();
  }

  void setMakeRuleTitle(String title) {
    makeRuleTitle(title);
  }

  Future<void> initTodoTitleList() async {
    todoTitleList.addAll(await getTodoTitleData());
    sortTodoTitleList();
  }

  void initCheckBoxBool() {
    checkBoxBool(false);
  }

  void todoDelete(String todoUid) async {
    loadTodoUidList.value.todoList
        .removeWhere((element) => element.uid == todoUid);
    todoUidList.value.todoList.clear();
    loadTodoUidList.value.todoList.forEach((element) {
      todoUidCheckAdd(element);
    });
    _listController.searchTitle('');
  }

  void initTodo() {
    initUidTodoList();
    initTodoTitleList();
  }

  void initData() {
    var initData = [
      TestTodo(
          uid: 'initData',
          ymd: DateTime.now(),
          title: 'ex) 회사',
          startHour: 9,
          startMinute: 0,
          endHour: 18,
          endMinute: 0,
          value: 540,
          colorIndex: 1,
          hourMinute: '9시간'),
      TestTodo(
          uid: 'initData1',
          ymd: DateTime.now(),
          title: 'ex) 운동',
          startHour: 19,
          startMinute: 0,
          endHour: 21,
          endMinute: 0,
          value: 120,
          colorIndex: 3,
          hourMinute: '2시간'),
    ];
    loadTodoUidList.value.todoList.addAll(initData);
    todoUidList.value.todoList.addAll(initData);
    todoTitleList.addAll([
      TodoTitle(title: 'ex) 꾹 눌러서 삭제', titleColor: 0, uid: 'initData'),
      TodoTitle(
        title: 'ex) 회사',
        titleColor: 1,
        uid: 'initData1',
        boolOfTime: true,
        timeRange: TimeRange(
          startTime: TimeOfDay(hour: 9, minute: 0),
          endTime: TimeOfDay(hour: 18, minute: 0),
        ),
      ),
      TodoTitle(
        title: 'ex) 밥',
        titleColor: 2,
        uid: 'initData2',
      ),
      TodoTitle(
        title: 'ex) 운동',
        titleColor: 3,
        uid: 'initData3',
        boolOfTime: true,
        timeRange: TimeRange(
          startTime: TimeOfDay(hour: 19, minute: 0),
          endTime: TimeOfDay(hour: 21, minute: 0),
        ),
      ),
      TodoTitle(
        title: 'ex) 공부',
        titleColor: 4,
        uid: 'initData4',
      ),
    ]);
    // todoTitleList.add(
    //   TodoTitle(
    //     title: '회사',
    //     titleColor: 1,
    //     uid: 'initData1',
    //     boolOfTime: true,
    //     timeRange: TimeRange(
    //       startTime: TimeOfDay(hour: 9, minute: 0),
    //       endTime: TimeOfDay(hour: 18, minute: 0),
    //     ),
    //   ),
    // );
  }

  void clearMemoController() {
    memoText('');
    memoController.value.clear();
  }

  void sortTodoTitleList() {
    todoTitleList.sort((a, b) => a.titleColor.compareTo(b.titleColor));
  }

  void initHome(DateTime dateTime) {
    currentDateTime(dateTime);
    setCurrentIndex(dateTime);
  }

  String getOfDay(int weekday) {
    switch (weekday) {
      case 1:
        return '(월)';
      case 2:
        return '(화)';
      case 3:
        return '(수)';
      case 4:
        return '(목)';
      case 5:
        return '(금)';
      case 6:
        return '(토)';
      case 7:
        return '(일)';
      default:
        return '';
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (FirebaseAuth.instance.currentUser != null) {
      initUidTodoList();
      initTodoTitleList();
    }
  }
}
