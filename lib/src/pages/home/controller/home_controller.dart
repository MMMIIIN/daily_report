import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/repository/todo_repository.dart';
import 'package:get/get.dart';
import 'package:time_range_picker/time_range_picker.dart';

class HomeController extends GetxController{
  RxInt currentIndex = 0.obs;

  void changeTapMenu(int index){
    currentIndex(index);
  }

  void todoLoad(String uid) async {
    await TodoRepository.to.loadUidTodo(uid);
  }

  void addTodo(String uid, YMD ymd, String title, TimeRange timeRange) async {
    await TodoRepository.to.addTodo(uid, ymd, title, timeRange);
  }
}