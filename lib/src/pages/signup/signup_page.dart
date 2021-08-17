import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_report/color.dart';
import 'package:daily_report/icons.dart';
import 'package:daily_report/src/pages/home.dart';
import 'package:daily_report/src/pages/signup/signup_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SignUpPage extends StatelessWidget {
  final SignUpController _signUpController = Get.put(SignUpController());
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  final passwordCheckFocus = FocusNode();

  Widget nameField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
        decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _signUpController.genderIndex.value == 1
                ? Icon(
                    IconsDB.user_woman_outlined,
                    size: 20,
                  )
                : Icon(
                    IconsDB.user_man_outlined,
                    size: 20,
                  ),
            Container(
              padding: EdgeInsets.only(left: 5),
              width: Get.mediaQuery.size.width * 0.8,
              child: TextField(
                onChanged: (text) {
                  _signUpController.setSignupName(text);
                },
                textInputAction: TextInputAction.next,
                onSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(emailFocus),
                autofocus: true,
                controller: _signUpController.signupNameController.value,
                cursorColor: primaryColor,
                decoration: InputDecoration(
                  focusColor: Colors.red,
                  hintText: '이름',
                  hintStyle: TextStyle(
                    color: primaryColor,
                    fontSize: 15,
                  ),
                  enabledBorder: UnderlineInputBorder(
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
          color: primaryColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              IconsDB.mail_outlined,
              size: 20,
            ),
            Container(
              padding: EdgeInsets.only(left: 5),
              width: Get.mediaQuery.size.width * 0.8,
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
                cursorColor: primaryColor,
                controller: _signUpController.signupEmailController.value,
                decoration: InputDecoration(
                  errorText: _signUpController.checkEmail.value
                      ? null
                      : '이메일 형식이 아닙니다.',
                  hintText: 'example@email.com',
                  hintStyle: TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                  ),
                  focusColor: primaryColor,
                  enabledBorder: UnderlineInputBorder(
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
          color: primaryColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              IconsDB.locked_outlined,
              size: 20,
            ),
            Container(
              padding: EdgeInsets.only(left: 5),
              width: Get.mediaQuery.size.width * 0.8,
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
                cursorColor: primaryColor,
                controller: _signUpController.signupPasswordController.value,
                decoration: InputDecoration(
                  errorText: _signUpController.checkPassword.value
                      ? null
                      : '비밀번호가 너무 짧습니다.',
                  hintText: '비밀번호',
                  hintStyle: TextStyle(
                    color: primaryColor,
                    fontSize: 15,
                  ),
                  focusColor: primaryColor,
                  enabledBorder: UnderlineInputBorder(
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
          color: primaryColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              IconsDB.locked_filled,
              size: 20,
            ),
            Container(
              padding: EdgeInsets.only(left: 5),
              width: Get.mediaQuery.size.width * 0.8,
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
                cursorColor: primaryColor,
                decoration: InputDecoration(
                  hintText: '비밀번호 확인',
                  hintStyle: TextStyle(
                    color: primaryColor,
                    fontSize: 15,
                  ),
                  errorText: _signUpController.equalPassword.value
                      ? null
                      : '비밀번호가 일치하지 않습니다.',
                  enabledBorder: UnderlineInputBorder(
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

  Widget genderSwitch() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: ToggleSwitch(
        minWidth: double.infinity,
        inactiveBgColor: primaryColor.withOpacity(0.2),
        activeBgColor: [primaryColor],
        labels: ['남', '여'],
        totalSwitches: 2,
        initialLabelIndex: _signUpController.genderIndex.value,
        onToggle: (index) {
          _signUpController.setGenderIndex(index);
        },
      ),
    );
  }

  Widget cancleButton() {
    return MaterialButton(
      onPressed: () {
        Get.back();
      },
      highlightColor: Colors.white.withOpacity(0.9),
      splashColor: Colors.transparent,
      color: primaryColor.withOpacity(0.2),
      elevation: 0,
      child: Text(
        '취소',
        style: TextStyle(color: primaryColor),
      ),
    );
  }

  Widget signUpButton() {
    return MaterialButton(
      color: _signUpController.allCheck.value
          ? primaryColor
          : primaryColor.withOpacity(0.3),
      elevation: 0,
      onPressed: () {
        signUp(_signUpController.signupEmailController.value.text,
            _signUpController.signupPasswordController.value.text);
      },
      child: Text(
        '회원가입',
        style: TextStyle(
            color:
                _signUpController.allCheck.value ? Colors.white : primaryColor),
      ),
    );
  }

  void signUp(String userEmail, String userPw) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: userEmail,
        password: userPw,
      )
          .then((value) {
        FirebaseAuth.instance.currentUser!
            .updateDisplayName(_signUpController.signupName.value);
        FirebaseFirestore.instance
            .collection('user')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('info')
            .doc().set({
          'gender' : _signUpController.genderIndex.value
        });
        Get.off(() => Home());
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Obx(
            () => Column(
              children: [
                nameField(context),
                signupEmailField(context),
                signupPasswordField(context),
                passwordCheckField(context),
                genderSwitch(),
                SizedBox(
                  height: Get.mediaQuery.size.height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    cancleButton(),
                    signUpButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
