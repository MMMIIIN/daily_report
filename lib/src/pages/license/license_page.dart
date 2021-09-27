import 'package:daily_report/icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowLicensePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(child: LicensePage()),
            Expanded(
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Get.to(() => IconLicense());
                    },
                    title: Text('Icon License'),
                  ),
                  ListTile(
                    title: Text('DGB대구은행 IM혜민체'),
                    subtitle: Text(
                        'Copyright c DGB Daegu Bank. All Rights Reserved.'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IconLicense extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Icon License'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(IconsDB.mail_outlined),
                  title: Text('Icons made by Tomas Knop from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.home_outlined),
                  title: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.home_filled),
                  title: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.menu_outlined),
                  title: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.menu_filled),
                  title: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.trash),
                  title: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.settings_outlined),
                  title: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.settings_filled),
                  title: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.user_man_filled),
                  title: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.user_woman_filled),
                  title: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.user_woman_outlined),
                  title: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.user_woman_circle_outlined),
                  title: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.user_man_circle_outlined),
                  title: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.user_man_outlined),
                  title: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.locked_outlined),
                  title: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.locked_filled),
                  title: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.cancle_outlined),
                  title: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.custom_chart_outlined,size: 35),
                  title: Text('Icons made by SeongXi'),
                ),
                ListTile(
                  leading: Icon(IconsDB.custom_chart_filled,size: 35),
                  title: Text('Icons made by SeongXi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
