import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var emailController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;
  RxString loginEmail = ''.obs;
  RxString loginPassword = ''.obs;
  RxBool checkEmail = true.obs;
  RxBool checkPassword = true.obs;

  void setLoginEmail(String email) {
    loginEmail(email);
  }

  void setLoginPassword(String password) {
    loginPassword(password);
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.value.dispose();
    passwordController.value.dispose();
  }
}
