import 'package:daily_report/src/data/todo/todo.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final TodoController _todoController = Get.put(TodoController());

class ListController extends GetxController {
  Rx<TodoUidList> searchTodoList = TodoUidList(todoList: []).obs;
  final selectedDays = <DateTime>[].obs;
  final searchResult = <TestTodo>[].obs;
  var searchTitleController = TextEditingController().obs;
  RxString searchTerm = ''.obs;

  Future<void> initSearchResult() async{
    clearAllData();
    searchResult.addAll(searchTitle(''));
  }

  List<TestTodo> searchTitle(String text) {
    searchTodoList.value.todoList.clear();
    searchResult.clear();
    var result = _todoController.loadTodoUidList.value.todoList
        .where((element) => element.title.contains(text))
        .toList();
    result.sort((a, b) => a.startHour.compareTo(b.startHour));
    result.sort((a, b) => a.ymd.compareTo(b.ymd));
    searchTodoList.value.todoList.addAll(result);
    searchResult.addAll(result);
    return result;
  }

  void setSearchTodoList(List<DateTime> _dateTime) {
    searchTodoList.value.todoList.clear();
    _dateTime.forEach((element) {
      searchTodoList.value.todoList.addAll(
          _todoController.loadTodoUidList.value.todoList.where((todo) =>
              todo.ymd.year == element.year &&
              todo.ymd.month == element.month &&
              todo.ymd.day == element.day));
    });
    searchTodoList.value.todoList
        .sort((a, b) => a.startHour.compareTo(b.startHour));
    searchTodoList.value.todoList.sort((a, b) => a.ymd.compareTo(b.ymd));
  }

  void clearAllData() {
    searchTodoList.value.todoList.clear();
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
    initSearchResult();
  }
}
