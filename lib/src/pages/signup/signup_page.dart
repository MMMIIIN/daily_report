import 'package:daily_report/icons.dart';
import 'package:daily_report/src/pages/signup/controller/signup_controller.dart';
import 'package:daily_report/src/service/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SignUpPage extends StatelessWidget {
  final SignUpController _signUpController = Get.put(SignUpController());
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  final passwordCheckFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          customBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          onTap: () {
            Get.back();
          },
          child: Container(
            width: 20,
            height: 20,
            child: Center(
              child: Text(
                '<',
                style: TextStyle(
                    color: context.theme.primaryColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Obx(
            () => SingleChildScrollView(
              child: Column(
                children: [
                  customImage(context),
                  SizedBox(
                    height: context.mediaQuery.size.height * 0.03,
                  ),
                  nameField(context),
                  signupEmailField(context),
                  signupPasswordField(context),
                  passwordCheckField(context),
                  genderSwitch(context),
                  SizedBox(
                    height: context.mediaQuery.size.height * 0.05,
                  ),
                  signUpButton(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget customImage(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      width: context.mediaQuery.size.height * 0.2,
      height: context.mediaQuery.size.height * 0.2,
      decoration: BoxDecoration(
        color: context.theme.primaryColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Text(
          'DAILY REPORT',
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: '',
              fontStyle: FontStyle.italic),
        ),
      ),
    );
  }

  Widget nameField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
        decoration: BoxDecoration(
            color: context.theme.primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: _signUpController.genderIndex.value == 1
                  ? Icon(
                      IconsDB.user_woman_outlined,
                      size: 20,
                    )
                  : Icon(
                      IconsDB.user_man_outlined,
                      size: 20,
                    ),
            ),
            Container(
              padding: EdgeInsets.only(left: 5),
              width: context.mediaQuery.size.width * 0.8,
              child: TextField(
                onChanged: (text) {
                  _signUpController.setSignupName(text);
                },
                textInputAction: TextInputAction.next,
                onSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(emailFocus),
                autofocus: true,
                controller: _signUpController.signupNameController.value,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 5),
                  focusColor: Colors.red,
                  hintText: '이름',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontSize: 15,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget signupEmailField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
        decoration: BoxDecoration(
          color: context.theme.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Icon(
                IconsDB.mail_outlined,
                size: 20,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 5),
              width: context.mediaQuery.size.width * 0.8,
              child: TextField(
                onChanged: (text) {
                  _signUpController.setSignupEmail(text);
                  _signUpController.setCheckEmail();
                },
                focusNode: emailFocus,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(passwordFocus),
                obscureText: false,
                cursorColor: Colors.black,
                controller: _signUpController.signupEmailController.value,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 5),
                  errorText: _signUpController.checkEmail.value ||
                          _signUpController.signupEmail.isEmpty
                      ? null
                      : '이메일 형식이 아닙니다.',
                  hintText: 'example@email.com',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontSize: 16,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget signupPasswordField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
        decoration: BoxDecoration(
          color: context.theme.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Icon(
                IconsDB.locked_outlined,
                size: 20,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 5),
              width: context.mediaQuery.size.width * 0.8,
              child: TextField(
                focusNode: passwordFocus,
                onChanged: (text) {
                  _signUpController.setSignupPassword(text);
                  _signUpController.setCheckPassword();
                },
                textInputAction: TextInputAction.next,
                onSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(passwordCheckFocus),
                obscureText: true,
                cursorColor: Colors.black,
                controller: _signUpController.signupPasswordController.value,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 5),
                  errorText: _signUpController.checkPassword.value ||
                          _signUpController.signupPassword.isEmpty
                      ? null
                      : '비밀번호가 너무 짧습니다.',
                  hintText: '비밀번호',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontSize: 15,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget passwordCheckField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
        decoration: BoxDecoration(
          color: context.theme.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Icon(
                IconsDB.locked_filled,
                size: 20,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 5),
              width: context.mediaQuery.size.width * 0.8,
              child: TextField(
                focusNode: passwordCheckFocus,
                onChanged: (text) {
                  _signUpController.setSignupPasswordCheck(text);
                  _signUpController.checkEqualPassword();
                },
                controller: _signUpController.passwordCheckController.value,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => FocusScope.of(context).unfocus(),
                obscureText: true,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 5),
                  hintText: '비밀번호 확인',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontSize: 15,
                  ),
                  errorText: _signUpController.equalPassword.value ||
                          _signUpController.signupPasswordCheck.isEmpty
                      ? null
                      : '비밀번호가 일치하지 않습니다.',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget genderSwitch(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: ToggleSwitch(
        minWidth: double.infinity,
        inactiveBgColor: context.theme.primaryColor.withOpacity(0.2),
        activeBgColor: [context.theme.primaryColor],
        labels: ['남', '여'],
        totalSwitches: 2,
        initialLabelIndex: _signUpController.genderIndex.value,
        onToggle: (index) {
          _signUpController.setGenderIndex(index);
        },
      ),
    );
  }

  Widget signUpButton(BuildContext context) {
    return GestureDetector(
      onTap: _signUpController.allCheck.value
          ? _signUpController.clickedButton.value ? null : () {
              _signUpController.clickedButton(true);
              firebaseAuthSignUp(
                      _signUpController.signupEmail.value,
                      _signUpController.signupPassword.value,
                      _signUpController.signupName.value,
                      _signUpController.genderIndex.value)
                  .then((value) => _signUpController.clickedButton(false));
            }
          : null,
      child: Container(
        width: double.infinity,
        height: context.mediaQuery.size.height * 0.07,
        decoration: BoxDecoration(
          color: _signUpController.allCheck.value
              ? _signUpController.clickedButton.value
                  ? context.theme.primaryColor.withOpacity(0.6)
                  : context.theme.primaryColor
              : context.theme.primaryColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: _signUpController.clickedButton.value
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: 0.5,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  Text(
                    ' loading...',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              )
            : Center(
                child: Text(
                  '회원가입',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
      ),
    );
  }
}
