import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/chart/chart_page.dart';
import 'package:daily_report/src/pages/home/homepage.dart';
import 'package:daily_report/src/pages/list/list_page.dart';
import 'package:daily_report/src/pages/login/login_page.dart';
import 'package:daily_report/src/pages/settings/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home/controller/home_controller.dart';

class Home extends StatelessWidget {
  final HomeController _homeController = Get.put(HomeController());
  final TodoController _todoController = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> user) {
      if (user.data == null) {
        return LoginPage();
      } else {
        _todoController.todoUidLoad(user.data!.uid);
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
              unselectedItemColor: Color(0xff34495e),
              selectedItemColor: Color(0xff95afc0),
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.storage), label: 'list'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.pie_chart), label: 'favorite'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: '설정'),
              ],
            ),
          ),
        );
      }
    });
  }
}
