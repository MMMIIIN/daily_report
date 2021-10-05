import 'package:daily_report/icons.dart';
import 'package:daily_report/src/pages/chart/controller/chart_controller.dart';
import 'package:daily_report/src/pages/list/controller/list_controller.dart';
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
                  customImage(context),
                  Column(
                    children: [
                      emailField(context),
                      passwordField(context),
                      forgotPassword(context),
                    ],
                  ),
                  Column(
                    children: [
                      Obx(() => loginButton(context)),
                      SizedBox(height: 10),
                      signUpText(context)
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget customImage(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 60),
      child: Container(
        width: context.mediaQuery.size.height * 0.2,
        height: context.mediaQuery.size.height * 0.2,
        decoration: BoxDecoration(
          color: context.theme.primaryColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Container(
            alignment: Alignment.center,
            width: context.mediaQuery.size.height * 0.15,
            height: context.mediaQuery.size.height * 0.15,
            child: Text(
              'DAILY REPORT',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: (context.mediaQuery.size.height * 0.15) * 0.24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: '',
                  fontStyle: FontStyle.italic),
            ),
          ),
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
          color: context.theme.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Icon(IconsDB.mail_outlined),
            ),
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
                onSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(passwordFocus),
                obscureText: false,
                cursorColor: Colors.black,
                controller: _loginController.emailController.value,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 5),
                    hintText: 'example@email.com',
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.4),
                      fontSize: 16,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent))),
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
          color: context.theme.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Icon(IconsDB.locked_outlined),
            ),
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
                cursorColor: Colors.black,
                controller: _loginController.passwordController.value,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 5),
                    hintText: '비밀번호',
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.4),
                      fontSize: 16,
                    ),
                    focusColor: Colors.black,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent))),
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
                                  color: context.theme.primaryColor
                                      .withOpacity(0.2)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.0,top: 8),
                                    child:
                                        Icon(IconsDB.mail_outlined, size: 20),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    width: context.mediaQuery.size.width * 0.55,
                                    child: TextField(
                                      cursorColor: Colors.black,
                                      controller: _loginController
                                          .forgotEmailController.value,
                                      onChanged: (text) {
                                        _loginController.setForgotEmail(text);
                                      },
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(top: 5),
                                          hintText: 'example@email.com',
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '해당 이메일로 비밀번호 재설정 메일이 발송됩니다.',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  splashColor: context.theme.primaryColor
                                      .withOpacity(0.4),
                                  highlightColor: context.theme.primaryColor
                                      .withOpacity(0.2),
                                  onTap: () {
                                    Get.back();
                                    _loginController.forgotEmailController.value
                                        .clear();
                                    _loginController.forgotPasswordEmail('');
                                  },
                                  child: Container(
                                    width: context.mediaQuery.size.width * 0.18,
                                    height:
                                        context.mediaQuery.size.height * 0.043,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: context.theme.primaryColor)),
                                    child: Center(
                                      child: Text(
                                        '취소',
                                        style: TextStyle(
                                            color: context.theme.primaryColor,
                                            fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    firebaseForgotUserPassword(_loginController
                                        .forgotPasswordEmail.value);
                                  },
                                  child: Container(
                                    width: context.mediaQuery.size.width * 0.18,
                                    height:
                                        context.mediaQuery.size.height * 0.043,
                                    decoration: BoxDecoration(
                                        color: context.theme.primaryColor),
                                    child: Center(
                                      child: Text(
                                        '확인',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ),
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
            style: TextStyle(fontSize: 16, color: context.theme.primaryColor),
          ),
        ),
      ],
    );
  }

  Widget loginButton(BuildContext context) {
    return GestureDetector(
      onTap: _loginController.clickedButton.value
          ? null
          : () {
              _loginController.clickedButton(true);
              firebaseLogIn(_loginController.loginEmail.value,
                      _loginController.loginPassword.value)
                  .then((value) => _loginController.clickedButton(false));
            },
      child: Container(
        height: context.mediaQuery.size.height * 0.07,
        decoration: BoxDecoration(
          color: _loginController.clickedButton.value
              ? context.theme.primaryColor.withOpacity(0.6)
              : context.theme.primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: _loginController.clickedButton.value
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
                  '로그인',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
      ),
    );
  }

  Widget signUpText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '아직 계정이 없다면?  ',
          style: TextStyle(
              color: context.theme.primaryColor.withOpacity(0.5), fontSize: 16),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => SignUpPage());
          },
          child: Text(
            '빠른 회원가입',
            style: TextStyle(color: context.theme.primaryColor, fontSize: 16),
          ),
        )
      ],
    );
  }
}
