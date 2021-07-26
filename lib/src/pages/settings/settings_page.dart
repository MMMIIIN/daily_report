import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_report/src/pages/settings/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';

final SettingsController _settingsController = Get.put(SettingsController());

class SettingsPage extends StatelessWidget {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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
            onPressed: () async {
              await for (var snapshot
                  in firestore.collection('todo').snapshots()) {
                for (var messege in snapshot.docs) {
                  print(messege.data);
                }
              }
            },
            child: Text('click'),
          )
        ],
      ),
    );
  }
}
