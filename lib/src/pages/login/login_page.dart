import 'package:daily_report/color.dart';
import 'package:daily_report/icons.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/error/error_handling.dart';
import 'package:daily_report/src/pages/home.dart';
import 'package:daily_report/src/pages/login/controller/login_controller.dart';
import 'package:daily_report/src/pages/signup/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  final LoginController _loginController = Get.put(LoginController());
  final TodoController _todoController = Get.put(TodoController());

  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  Widget customImage() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.8), shape: BoxShape.circle),
      child: Center(
        child: Text(
          'Daily Report',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
    );
  }

  Widget emailField(BuildContext context) {
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
            Icon(IconsDB.mail_outlined),
            Container(
              padding: EdgeInsets.only(left: 5),
              width: Get.mediaQuery.size.width * 0.8,
              child: TextField(
                focusNode: emailFocus,
                onChanged: (text) {
                  _loginController.setLoginEmail(text);
                  _loginController.setCheckEmail();
                },
                textInputAction: TextInputAction.next,
                autofocus: true,
                onSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(passwordFocus),
                obscureText: false,
                cursorColor: primaryColor,
                controller: _loginController.emailController.value,
                decoration: InputDecoration(
                  errorText: _loginController.checkEmail.value
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

  Widget passwordField(BuildContext context) {
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
            Icon(IconsDB.locked_outlined),
            Container(
              padding: EdgeInsets.only(left: 5),
              width: Get.mediaQuery.size.width * 0.8,
              child: TextField(
                focusNode: passwordFocus,
                onChanged: (text) {
                  _loginController.setLoginPassword(text);
                  _loginController.setCheckPassword();
                },
                onSubmitted: (_) => FocusScope.of(context).unfocus(),
                obscureText: true,
                cursorColor: primaryColor,
                controller: _loginController.passwordController.value,
                decoration: InputDecoration(
                  errorText: _loginController.checkPassword.value
                      ? null
                      : '패스워드가 너무 짧습니다.',
                  hintText: '비밀번호',
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

  Widget forgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(),
        Text(
          '비밀번호 찾기',
          style: TextStyle(fontSize: 16, color: primaryColor),
        ),
      ],
    );
  }

  Widget loginButton() {
    return GestureDetector(
      onTap: () {
        logIn(_loginController.loginEmail.value,
            _loginController.loginPassword.value);
      },
      child: Container(
        width: double.infinity,
        height: Get.mediaQuery.size.height * 0.07,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            '로그인',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }

  void logIn(String userId, String userPw) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: userId,
        password: userPw,
      )
          .then((value) {
        Get.off(() => Home());
        _todoController.initUidTodoList();
      });
    } on FirebaseAuthException catch (e) {
      await Get.showSnackbar(GetBar(
        title: 'ERROR',
        message: setErrorMessage(e.code),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ));
    }
  }

  Widget signUpText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '아직 계정이 없다면?  ',
          style: TextStyle(
              color: primaryColor.withOpacity(0.5), fontSize: 16),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => SignUpPage());
          },
          child: Text(
            '회원가입',
            style: TextStyle(color: primaryColor, fontSize: 16),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customImage(),
                SizedBox(
                  height: Get.mediaQuery.size.height * 0.1,
                ),
                emailField(context),
                passwordField(context),
                forgotPassword(),
                SizedBox(
                  height: Get.mediaQuery.size.height * 0.1,
                ),
                loginButton(),
                SizedBox(
                  height: Get.mediaQuery.size.height * 0.02,
                ),
                signUpText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
