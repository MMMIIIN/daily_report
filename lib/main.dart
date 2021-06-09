import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/app.dart';
import 'package:daily_report/src/pages/chart/chart_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Daily Report',
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        primaryColor: Color(0xff686de0),
        textTheme: TextTheme(
          // bodyText1: TextStyle(color: Colors.white),
          // bodyText2: TextStyle(color: Colors.white),

        )
      ),
      initialRoute: '/',
      // initialBinding: BindingsBuilder((){
      //   Get.put(TodoController());
      // }),
      getPages: [
        GetPage(name: '/', page: () => App()),
        GetPage(name: 'chart', page: () => ChartPage()),
      ],
    );
  }
}
