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
          MaterialButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('todo')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('todos')
                  .get()
                  .then((value) => value.docs.forEach((element) {
                        print(element.id);
                      }));
            },
            color: Colors.redAccent,
          ),
          MaterialButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('todo')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('todos')
                  .get()
                  .then((value) => value.docs.forEach((element) {
                        FirebaseFirestore.instance
                            .collection('todo')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('todos')
                            .doc(element.id)
                            .update({'uid': element.id});
                      }));
            },
            color: Colors.green,
          )
        ],
      ),
    );
  }
}
