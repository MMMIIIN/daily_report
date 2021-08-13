import 'package:daily_report/color.dart';
import 'package:daily_report/icons.dart';
import 'package:daily_report/src/pages/login/login_page.dart';
import 'package:daily_report/src/pages/settings/controller/settings_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';

final SettingsController _settingsController = Get.put(SettingsController());

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Widget userInfo() {
    return Row(
      children: [
        Icon(
          Icons.person,
          color: primaryColor,
        ),
        Text('${FirebaseAuth.instance.currentUser!.email}'),
      ],
    );
  }

  Widget darkMode() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('다크모드'),
          ToggleSwitch(
            minWidth: 40,
            minHeight: 30,
            totalSwitches: 2,
            labels: ['v', 'v'],
            customTextStyles: [
              TextStyle(
                  color: _settingsController.isDarkModeIndex.value == 0
                      ? Colors.white
                      : Colors.transparent),
              TextStyle(
                  color: _settingsController.isDarkModeIndex.value == 0
                      ? Colors.transparent
                      : primaryColor)
            ],
            inactiveBgColor: _settingsController.isDarkModeIndex.value == 0
                ? primaryColor.withOpacity(0.2)
                : primaryColor.withOpacity(0.7),
            activeBgColor: [
              _settingsController.isDarkModeIndex.value == 0
                  ? Color(0xff34495e)
                  : Color(0xffecf0f1)
            ],
            initialLabelIndex: _settingsController.isDarkModeIndex.value,
            onToggle: (index) {
              _settingsController.setDarkModeIndex(index);
            },
          ),
        ],
      ),
    );
  }

  Widget showPercentOrHour() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('홈 화면 표시'),
          ToggleSwitch(
            minWidth: 40,
            minHeight: 30,
            totalSwitches: 2,
            labels: ['%', 'h'],
            inactiveBgColor: _settingsController.isDarkModeIndex.value == 0
                ? primaryColor.withOpacity(0.2)
                : primaryColor.withOpacity(0.7),
            activeBgColor: [
              _settingsController.isDarkModeIndex.value == 0
                  ? Color(0xff34495e)
                  : Color(0xffecf0f1)
            ],
            initialLabelIndex: _settingsController.isPercentOrHourIndex.value,
            onToggle: (index) {
              _settingsController.setPercentOrHourIndex(index);
            },
          ),
        ],
      ),
    );
  }

  Widget timePickerOfTime() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('시계 설정(분)'),
          ToggleSwitch(
            minWidth: 50,
            minHeight: 25,
            totalSwitches: 5,
            labels: ['5m', '10m', '15m', '20m', '30m'],
            activeBgColor: [
              _settingsController.isDarkModeIndex.value == 0
                  ? Color(0xff34495e)
                  : Color(0xffecf0f1)
            ],
            inactiveBgColor: _settingsController.isDarkModeIndex.value == 0
                ? primaryColor.withOpacity(0.2)
                : primaryColor.withOpacity(0.7),
            initialLabelIndex: _settingsController.isTimePickerTimeIndex.value,
            onToggle: (index) {
              _settingsController.setTimePickerTimeIndex(index);
            },
          )
        ],
      ),
    );
  }

  Widget logoutButton() {
    return MaterialButton(
      elevation: 0.0,
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('로그아웃 하시겠습니까?'),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      Get.back();
                    },
                    elevation: 0.0,
                    color: primaryColor.withOpacity(0.4),
                    child: Text('취소'),
                  ),
                  MaterialButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    elevation: 0.0,
                    color: primaryColor,
                    child: Text('확인'),
                  ),
                ],
              );
            });
        // FirebaseAuth.instance.signOut();
      },
      color: primaryColor,
      child: Text(
        'logOut',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            userInfo(),
            darkMode(),
            showPercentOrHour(),
            timePickerOfTime(),
            logoutButton(),
            MaterialButton(
              onPressed: () {
                Get.to(() => LoginPage());
              },
              color: Colors.cyanAccent,
            )
          ],
        ),
      ),
    );
  }
}
