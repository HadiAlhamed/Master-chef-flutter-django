import 'package:get/state_manager.dart';
import 'package:testing_api/models/category.dart';

class ChosenCategoryController extends GetxController {
  RxString chosen = "".obs;
  List<String> categoriesName = [];
  Map<String, int> idOfCategory = <String, int>{};
  List<Category> categories = [];
  List<bool> deleted = List.generate(1050, (item) => false);
  bool needUpdate = true;
  //needs update if a successful add new category happend
  //or update a category
  //same with menu item
  void changeCategory({required String category}) {
    chosen.value = category;
  }

  void addCategoryName({required String name}) {
    categoriesName.add(name);
  }

  void setCategoryId({required String name, required int id}) {
    idOfCategory[name] = id;
  }

  void changeNeedUpdate(bool value) {
    needUpdate = value;
  }

  void clear() {
    categoriesName.clear();
    idOfCategory.clear();
    categories.clear();
    deleted = List.generate(1050, (item) => false);
    needUpdate = true;
  }
}
