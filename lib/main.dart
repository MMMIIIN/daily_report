import 'package:daily_report/src/binding/init_binding.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/app.dart';
import 'package:daily_report/src/pages/chart/chart_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Daily Report',
      theme: ThemeData(
        primaryColor: Color(0xff34495e),
        textTheme: TextTheme(
        )
      ),
      initialRoute: '/',
      initialBinding: InitBinding(),
      getPages: [
        GetPage(name: '/', page: () => App()),
        GetPage(name: 'chart', page: () => ChartPage()),
      ],
    );
  }
}
