import 'package:daily_report/color.dart';
import 'package:daily_report/icons.dart';
import 'package:daily_report/src/pages/login/login_page.dart';
import 'package:daily_report/src/pages/settings/controller/settings_controller.dart';
import 'package:daily_report/src/pages/signup/signup_page.dart';
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
  final isDarkMode = _settingsController.isDarkModeIndex.value == 1;

  Widget userInfo() {
    return Row(
      children: [
        Icon(
          IconsDB.user_man_circle_outlined,
          color: isDarkMode ? Colors.white : primaryColor,
        ),
        Text(
          '  ${FirebaseAuth.instance.currentUser!.email}',
          style: TextStyle(fontSize: 17),
        ),
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
                  color: isDarkMode
                      ? Colors.transparent
                      : Colors.white),
              TextStyle(
                  color: isDarkMode
                      ? primaryColor
                      : Colors.transparent)
            ],
            inactiveBgColor: isDarkMode
                ? primaryColor.withOpacity(0.7)
                : primaryColor.withOpacity(0.2),
            activeBgColor: [
              isDarkMode
                  ? darkPrimaryColor
                  : primaryColor
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
            inactiveBgColor: isDarkMode
                ? primaryColor.withOpacity(0.7)
                : primaryColor.withOpacity(0.2),
            activeBgColor: [
              isDarkMode
                  ? darkPrimaryColor
                  : primaryColor
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
              isDarkMode
                  ? darkPrimaryColor
                  : primaryColor
            ],
            inactiveBgColor: isDarkMode
                ? primaryColor.withOpacity(0.7)
                : primaryColor.withOpacity(0.2),
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
                      Get.back();
                    },
                    elevation: 0.0,
                    color: primaryColor,
                    child: Text('확인'),
                  ),
                ],
              );
            });
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
            ),
            MaterialButton(
              onPressed: () {
                Get.to(() => SignUpPage());
              },
              color: Colors.deepPurpleAccent,
            ),
            MaterialButton(
              onPressed: () {
                Get.showSnackbar(GetBar(
                  title: 'SUCCESS',
                  message: '성공적으로 삭제되었습니다.',
                  duration: Duration(
                    seconds: 2
                  ),
                  backgroundColor: Color(0xff1dd1a1),
                ));
              },
              child: Text('forgot'),
            ),
            MaterialButton(
              onPressed: () {
                Get.showSnackbar(GetBar(
                  title: 'ERROR',
                  message: 'ERROR',
                  duration: Duration(
                      seconds: 2
                  ),
                  backgroundColor: Color(0xffee5253),
                ));
              },
              child: Text('forgot'),
            ),
          ],
        ),
      ),
    );
  }
}
