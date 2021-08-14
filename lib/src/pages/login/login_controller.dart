import 'package:get/get.dart';

class LoginController extends GetxController {
  RxString loginEmail = ''.obs;
  RxString loginPassword = ''.obs;
  RxBool checkEmail = false.obs;
  RxBool checkPassword = false.obs;

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
    if(loginPassword.value.isEmpty || loginPassword.value.length < 5){
      checkPassword(true);
    } else {
      checkPassword(false);
    }
  }
}
