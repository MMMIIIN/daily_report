import 'package:daily_report/color.dart';
import 'package:daily_report/src/binding/init_binding.dart';
import 'package:daily_report/src/pages/app.dart';
import 'package:daily_report/src/pages/chart/chart_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final appdata = GetStorage();

  @override
  Widget build(BuildContext context) {
    appdata.writeIfNull('isDarkMode', false);
    return SimpleBuilder(builder: (_) {
      bool isDarkMode = appdata.read('isDarkMode');
      return GetMaterialApp(
        // debugShowCheckedModeBanner: false,
        title: 'Daily Report',
        darkTheme: ThemeData(brightness: Brightness.dark, fontFamily: 'Hyemin'),
        theme: ThemeData(
            primaryColor: primaryColor,
            fontFamily: 'Hyemin'),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [const Locale('ko', 'KR')],
        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        initialRoute: '/',
        initialBinding: InitBinding(),
        getPages: [
          GetPage(name: '/', page: () => App()),
          GetPage(name: 'chart', page: () => ChartPage()),
        ],
      );
    });
  }
}
