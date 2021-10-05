import 'package:daily_report/color.dart';
import 'package:daily_report/src/binding/init_binding.dart';
import 'package:daily_report/src/pages/app.dart';
import 'package:daily_report/src/pages/settings/controller/settings_controller.dart';
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
  await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  runApp(MyApp());
}

final SettingsController _settingsController = Get.put(SettingsController());

class MyApp extends StatelessWidget {
  final appdata = GetStorage();

  @override
  Widget build(BuildContext context) {
    return SimpleBuilder(builder: (_) {
      return Obx(
        () => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Daily Report',
          theme: ThemeData(
              primaryColor:
                  colorList[_settingsController.selectPrimaryColorIndex.value],
              fontFamily: 'Hyemin'),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [const Locale('ko', 'KR')],
          themeMode: ThemeMode.light,
          initialRoute: '/',
          initialBinding: InitBinding(),
          getPages: [
            GetPage(name: '/', page: () => App()),
          ],
        ),
      );
    });
  }
}
