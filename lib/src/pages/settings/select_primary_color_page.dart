import 'package:daily_report/color.dart';
import 'package:daily_report/src/pages/home.dart';
import 'package:daily_report/src/pages/settings/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final SettingsController _settingsController = Get.put(SettingsController());

class SelectPrimaryColorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Obx(
        () => SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: Center(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    Get.off(() => Home());
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 30,
                    width: 30,
                    child: Text(
                      '<',
                      style: TextStyle(color: Colors.white, fontSize: 20,
                      fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              backgroundColor:
                  colorList[_settingsController.selectPrimaryColorIndex.value],
              elevation: 0,
              title: Text(
                '테마 색상 선택',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: ListView.builder(
              itemCount: colorList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    _settingsController.setPrimaryColorIndex(index);
                    _settingsController.setPrimaryColor(index);
                  },
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: colorList[index],
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  trailing:
                      _settingsController.selectPrimaryColorIndex.value == index
                          ? Icon(Icons.check)
                          : null,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
