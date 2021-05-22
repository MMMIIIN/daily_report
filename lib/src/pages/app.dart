import 'package:daily_report/src/pages/chart/chart_page.dart';
import 'package:daily_report/src/pages/home/controller/home_controller.dart';
import 'package:daily_report/src/pages/home/homepage.dart';
import 'package:daily_report/src/pages/list/list_page.dart';
import 'package:daily_report/src/pages/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  final HomeController _homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xffdff9fb),
      body: Obx(() {
        switch (_homeController.currentIndex.value) {
          case 0:
            return HomePage();
          case 1:
            return ListPage();
          case 2:
            return ChartPage();
          case 3:
            return SettingsPage();
        }
        return Container();
      }),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: _homeController.currentIndex.value,
          onTap: _homeController.changeTapMenu,
          showSelectedLabels: false,
          type: BottomNavigationBarType.shifting,
          unselectedItemColor: Color(0xff686de0),
          selectedItemColor: Color(0xff95afc0),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(icon: Icon(Icons.storage), label: 'list'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: 'favorite'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: '설정'),
          ],
        ),
      ),
    );
  }
}