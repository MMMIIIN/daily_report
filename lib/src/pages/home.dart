import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_report/color.dart';
import 'package:daily_report/icons.dart';
import 'package:daily_report/src/pages/chart/chart_page.dart';
import 'package:daily_report/src/pages/home/homepage.dart';
import 'package:daily_report/src/pages/list/add_todo.dart';
import 'package:daily_report/src/pages/list/list_page.dart';
import 'package:daily_report/src/pages/login/login_page.dart';
import 'package:daily_report/src/pages/settings/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'home/controller/home_controller.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeController _homeController = Get.put(HomeController());
  bool isDarkMode = GetStorage().read('isDarkMode');

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
                            Get.to(() => AddTodo(),
                                transition: Transition.fade);
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDarkMode
                                    ? darkPrimaryColor
                                    : primaryColor),
                            child: Icon(
                              Icons.add,
                              color: isDarkMode ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      bottomNavigationBar: BottomAppBar(
                        shape: CircularNotchedRectangle(),
                        child: Obx(
                            () => isDarkMode ? darkModeRow() : lightModeRow()),
                      ),
                    );
                  }
                });
          }
        });
  }

  Widget darkModeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: IconButton(
              icon: Icon(
                _homeController.currentIndex.value == 0
                    ? IconsDB.home_filled
                    : IconsDB.home_outlined,
                size: 22,
              ),
              onPressed: () {
                _homeController.changeTapMenu(0);
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 30.0),
          child: IconButton(
              icon: Icon(_homeController.currentIndex.value == 1
                  ? IconsDB.menu_filled
                  : IconsDB.menu_outlined),
              onPressed: () {
                _homeController.changeTapMenu(1);
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: IconButton(
              icon: Icon(_homeController.currentIndex.value == 2
                  ? IconsDB.pie_chart_filled
                  : IconsDB.pie_chart_outlined),
              onPressed: () {
                _homeController.changeTapMenu(2);
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: IconButton(
              icon: Icon(_homeController.currentIndex.value == 3
                  ? IconsDB.settings_filled
                  : IconsDB.settings_outlined),
              onPressed: () {
                _homeController.changeTapMenu(3);
              }),
        ),
      ],
    );
  }

  Widget lightModeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: IconButton(
              icon: Icon(
                _homeController.currentIndex.value == 0
                    ? IconsDB.home_filled
                    : IconsDB.home_outlined,
                size: 22,
              ),
              onPressed: () {
                _homeController.changeTapMenu(0);
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 30.0),
          child: IconButton(
              icon: Icon(
                _homeController.currentIndex.value == 1
                    ? IconsDB.menu_filled
                    : IconsDB.menu_outlined,
                size: 24,
              ),
              onPressed: () {
                _homeController.changeTapMenu(1);
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: IconButton(
              icon: Icon(
                _homeController.currentIndex.value == 2
                    ? IconsDB.pie_chart_filled
                    : IconsDB.pie_chart_outlined,
                size: 24,
              ),
              onPressed: () {
                _homeController.changeTapMenu(2);
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: IconButton(
              icon: Icon(
                _homeController.currentIndex.value == 3
                    ? IconsDB.settings_filled
                    : IconsDB.settings_outlined,
                size: 24,
              ),
              onPressed: () {
                _homeController.changeTapMenu(3);
              }),
        ),
      ],
    );
  }
}
