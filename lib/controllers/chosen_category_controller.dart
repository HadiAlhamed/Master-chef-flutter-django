import 'package:get/state_manager.dart';

class ChosenCategoryController extends GetxController {
  RxString chosen = "".obs;
  void changeCategory({required String category}) {
    chosen.value = category;
  }
}
