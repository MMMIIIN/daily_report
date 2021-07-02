import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/home/controller/home_controller.dart';
import 'package:daily_report/src/repository/todo_repository.dart';
import 'package:get/get.dart';

class InitBinding implements Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => TodoRepository());
    Get.put(HomeController());
    Get.put(TodoController());
  }
}