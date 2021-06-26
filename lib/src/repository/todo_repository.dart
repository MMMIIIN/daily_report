import 'package:daily_report/src/data/todo/chart_date_data.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:get/get.dart';
import 'package:time_range_picker/time_range_picker.dart';

class TodoRepository extends GetConnect {
  static TodoRepository get to => Get.find();

  Future loadUidTodo(String uid) async {
    httpClient.baseUrl = 'http://localhost:3000';
    String url = '/todo/$uid';
    final response = await get(url);
    if (response.status.hasError) {
      return Future.error(response.statusText ?? 'error');
    } else {
      if (response.body != null && response.body.length > 0) {
        print(response.statusCode);
        TestTodoList todoList = TestTodoList.fromJson(response.body);
        print(response.body);
        print(todoList);
      }
    }
  }

  Future addTodo(String uid,YMD ymd, String title, TimeRange timeRange) async {
    httpClient.baseUrl = 'http://localhost:3000';
    String url = '/todo/save';
    final response = await post(url, {
      "uid": uid,
      "year": ymd.year,
      "month": ymd.month,
      "day": ymd.day,
      "title": "$title",
      "startHour": timeRange.startTime.hour,
      "startMinute": timeRange.startTime.minute,
      "endHour": timeRange.endTime.hour,
      "endMinute": timeRange.endTime.minute
    });
    print(response);
    if (response.status.hasError) {
      return Future.error(response.statusText ?? 'error');
    } else {
      if (response.body != null && response.body.length > 0) {
        print(response.statusCode);
      }
    }
  }
}
