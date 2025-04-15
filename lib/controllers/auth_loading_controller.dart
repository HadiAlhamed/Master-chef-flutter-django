import 'package:get/get.dart';

class AuthLoadingController extends GetxController {
  bool isLoading = false;
  void changeIsLoading(bool value) {
    isLoading = value;
    update();
  }
}
