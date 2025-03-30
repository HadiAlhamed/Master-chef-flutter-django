import 'package:get/get.dart';

class Passwordcontroller extends GetxController {
  RxBool showPassword = false.obs;
  void changeVisibility() {
    showPassword.value = !showPassword.value;
  }
}
