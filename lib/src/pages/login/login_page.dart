import 'package:daily_report/color.dart';
import 'package:daily_report/icons.dart';
import 'package:daily_report/src/service/firestore_service.dart';
import 'package:daily_report/src/pages/login/controller/login_controller.dart';
import 'package:daily_report/src/pages/signup/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final LoginController _loginController = Get.put(LoginController());

class LoginPage extends StatelessWidget {
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Container(
              height: context.mediaQuery.size.height * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customImage(),
                  Column(
                    children: [
                      emailField(context),
                      passwordField(context),
                      forgotPassword(context),
                    ],
                  ),
                  Column(
                    children: [loginButton(context),
                      SizedBox(height: 10),
                      signUpText()],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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
              width: context.mediaQuery.size.width * 0.8,
              child: TextField(
                focusNode: emailFocus,
                onChanged: (text) {
                  _loginController.setLoginEmail(text);
                  _loginController.setCheckEmail();
                },
                textInputAction: TextInputAction.next,
                // autofocus: true,
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
              width: context.mediaQuery.size.width * 0.8,
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

  Widget forgotPassword(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(),
        GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      title: Text(
                        '찾으시는 이메일을 입력해주세요.',
                        style: TextStyle(fontSize: 18),
                      ),
                      content: Container(
                        height: context.mediaQuery.size.height * 0.2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: primaryColor.withOpacity(0.3)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.0),
                                    child:
                                        Icon(IconsDB.mail_outlined, size: 20),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    width: context.mediaQuery.size.width * 0.55,
                                    child: TextField(
                                      controller: _loginController
                                          .forgotEmailController.value,
                                      onChanged: (text) {
                                        _loginController.setForgotEmail(text);
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'example@email.com',
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '해당 이메일로 비밀번호 재설정 메일이 발송됩니다.',
                              // textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: primaryColor.withOpacity(0.5),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MaterialButton(
                                  onPressed: () {
                                    Get.back();
                                    _loginController.forgotEmailController.value
                                        .clear();
                                    _loginController.forgotPasswordEmail('');
                                  },
                                  elevation: 0,
                                  color: primaryColor.withOpacity(0.5),
                                  child: Text(
                                    '취 소',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    firebaseForgotUserPassword(_loginController
                                        .forgotPasswordEmail.value);
                                  },
                                  elevation: 0,
                                  color: primaryColor,
                                  child: Text(
                                    '확 인',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ));
          },
          child: Text(
            '비밀번호 찾기',
            style: TextStyle(fontSize: 16, color: primaryColor),
          ),
        ),
      ],
    );
  }

  Widget loginButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        firebaseLogIn(_loginController.loginEmail.value,
            _loginController.loginPassword.value);
      },
      child: Container(
        height: context.mediaQuery.size.height * 0.07,
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

  Widget signUpText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '아직 계정이 없다면?  ',
          style: TextStyle(color: primaryColor.withOpacity(0.5), fontSize: 16),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => SignUpPage());
          },
          child: Text(
            '빠른 회원가입',
            style: TextStyle(color: primaryColor, fontSize: 16),
          ),
        )
      ],
    );
  }
}
