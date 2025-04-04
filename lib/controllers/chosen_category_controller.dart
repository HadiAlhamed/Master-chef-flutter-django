import 'package:get/state_manager.dart';

class ChosenCategoryController extends GetxController {
  RxString chosen = "".obs;
  List<String> categoriesName = [];
  Map<String, int> idOfCategory = <String, int>{};
  void changeCategory({required String category}) {
    chosen.value = category;
  }

  void addCategoryName({required String name}) {
    categoriesName.add(name);
  }

  void setCategoryId({required String name, required int id}) {
    idOfCategory[name] = id;
  }

  void clear() {
    categoriesName.clear();
    idOfCategory.clear();
  }
}
