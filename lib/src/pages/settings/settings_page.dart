import 'package:daily_report/src/pages/settings/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:toggle_switch/toggle_switch.dart';

final SettingsController _settingsController = Get.put(SettingsController());

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        ToggleSwitch(
          totalSwitches: 2,
          initialLabelIndex: _settingsController.isDarkModeIndex.value,
          onToggle: (index){
            _settingsController.setDarkModeIndex(index);
          },
        ),
      ],
    ));
  }
}
