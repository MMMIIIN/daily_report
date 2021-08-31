import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final TodoController _todoController = Get.put(TodoController());
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

  RxBool checkEmail = false.obs;
  RxBool checkPassword = false.obs;
  RxBool equalPassword = false.obs;
  RxBool allCheck = false.obs;

  void setSignupName(String name){
    signupName(name);
  }

  void setSignupEmail(String email) {
    signupEmail(email);
  }

  void setSignupPassword(String password){
    signupPassword(password);
    checkEqualPassword();
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
    setAllCheck();
  }

  void setCheckEmail() {
    if(signupEmail.value.isEmpty || signupEmail.value.contains('@')){
      checkEmail(true);
    }else {
      checkEmail(false);
    }
    setAllCheck();
  }

  void setCheckPassword() {
    if(signupPassword.value.isEmpty || signupPassword.value.length > 5){
      checkPassword(true);
    } else{
      checkPassword(false);
    }
    setAllCheck();
  }

  void setGenderIndex(int index) {
    genderIndex(index);
  }

  void setAllCheck() {
    if(checkEmail.value && checkPassword.value && equalPassword.value){
      allCheck(true);
    } else {
      allCheck(false);
    }
  }

  void intiDataSet() {
    _todoController.initData();
    _todoController.setCurrentIndex(DateTime.now());
  }
}