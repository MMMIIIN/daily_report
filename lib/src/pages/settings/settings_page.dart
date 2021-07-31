import 'package:cloud_firestore/cloud_firestore.dart';
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
  dynamic error = 'error';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          ToggleSwitch(
            totalSwitches: 2,
            initialLabelIndex: _settingsController.isDarkModeIndex.value,
            onToggle: (index) {
              _settingsController.setDarkModeIndex(index);
            },
          ),
          MaterialButton(
            onPressed: () {
              Get.showSnackbar(GetBar(
                title: 'Success',
                message: error,
                duration: Duration(seconds: 2),
                snackPosition: SnackPosition.BOTTOM,
              ));
            },
            color: Colors.grey,
          ),
          MaterialButton(onPressed: () async{
            await FirebaseFirestore.instance
                .collection('todo')
                .doc('FirebaseAuth.instance.currentUser!.uid')
                .collection('todos')
                .add({
              'title': '_todoController.titleTextController.value.text',
            }).then((value) {
              Get.showSnackbar(GetBar(
                title: 'Success',
                message: 'good!',
                duration: Duration(seconds: 2),
                snackPosition: SnackPosition.BOTTOM,
              ));
            }).catchError((error) =>
                Get.showSnackbar(GetBar(
                  backgroundColor: Colors.redAccent,
                  title: 'ERROR',
                  message: '로그인 정보를 확인하세요',
                  duration: Duration(seconds: 2),
                  snackPosition: SnackPosition.BOTTOM,
                )));
          },
          color: Colors.greenAccent,)
        ],
      ),
    );
  }
}
