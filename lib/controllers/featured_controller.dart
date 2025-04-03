import 'package:get/state_manager.dart';

class FeaturedController extends GetxController {
  RxBool isFeatured = false.obs;
  void changeFeatured() {
    isFeatured.value = !isFeatured.value;
  }
}
