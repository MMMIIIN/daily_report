import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController{
  var signupNameController = TextEditingController().obs;
  var signupEmailController = TextEditingController().obs;
  var signupPasswordController = TextEditingController().obs;
  var passwordCheckController = TextEditingController().obs;

  RxString signupName = ''.obs;
  RxString signupEmail = ''.obs;
  RxString signupPassword = ''.obs;
  RxString signupPasswordCheck = ''.obs;

  RxInt genderIndex = 0.obs;

  RxBool checkEmail = true.obs;
  RxBool checkPassword = true.obs;
  RxBool equalPassword = true.obs;

  void setSignupName(String name){
    signupName(name);
  }

  void setSignupEmail(String email) {
    signupEmail(email);
  }

  void setSignupPassword(String password){
    signupPassword(password);
  }

  void setSignupPasswordCheck(String checkPassword){
    signupPasswordCheck(checkPassword);
  }

  void checkEqualPassword() {
    if(signupPassword.value == signupPasswordCheck.value){
      equalPassword(true);
    } else {
      equalPassword(false);
    }
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

  void setGenderIndex(int index){
    genderIndex(index);
  }
}