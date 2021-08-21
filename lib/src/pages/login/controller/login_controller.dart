import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var emailController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;
  var forgotEmailController = TextEditingController().obs;
  RxString loginEmail = ''.obs;
  RxString loginPassword = ''.obs;
  RxString forgotPasswordEmail = ''.obs;
  RxBool checkEmail = true.obs;
  RxBool checkPassword = true.obs;

  void setLoginEmail(String email) {
    loginEmail(email);
  }

  void setLoginPassword(String password) {
    loginPassword(password);
  }

  void setForgotEmail(String email){
    forgotPasswordEmail(email);
  }

  void setCheckEmail() {
    if (loginEmail.value.isEmpty || loginEmail.value.contains('@')) {
      checkEmail(true);
    } else {
      checkEmail(false);
    }
  }

  void setCheckPassword() {
    if(loginPassword.value.isEmpty || loginPassword.value.length > 5){
      checkPassword(true);
    } else {
      checkPassword(false);
    }
  }

  void clearTextField() {
    emailController.value.clear();
    passwordController.value.clear();
    loginEmail('');
    loginPassword('');
  }
}
