import 'package:daily_report/color.dart';
import 'package:daily_report/icons.dart';
import 'package:daily_report/src/pages/license/license_page.dart';
import 'package:daily_report/src/pages/settings/controller/settings_controller.dart';
import 'package:daily_report/src/pages/settings/select_primary_color_page.dart';
import 'package:daily_report/src/service/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';

final SettingsController _settingsController = Get.put(SettingsController());

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                userInfo(),
                showPercentOrHour(),
                listPageSelect(),
                timePickerOfTime(),
                selectPrimaryColor(),
                chatting(),
                logoutButton(),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(context: context, builder: (_){
                      return AlertDialog(
                        title: Text('정말 계정을 탈퇴하시겠습니까?'),
                        content: Text('해당 계정의 정보는 모두 삭제됩니다.'),
                        actions: [
                          InkWell(
                            splashColor: context.theme.primaryColor.withOpacity(0.4),
                            highlightColor: context.theme.primaryColor.withOpacity(0.2),
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              width: context.mediaQuery.size.width * 0.2,
                              height: context.mediaQuery.size.height * 0.043,
                              decoration: BoxDecoration(
                                  border: Border.all(color: context.theme.primaryColor)),
                              child: Center(
                                child: Text(
                                  '취소',
                                  style: TextStyle(color: context.theme.primaryColor),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              deleteUser();
                            },
                            child: Container(
                              width: context.mediaQuery.size.width * 0.2,
                              height: context.mediaQuery.size.height * 0.043,
                              decoration:
                              BoxDecoration(color: context.theme.primaryColor),
                              child: Center(
                                child: Text(
                                  '계정탈퇴',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    });
                  },
                  child: Container(
                    width: context.mediaQuery.size.width * 0.225,
                    height: context.mediaQuery.size.height * 0.04,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: context.theme.primaryColor),
                    ),
                    child: Center(
                      child: Text(
                        '계정 탈퇴',
                        style: TextStyle(color: context.theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => ShowLicensePage());
                  },
                  child: Text(
                    '오픈소스 라이센스',
                    style: TextStyle(
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                        decorationColor: context.theme.primaryColor,
                        decorationStyle: TextDecorationStyle.double),
                  ),
                ),
                SizedBox(height: 50)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget userInfo() {
    return Row(
      children: [
        Icon(
          IconsDB.user_man_circle_outlined,
          color: Colors.black,
        ),
        Text(
          '  ${FirebaseAuth.instance.currentUser!.email}',
          style: TextStyle(fontSize: 17),
        ),
      ],
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
            labels: ['분', '%'],
            inactiveBgColor: context.theme.primaryColor.withOpacity(0.2),
            activeBgColor: [context.theme.primaryColor],
            initialLabelIndex: _settingsController.isPercentOrHourIndex.value,
            onToggle: (index) {
              _settingsController.setPercentOrHourIndex(index);
            },
          ),
        ],
      ),
    );
  }

  Widget listPageSelect() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('리스트 시간 표시'),
            ToggleSwitch(
              minWidth: 40,
              minHeight: 30,
              totalSwitches: 2,
              labels: ['분', ':'],
              customTextStyles: [
                TextStyle(
                    fontSize: 14,
                    color: _settingsController.listPageIndex.value == 0
                        ? Colors.white
                        : Colors.black),
                TextStyle(
                    fontWeight: FontWeight.w700,
                    color: _settingsController.listPageIndex.value == 0
                        ? Colors.black
                        : Colors.white),
              ],
              inactiveBgColor: context.theme.primaryColor.withOpacity(0.2),
              activeBgColor: [context.theme.primaryColor],
              initialLabelIndex: _settingsController.listPageIndex.value,
              onToggle: (index) {
                _settingsController.setListPageIndex(index);
              },
            ),
          ],
        ),
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
            activeBgColor: [context.theme.primaryColor],
            inactiveBgColor: context.theme.primaryColor.withOpacity(0.2),
            initialLabelIndex: _settingsController.isTimePickerTimeIndex.value,
            onToggle: (index) {
              _settingsController.setTimePickerTimeIndex(index);
            },
          )
        ],
      ),
    );
  }

  Widget selectPrimaryColor() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('테마 컬러 선택'),
          GestureDetector(
            onTap: () {
              Get.off(() => SelectPrimaryColorPage());
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: colorList[
                      _settingsController.selectPrimaryColorIndex.value],
                  borderRadius: BorderRadius.circular(10)),
            ),
          )
        ],
      ),
    );
  }

  Widget chatting() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () {
          showDialog(context: context, builder: (_){
            return AlertDialog(
              title: Text('아래 이메일로 문의주세요'),
              content: Text('wbsldj7645@naver.com'),
              actions: [
                InkWell(
                  splashColor: context.theme.primaryColor.withOpacity(0.4),
                  highlightColor: context.theme.primaryColor.withOpacity(0.2),
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    width: context.mediaQuery.size.width * 0.17,
                    height: context.mediaQuery.size.height * 0.043,
                    decoration: BoxDecoration(
                        border: Border.all(color: context.theme.primaryColor)),
                    child: Center(
                      child: Text(
                        '취소',
                        style: TextStyle(color: context.theme.primaryColor),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: 'wbsldj7645@naver.com'));
                    Get.back();
                    Get.showSnackbar(GetBar(
                      title: 'SUCCESS',
                      message: '이메일 주소가 복사되었습니다.',
                      duration: Duration(seconds: 2),
                      backgroundColor: successColor,
                    ));
                  },
                  child: Container(
                    width: context.mediaQuery.size.width * 0.17,
                    height: context.mediaQuery.size.height * 0.043,
                    decoration:
                    BoxDecoration(color: context.theme.primaryColor),
                    child: Center(
                      child: Text(
                        '복사',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: context.mediaQuery.size.width * 0.3,
                height: context.mediaQuery.size.height * 0.05,
                color: Colors.transparent,
                child: Text('문의하기')),
          ],
        ),
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
                InkWell(
                  splashColor: context.theme.primaryColor.withOpacity(0.4),
                  highlightColor: context.theme.primaryColor.withOpacity(0.2),
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    width: context.mediaQuery.size.width * 0.17,
                    height: context.mediaQuery.size.height * 0.043,
                    decoration: BoxDecoration(
                        border: Border.all(color: context.theme.primaryColor)),
                    child: Center(
                      child: Text(
                        '취소',
                        style: TextStyle(color: context.theme.primaryColor),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Get.back();
                  },
                  child: Container(
                    width: context.mediaQuery.size.width * 0.17,
                    height: context.mediaQuery.size.height * 0.043,
                    decoration:
                        BoxDecoration(color: context.theme.primaryColor),
                    child: Center(
                      child: Text(
                        '확인',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      color: context.theme.primaryColor,
      child: Text(
        '로그아웃',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
      ),
    );
  }
}
