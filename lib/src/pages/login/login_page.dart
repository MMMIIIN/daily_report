import 'package:daily_report/color.dart';
import 'package:daily_report/src/pages/home.dart';
import 'package:daily_report/src/pages/login/login_controller.dart';
import 'package:daily_report/src/pages/signup/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  final LoginController _loginController = Get.put(LoginController());

  Widget emailField() {
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
            Icon(Icons.email_outlined),
            Container(
              padding: EdgeInsets.only(left: 5),
              width: Get.mediaQuery.size.width * 0.8,
              child: TextField(
                onChanged: (text) {
                  _loginController.setLoginEmail(text);
                  _loginController.setCheckEmail();
                },
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
                  suffixIcon: _loginController.loginEmail.value == ''
                      ? null
                      : IconButton(
                          icon: Icon(Icons.cancel_outlined),
                          onPressed: () {
                            _loginController.emailController.value.clear();
                            _loginController.loginEmail('');
                          },
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

  Widget passwordField() {
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
            Icon(Icons.vpn_key_outlined),
            Container(
              padding: EdgeInsets.only(left: 5),
              width: Get.mediaQuery.size.width * 0.8,
              child: TextField(
                onChanged: (text) {
                  _loginController.setLoginPassword(text);
                  _loginController.setCheckPassword();
                },
                obscureText: true,
                cursorColor: primaryColor,
                controller: _loginController.passwordController.value,
                decoration: InputDecoration(
                  errorText: _loginController.checkPassword.value
                      ? null
                      : '패스워드가 너무 짧습니다.',
                  hintText: 'password',
                  hintStyle: TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                  ),
                  focusColor: primaryColor,
                  suffixIcon: _loginController.loginPassword.value == ''
                      ? null
                      : IconButton(
                          icon: Icon(Icons.cancel_outlined),
                          onPressed: () {
                            _loginController.passwordController.value.clear();
                            _loginController.loginPassword('');
                          },
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

  void logIn(String userId, String userPw) async {
    try {
      await await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: userId,
        password: userPw,
      )
          .then((value) => Get.off(() => Home())).catchError((error) async => await
      Get.showSnackbar(GetBar(
        title: 'ERROR',
        message: error.toString(),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ))
      );
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
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
                emailField(),
                passwordField(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(SignUpPage());
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                    MaterialButton(
                      elevation: 0,
                      color: primaryColor,
                      onPressed: () {
                        logIn(_loginController.emailController.value.text,
                            _loginController.passwordController.value.text);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
