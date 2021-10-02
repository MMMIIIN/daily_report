import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_report/color.dart';
import 'package:daily_report/icons.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/chart/chart_page.dart';
import 'package:daily_report/src/pages/home/homepage.dart';
import 'package:daily_report/src/pages/list/add_todo.dart';
import 'package:daily_report/src/pages/list/list_page.dart';
import 'package:daily_report/src/pages/login/login_page.dart';
import 'package:daily_report/src/pages/settings/controller/settings_controller.dart';
import 'package:daily_report/src/pages/settings/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home/controller/home_controller.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

final TodoController _todoController = Get.put(TodoController());
final HomeController _homeController = Get.put(HomeController());
final SettingsController _settingsController = Get.put(SettingsController());

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> user) {
        if (user.data == null) {
          return LoginPage();
        } else {
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(
                    'user/${FirebaseAuth.instance.currentUser!.uid}/todos')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.none) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Scaffold(
                  resizeToAvoidBottomInset: false,
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
                    child: GestureDetector(
                      onTap: () {
                        _todoController.isEditMode(false);
                        _todoController.clickedAddButton(false);
                        Get.to(() => AddTodo(), transition: Transition.fade);
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorList[_settingsController
                                .selectPrimaryColorIndex.value]),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  bottomNavigationBar: BottomAppBar(
                    shape: CircularNotchedRectangle(),
                    child: Obx(() => lightModeRow()),
                  ),
                );
              }
            },
          );
        }
      },
    );
  }

  Widget lightModeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            _homeController.changeTapMenu(0);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Container(
              color: Colors.transparent,
              width: context.mediaQuery.size.width * 0.15,
              height: context.mediaQuery.size.height * 0.06,
              child: Column(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        _homeController.currentIndex.value == 0
                            ? IconsDB.home_filled
                            : IconsDB.home_outlined,
                        size: 22,
                        color: colorList[
                            _settingsController.selectPrimaryColorIndex.value],
                      ),
                    ),
                  ),
                  Text(
                    '홈',
                    style: TextStyle(
                        color: context.theme.primaryColor, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            _homeController.changeTapMenu(1);
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Container(
              color: Colors.transparent,
              width: context.mediaQuery.size.width * 0.15,
              height: context.mediaQuery.size.height * 0.06,
              child: Column(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        _homeController.currentIndex.value == 1
                            ? IconsDB.menu_filled
                            : IconsDB.menu_outlined,
                        size: 24,
                        color: colorList[
                            _settingsController.selectPrimaryColorIndex.value],
                      ),
                    ),
                  ),
                  Text(
                    '리스트',
                    style: TextStyle(
                        color: context.theme.primaryColor, fontSize: 13),
                  )
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            _homeController.changeTapMenu(2);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Container(
              color: Colors.transparent,
              width: context.mediaQuery.size.width * 0.15,
              height: context.mediaQuery.size.height * 0.06,
              child: Column(
                children: [
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        _homeController.currentIndex.value == 2
                            ? IconsDB.custom_chart_filled
                            : IconsDB.custom_chart_outlined,
                        size: 35,
                        color: colorList[
                            _settingsController.selectPrimaryColorIndex.value],
                      ),
                    ),
                  ),
                  Text(
                    '통계',
                    style: TextStyle(
                        color: context.theme.primaryColor, fontSize: 13),
                  )
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            _homeController.changeTapMenu(3);
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Container(
              color: Colors.transparent,
              width: context.mediaQuery.size.width * 0.15,
              height: context.mediaQuery.size.height * 0.06,
              child: Column(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        _homeController.currentIndex.value == 3
                            ? IconsDB.settings_filled
                            : IconsDB.settings_outlined,
                        size: 24,
                        color: colorList[
                            _settingsController.selectPrimaryColorIndex.value],
                      ),
                    ),
                  ),
                  Text(
                    '설정',
                    style: TextStyle(
                        color: context.theme.primaryColor, fontSize: 13),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
