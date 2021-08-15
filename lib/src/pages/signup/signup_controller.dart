import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController{
  var signupEmailController = TextEditingController().obs;
  var signupPasswordController = TextEditingController().obs;
  RxString signupEmail = ''.obs;
  RxString signupPassword = ''.obs;
  RxBool checkEmail = true.obs;
  RxBool checkPassword = true.obs;

  void setSignupEmail(String email) {
    signupEmail(email);
  }

  void setSignupPassword(String password){
    signupPassword(password);
  }

  void setCheckEmail() {
    if(signupEmail.value.isEmpty || signupEmail.value.contains('@')){
      checkEmail(true);
    }else {
      checkEmail(false);
    }
  }

  void setCheckPassword() {
    if(signupPassword.value.isEmpty || signupPassword.value.length > 5){
      checkPassword(true);
    } else{
      checkPassword(false);
    }
  }
}