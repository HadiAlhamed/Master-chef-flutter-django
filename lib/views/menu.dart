import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing_api/Enums/user_role.dart';
import 'package:testing_api/controllers/chosen_category_controller.dart';
import 'package:testing_api/controllers/menu_item_controller.dart';
import 'package:testing_api/models/category_page.dart';
import 'package:testing_api/models/menu_items_page.dart';
import 'package:testing_api/services/api.dart';
import 'package:testing_api/services/apis_services/category_apis/category_apis.dart';
import 'package:testing_api/services/apis_services/menu_apis/menu_apis.dart';
import 'package:testing_api/widgets/customer_drawer.dart';
import 'package:testing_api/widgets/main_appbar.dart';
import 'package:testing_api/widgets/manager_drawer.dart';
import 'package:testing_api/widgets/menu_bottomsheet.dart';
import 'package:testing_api/widgets/menu_item_tile.dart';
import 'package:animation_list/animation_list.dart';
class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  UserRole userRole = UserRole.Customer;
  final ChosenCategoryController categoryController =
      Get.find<ChosenCategoryController>();
  final MenuItemController menuController = Get.find<MenuItemController>();
  bool isLoading = true;
  @override
  void initState() {
    print("Menu Page Loaded");

    super.initState();
    if (Api.box.read("role").toString().toLowerCase() == 'manager') {
      userRole = UserRole.Manager;
    } else if (Api.box.read("role").toString().toLowerCase() == 'delivery') {
      userRole = UserRole.Delivery;
    }
    if (menuController.needUpdate) {
      menuController.clear();
      categoryController.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
    }
  }

  Future<void> _fetchData() async {
    //fetching menu items

    MenuItemsPage menuItemsPage = await MenuApis.getMenuItems();
    for (var item in menuItemsPage.menuItems) {
      menuController.addMenuItem(menuItem: item);
    }
    while (menuItemsPage.nextPageUrl != null) {
      menuItemsPage =
          await MenuApis.getMenuItems(url: menuItemsPage.nextPageUrl);
      for (var item in menuItemsPage.menuItems) {
        menuController.addMenuItem(menuItem: item);
      }
    }

    //fetching categories
    CategoryPage categoryPage = await CategoryApis.getAllCategories();
    if (categoryPage.categories.isNotEmpty) {
      categoryController.changeCategory(
          category: categoryPage.categories[0].title);
    }
    for (var item in categoryPage.categories) {
      categoryController.categoriesName.add(item.title);
      categoryController.setCategoryId(name: item.title, id: item.id);
    }
    while (categoryPage.nextPageUrl != null) {
      categoryPage =
          await CategoryApis.getAllCategories(url: categoryPage.nextPageUrl);
      for (var item in categoryPage.categories) {
        categoryController.categoriesName.add(item.title);
        categoryController.setCategoryId(name: item.title, id: item.id);
      }
    }

    menuController.changeNeedUpdate(false);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GetBuilder<MenuItemController>(
              builder: (controller) => Container(
                margin: const EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: menuController.menuItems.length,
                  itemBuilder: (context, index) {
                    return MenuItemTile(
                      enable: !menuController.deleted[index],
                      menuItem: menuController.menuItems[index],
                      index: index,
                      userRole: userRole,
                    );
                  },
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Get.bottomSheet(
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: MenuBottomsheet(),
            ),
            isDismissible: true,
            enableDrag: true,
            backgroundColor: Colors.transparent,
          );
        },
        label: const Text("Add Menu Item"),
        icon: const Icon(Icons.add),
      ),
      drawer: userRole == UserRole.Manager
          ? ManagerDrawer()
          : userRole == UserRole.Customer
              ? CustomerDrawer()
              : null,
      drawerEnableOpenDragGesture: true,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    categoryController.clear();
    menuController.clear();
  }
}
