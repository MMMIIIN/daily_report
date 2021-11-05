import 'package:daily_report/icons.dart';
import 'package:daily_report/src/pages/community/controller/community_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final CommunityController _communityController = Get.put(CommunityController());

class CommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Obx(
              () => Text(
                  '${CATEGORY_LIST.values[_communityController.currentCategoryIndex.value].title}'),
            ),
            elevation: 0,
          ),
          drawer: Drawer(
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.white),
                  accountName: Text(
                    '${FirebaseAuth.instance.currentUser!.displayName}',
                    style: TextStyle(color: Colors.black),
                  ),
                  accountEmail: Text(
                    '${FirebaseAuth.instance.currentUser!.email}',
                    style: TextStyle(color: Colors.black),
                  ),
                  currentAccountPicture: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(),
                        color: Colors.white),
                    child: Icon(IconsDB.user_man_outlined),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: CATEGORY_LIST.values.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          _communityController.currentCategoryIndex(index);
                          Get.back();
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '${CATEGORY_LIST.values[index].title}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          body: Obx(() {
            switch (_communityController.currentCategoryIndex.value) {
              case 0:
                return Container(
                  child: Text('0'),
                );
              case 1:
                return MyLife();
            }
            return Container();
          })),
    );
  }
}

class MyLife extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView.builder(
        itemCount: 5,
          itemBuilder: (context,index){
        return Container(
          child: Text('$index'),
        );
      }),
    );
  }
}
