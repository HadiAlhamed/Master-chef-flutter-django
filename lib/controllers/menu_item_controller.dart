import 'package:get/get.dart';
import 'package:testing_api/models/menu_item.dart';

class MenuItemController extends GetxController {
  List<MenuItem> menuItems = [];
  Map<int, String> menuItemTitleById = <int, String>{};
  List<bool> deleted = List.generate(
    1050,
    (item) => false,
  );
  bool needUpdate = true;

  void addMenuItem({required MenuItem menuItem}) {
    menuItems.add(menuItem);
    menuItemTitleById[menuItem.id!] = menuItem.title;
  }

  void deleteMenuItem(int index) {
    deleted[index] = true;
    update();
  }

  void changeNeedUpdate(bool value) {
    needUpdate = value;
    // update();
  }

  void clear() {
    needUpdate = true;
    menuItems.clear();
    menuItemTitleById.clear();
    deleted = List.generate(
      1050,
      (item) => false,
    );
  }
}
