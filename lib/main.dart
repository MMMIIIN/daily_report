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
        // primarySwatch: Colors.blue,
        primaryColor: Color(0xff686de0),
        textTheme: TextTheme(
          // bodyText1: TextStyle(color: Colors.white),
          // bodyText2: TextStyle(color: Colors.white),

        )
      ),
      initialRoute: '/',
      initialBinding: InitBinding(),
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
