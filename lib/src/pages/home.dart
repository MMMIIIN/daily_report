import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_report/color.dart';
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

class Home extends StatelessWidget {
  final HomeController _homeController = Get.put(HomeController());
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference todo = FirebaseFirestore.instance
      .collection('todo')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('todos');

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = GetStorage().read('isDarkMode');
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> user) {
          if (user.data == null) {
            return LoginPage();
          } else {
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(
                        'todo/${FirebaseAuth.instance.currentUser!.uid}/todos')
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
                                shape: BoxShape.circle, color: primaryColor),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      bottomNavigationBar: BottomAppBar(
                        shape: CircularNotchedRectangle(),
                        child: Obx(
                          () => isDarkMode
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: IconButton(
                                          icon: _homeController
                                                      .currentIndex.value ==
                                                  0
                                              ? Icon(Icons.home,
                                                  color: (_homeController
                                                              .currentIndex
                                                              .value ==
                                                          0)
                                                      ? Colors.white
                                                      : Colors.grey)
                                              : Icon(Icons.home_outlined,
                                                  color: (_homeController
                                                              .currentIndex
                                                              .value ==
                                                          0)
                                                      ? Colors.white
                                                      : Colors.grey),
                                          onPressed: () {
                                            _homeController.changeTapMenu(0);
                                          }),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 30.0),
                                      child: IconButton(
                                          icon: _homeController
                                                      .currentIndex.value ==
                                                  1
                                              ? Icon(Icons.storage,
                                                  color: _homeController
                                                              .currentIndex
                                                              .value ==
                                                          1
                                                      ? Colors.white
                                                      : Colors.grey)
                                              : Icon(Icons.storage_outlined,
                                                  color: _homeController
                                                              .currentIndex
                                                              .value ==
                                                          1
                                                      ? Colors.white
                                                      : Colors.grey),
                                          onPressed: () {
                                            _homeController.changeTapMenu(1);
                                          }),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 30.0),
                                      child: IconButton(
                                          icon: _homeController
                                                      .currentIndex.value ==
                                                  2
                                              ? Icon(Icons.pie_chart,
                                                  color: _homeController
                                                              .currentIndex
                                                              .value ==
                                                          2
                                                      ? Colors.white
                                                      : Colors.grey)
                                              : Icon(
                                                  Icons
                                                      .pie_chart_outline_rounded,
                                                  color: _homeController
                                                              .currentIndex
                                                              .value ==
                                                          2
                                                      ? Colors.white
                                                      : Colors.grey),
                                          onPressed: () {
                                            _homeController.changeTapMenu(2);
                                          }),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 15.0),
                                      child: IconButton(
                                          icon: _homeController
                                                      .currentIndex.value ==
                                                  3
                                              ? Icon(Icons.settings,
                                                  color: _homeController
                                                              .currentIndex
                                                              .value ==
                                                          3
                                                      ? Colors.white
                                                      : Colors.grey)
                                              : Icon(Icons.settings_outlined,
                                                  color: _homeController
                                                              .currentIndex
                                                              .value ==
                                                          3
                                                      ? Colors.white
                                                      : Colors.grey),
                                          onPressed: () {
                                            _homeController.changeTapMenu(3);
                                          }),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: IconButton(
                                          icon: Icon(Icons.home,
                                              color: (_homeController
                                                          .currentIndex.value ==
                                                      0)
                                                  ? Color(0xff95a5a6)
                                                  : primaryColor),
                                          onPressed: () {
                                            _homeController.changeTapMenu(0);
                                          }),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 30.0),
                                      child: IconButton(
                                          icon: Icon(Icons.storage,
                                              color: _homeController
                                                          .currentIndex.value ==
                                                      1
                                                  ? Color(0xff95a5a6)
                                                  : primaryColor),
                                          onPressed: () {
                                            _homeController.changeTapMenu(1);
                                          }),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 30.0),
                                      child: IconButton(
                                          icon: Icon(Icons.pie_chart,
                                              color: _homeController
                                                          .currentIndex.value ==
                                                      2
                                                  ? Color(0xff95a5a6)
                                                  : primaryColor),
                                          onPressed: () {
                                            _homeController.changeTapMenu(2);
                                          }),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 15.0),
                                      child: IconButton(
                                          icon: Icon(Icons.settings,
                                              color: _homeController
                                                          .currentIndex.value ==
                                                      3
                                                  ? Color(0xff95a5a6)
                                                  : primaryColor),
                                          onPressed: () {
                                            _homeController.changeTapMenu(3);
                                          }),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    );
                  }
                });
          }
        });
  }
}
