import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/chart/chart_page.dart';
import 'package:daily_report/src/pages/home/homepage.dart';
import 'package:daily_report/src/pages/list/add_todo.dart';
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
              extendBody: true,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xff34495e)),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
              bottomNavigationBar: BottomAppBar(
                shape: CircularNotchedRectangle(),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: IconButton(
                            icon: Icon(Icons.home,
                                color: _homeController.currentIndex.value == 0
                                    ? Color(0xff95a5a6)
                                    : Color(0xff34495e)),
                            onPressed: () {
                              _homeController.changeTapMenu(0);
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: IconButton(
                            icon: Icon(Icons.storage,
                                color: _homeController.currentIndex.value == 1
                                    ? Color(0xff95a5a6)
                                    : Color(0xff34495e)),
                            onPressed: () {
                              _homeController.changeTapMenu(1);
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: IconButton(
                            icon: Icon(Icons.pie_chart,
                                color: _homeController.currentIndex.value == 2
                                    ? Color(0xff95a5a6)
                                    : Color(0xff34495e)),
                            onPressed: () {
                              _homeController.changeTapMenu(2);
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: IconButton(
                            icon: Icon(Icons.settings,
                                color: _homeController.currentIndex.value == 3
                                    ? Color(0xff95a5a6)
                                    : Color(0xff34495e)),
                            onPressed: () {
                              _homeController.changeTapMenu(3);
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              // bottomNavigationBar: Obx(
              //   () => BottomNavigationBar(
              //     currentIndex: _homeController.currentIndex.value,
              //     onTap: _homeController.changeTapMenu,
              //     // showSelectedLabels: false,
              //     type: BottomNavigationBarType.fixed,
              //     unselectedItemColor: Color(0xff34495e),
              //     selectedItemColor: Color(0xff95afc0),
              //     items: [
              //       BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
              //       BottomNavigationBarItem(
              //           icon: Icon(Icons.storage), label: 'list'),
              //       BottomNavigationBarItem(
              //           icon: Icon(Icons.pie_chart), label: 'favorite'),
              //       BottomNavigationBarItem(
              //           icon: Icon(Icons.settings), label: '설정'),
              //     ],
              //   ),
              // ),
            );
          }
        });
  }
}
