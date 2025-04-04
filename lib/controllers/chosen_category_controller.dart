import 'package:get/state_manager.dart';
import 'package:testing_api/models/category.dart';

class ChosenCategoryController extends GetxController {
  RxString chosen = "".obs;
  List<String> categoriesName = [];
  Map<String, int> idOfCategory = <String, int>{};
  RxList<Category> categories = <Category>[].obs;
  List<RxBool> deleted = List.generate(1050, (item) => false.obs);
  bool needUpdate = true;
  RxBool isLoading = true.obs;
  //needs update if a successful add new category happend
  //or update a category
  //same with menu item
  void changeCategory({required String category}) {
    chosen.value = category;
  }

  void addCategory({required Category category}) {
    categoriesName.add(category.title);
    categories.add(category);
  }

  void deleteCategoryAt(int index) {
    deleted[index].value = true;
  }

  void changeCategoryAt({required int index, required Category category}) {
    print('new category title : ${category.title}');
    print("🔵 Before Update: ${categories[index].title}");

    categories[index] = category;
    categoriesName[index] = category.title;
    print("🟢 After Update: ${categories[index].title}");
    print("🔄 Triggering refresh...");

    categories.refresh(); // Force GetX to update UI

    print("✅ Updated RxList. Categories Length: ${categories.length}");
  }

  void setCategoryId({required String name, required int id}) {
    idOfCategory[name] = id;
  }

  void changeNeedUpdate(bool value) {
    needUpdate = value;
  }

  void changeIsLoading(bool value) {
    isLoading.value = value;
  }

  void clear() {
    categoriesName.clear();
    idOfCategory.clear();
    categories.clear();
    deleted = List.generate(1050, (item) => false.obs);
    needUpdate = true;
    isLoading.value = true;
  }
}
