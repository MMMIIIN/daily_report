import 'package:daily_report/src/data/todo/chart_date_data.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/repository/todo_repository.dart';
import 'package:get/get.dart';
import 'package:time_range_picker/time_range_picker.dart';

class HomeController extends GetxController{
  RxInt currentIndex = 0.obs;
  TestTodoList testUidList = TestTodoList(todoList: []);

  void changeTapMenu(int index){
    currentIndex(index);
  }

  void todoUidLoad(String uid) async {
    print('uidLoad실행');
   testUidList = await TodoRepository.to.loadUidTodo(uid);
   print('testUidList = ${testUidList.todoList[0].day}');
  }

  void addTodo(String uid, YMD ymd, String title, TimeRange timeRange) async {
    await TodoRepository.to.addTodo(uid, ymd, title, timeRange);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }
}