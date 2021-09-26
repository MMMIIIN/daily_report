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
                  trailing: Text('Icons made by Tomas Knop from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.home_outlined),
                  trailing: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.home_filled),
                  trailing: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.menu_outlined),
                  trailing: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.menu_filled),
                  trailing: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.trash),
                  trailing: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.settings_outlined),
                  trailing: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.settings_filled),
                  trailing: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.user_man_filled),
                  trailing: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.user_woman_filled),
                  trailing: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.user_woman_outlined),
                  trailing: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.user_woman_circle_outlined),
                  trailing: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.user_man_circle_outlined),
                  trailing: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.user_man_outlined),
                  trailing: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.locked_outlined),
                  trailing: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.locked_filled),
                  trailing: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
                ListTile(
                  leading: Icon(IconsDB.cancle_outlined),
                  trailing: Text('Icons made by Smashicons from www.flaticon.com'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
