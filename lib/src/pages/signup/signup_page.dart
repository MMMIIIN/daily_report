import 'package:daily_report/color.dart';
import 'package:daily_report/src/pages/signup/signup_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPage extends StatelessWidget {
  final SignUpController _signUpController = Get.put(SignUpController());

  Widget signupEmailField() {
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
                  _signUpController.setSignupEmail(text);
                  _signUpController.setCheckEmail();
                },
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
                  suffixIcon: _signUpController.signupEmail.value == ''
                      ? null
                      : IconButton(
                          icon: Icon(Icons.cancel_outlined),
                          onPressed: () {
                            _signUpController.signupEmailController.value
                                .clear();
                            _signUpController.signupEmail('');
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

  Widget signupPasswordField() {
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
                  _signUpController.setSignupPassword(text);
                  _signUpController.setCheckPassword();
                },
                obscureText: false,
                cursorColor: primaryColor,
                controller: _signUpController.signupPasswordController.value,
                decoration: InputDecoration(
                  errorText: _signUpController.checkPassword.value
                      ? null
                      : '비밀번호가 너무 짧습니다.',
                  hintText: 'password',
                  hintStyle: TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                  ),
                  focusColor: primaryColor,
                  suffixIcon: _signUpController.signupPassword.value == ''
                      ? null
                      : IconButton(
                          icon: Icon(Icons.cancel_outlined),
                          onPressed: () {
                            _signUpController.signupPasswordController.value
                                .clear();
                            _signUpController.signupPassword('');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Obx(
              () => Column(
                children: [
                  signupEmailField(),
                  signupPasswordField(),
                  MaterialButton(
                    color: primaryColor,
                    onPressed: () {
                      signUp(
                          _signUpController.signupEmailController.value.text,
                          _signUpController
                              .signupPasswordController.value.text);
                    },
                    child: Text(
                      '회원가입',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }

  void signUp(String userEmail, String userPw) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPw,
      );
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
}
