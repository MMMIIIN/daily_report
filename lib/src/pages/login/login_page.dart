import 'package:daily_report/color.dart';
import 'package:daily_report/src/pages/home.dart';
import 'package:daily_report/src/pages/signup/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Widget inputField(Icon _icon, TextEditingController _textController, String hintText){
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
            _icon,
            Container(
              padding: EdgeInsets.only(left: 5),
              width: Get.mediaQuery.size.width * 0.8,
              child: TextField(
                cursorColor: primaryColor,
                controller: _textController,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                  ),
                  focusColor: primaryColor,
                  suffixIcon: _textController.text == '' ? null : Icon(Icons.cancel_outlined),
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
        child: Column(
          children: [
            inputField(Icon(Icons.email_outlined), _emailController, 'email'),
            inputField(Icon(Icons.vpn_key_outlined), _passwordController, 'password'),
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
                  color: primaryColor,
                  onPressed: () {
                    logIn(_emailController.text, _passwordController.text);
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
    ));
  }

  void logIn(String userId, String userPw) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userId,
        password: userPw,
      );
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    if (FirebaseAuth.instance.currentUser != null) {
      await Get.to(() => Home());
    }
  }
}
