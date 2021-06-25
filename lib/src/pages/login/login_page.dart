import 'package:daily_report/src/pages/home.dart';
import 'package:daily_report/src/pages/signup/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';


class LoginPage extends StatelessWidget {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextField(
                controller: _emailController,
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.to(SignUpPage());
                    },
                    child: Text('Sign Up',style: TextStyle(
                      color: Colors.redAccent
                    ),),
                  ),
                  ElevatedButton(onPressed: (){
                    logIn(_emailController.text, _passwordController.text);
                  }, child: Text('Login')),
                ],
              )
            ],
          ),
        ),
      )
    );
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
      Get.to(Home());
    }
  }
}
