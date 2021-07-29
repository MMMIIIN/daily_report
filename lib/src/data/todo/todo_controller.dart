import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_report/src/data/todo/chart_date_data.dart';
import 'package:daily_report/src/data/todo/todo.dart';
import 'package:daily_report/src/repository/todo_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_range_picker/time_range_picker.dart';

enum CATEGORY { DEFAULT, STUDY, SHOPPING, EXERCISE, SLEEP }

class YMD {
  int year;
  int month;
  int day;

  YMD({required this.year, required this.month, required this.day});
}

final now = DateTime.now();
final FirstDay = DateTime(2020, 1, 1);
final LastDay = DateTime(now.year + 5, 12, 31);

class TodoController extends GetxController {
  final currentIndexList = [].obs;
  Rx<DateTime> currentDateTime = DateTime.now().obs;
  final todoList = <Todo>[].obs;
  final Rx<TodoUidList> loadTodoUidList = TodoUidList(todoList: []).obs;
  final Rx<TodoUidList> todoUidList = TodoUidList(todoList: []).obs;
  Rx<TodoUidList> currentUidList = TodoUidList(todoList: []).obs;
  int valueSum = 0;
  var titleTextController = TextEditingController().obs;
  final todoTitleList = <TodoTitle>[].obs;

  Rx<TimeRange> defaultTime = TimeRange(
          startTime: TimeOfDay(hour: 0, minute: 0),
          endTime: TimeOfDay(hour: 0, minute: 0))
      .obs;
  RxDouble defaultValue = 0.0.obs;
  RxInt selectColorIndex = 0.obs;

  void todoUidLoad(String uid) async {
    if (loadTodoUidList.value.todoList.isEmpty) {
      print('uidLoad실행');
      loadTodoUidList(await TodoRepository.to.loadUidTodo(uid));
      initTodoTitleList();
      for (int i = 0; i < loadTodoUidList.value.todoList.length; i++) {
        todoUidCheckAdd(loadTodoUidList.value.todoList[i]);
      }
    }
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

  void addTodo(String uid, YMD ymd, String title, TimeRange timeRange,
      double value, int colorIndex) async {
    await TodoRepository.to
        .addTodo(uid, ymd, title, timeRange, value, colorIndex);
  }

  void setPercent() {
    valueSum = 0;
    for (int i = 0; i < currentIndexList.length; i++) {
      valueSum += currentUidList.value.todoList[i].value;
    }
    for (int j = 0; j < currentIndexList.length; j++) {
      currentUidList.value.todoList[j].percent =
          currentUidList.value.todoList[j].value / valueSum * 100;
    }
  }

  void setCurrentIndex(DateTime time) {
    currentIndexList.clear();
    for (int i = 0; i < todoUidList.value.todoList.length; i++) {
      if (todoUidList.value.todoList[i].ymd == time) {
        currentIndexList.add(i);
      }
    }
    setCurrentList();
    setPercent();
    sortCurrentList();
    print(currentIndexList.value);
  }

  void setCurrentList() {
    currentUidList.value.todoList.clear();
    for (int i = 0; i < currentIndexList.length; i++) {
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
    update();
  }

  void sortTodoList() {
    todoList
        .sort((a, b) => a.time.startTime.hour.compareTo(b.time.startTime.hour));
  }

  double getValue(DateTime _datetime, TimeRange time) {
    var time1 = DateTime(_datetime.year, _datetime.month, _datetime.day,
        time.startTime.hour, time.startTime.minute);
    var time2 = DateTime(_datetime.year, _datetime.month, _datetime.day,
        time.endTime.hour, time.endTime.minute);
    var result = time2.difference(time1).inMinutes;
    if (result < 0) {
      result += 1440;
    }
    return result.toDouble();
  }

  void initTodoTitleList() {
    print('initTitle실행 ');
    for (int i = 0; i < loadTodoUidList.value.todoList.length; i++) {
      addTodoTitle(loadTodoUidList.value.todoList[i].title);
    }
  }

  void addTodoTitle(String text) {
    var index = todoTitleList.indexWhere((element) => element.title == text);
    if (index == -1) {
      todoTitleList.add(TodoTitle(title: text));
    }
  }

  void initUidTodoList() {
    loadTodoUidList.value.todoList.clear();
    FirebaseFirestore.instance
        .collection('todo')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('todos')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        var sampleTodo = TestTodo(
            uid: element['uid'],
            ymd: DateTime(element['year'], element['month'], element['day']),
            title: element['title'],
            startHour: element['startHour'],
            startMinute: element['startMinute'],
            endHour: element['endHour'],
            endMinute: element['endMinute'],
            value: element['value'].toInt(),
            colorIndex: element['color']);
        loadTodoUidList.value.todoList.add(sampleTodo);
      });
    });
    loadTodoUidList.value.todoList.forEach((element) {
      todoUidCheckAdd(element);
    });
    print(loadTodoUidList.value.todoList.length);
    print(todoUidList.value.todoList.length);
  }
}
