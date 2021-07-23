import 'package:daily_report/src/binding/init_binding.dart';
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
  final appdata = GetStorage();
  @override
  Widget build(BuildContext context) {
    appdata.writeIfNull('isDarkMode', false);
    return SimpleBuilder(
      builder: (_){
        bool isDarkMode = appdata.read('isDarkMode');
        return GetMaterialApp(
          title: 'Daily Report',
          theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
          initialRoute: '/',
          initialBinding: InitBinding(),
          getPages: [
            GetPage(name: '/', page: () => App()),
            GetPage(name: 'chart', page: () => ChartPage()),
          ],
        );
      }

    );
  }
}
