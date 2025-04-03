import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:testing_api/Enums/user_role.dart';
import 'package:testing_api/controllers/chosen_category_controller.dart';
import 'package:testing_api/controllers/featured_controller.dart';
import 'package:testing_api/models/category.dart';
import 'package:testing_api/models/category_page.dart';
import 'package:testing_api/models/menu_item.dart';
import 'package:testing_api/models/menu_items_page.dart';
import 'package:testing_api/services/api.dart';
import 'package:testing_api/services/apis_services/category_apis/category_apis.dart';
import 'package:testing_api/services/apis_services/menu_apis/menu_apis.dart';
import 'package:testing_api/text_styles.dart';
import 'package:testing_api/widgets/auth_input.dart';
import 'package:testing_api/widgets/customer_drawer.dart';
import 'package:testing_api/widgets/main_appbar.dart';
import 'package:testing_api/widgets/manager_drawer.dart';
import 'package:testing_api/widgets/menu_item_tile.dart';
import 'package:testing_api/widgets/my_button.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<MenuItem> menuItems = [];
  List<String> categoriesName = [];
  Map<String, int> idOfCategory = <String, int>{};
  UserRole userRole = UserRole.Customer;
  final ChosenCategoryController categoryController =
      Get.find<ChosenCategoryController>();
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    if (Api.box.read("role") == 'manager') {
      userRole = UserRole.Manager;
    } else if (Api.box.read("role") == 'delivery') {
      userRole = UserRole.Delivery;
    }
    _fetchData();
  }

  Future<void> _fetchData() async {
    MenuItemsPage menuItemsPage = await MenuApis.getMenuItems();
    for (var item in menuItemsPage.menuItems) {
      menuItems.add(item);
    }
    while (menuItemsPage.nextPageUrl != null) {
      menuItemsPage =
          await MenuApis.getMenuItems(url: menuItemsPage.nextPageUrl);
      for (var item in menuItemsPage.menuItems) {
        menuItems.add(item);
      }
    }
    CategoryPage categoryPage = await CategoryApis.getAllCategories();
    if (categoryPage.categories.isNotEmpty) {
      categoryController.changeCategory(
          category: categoryPage.categories[0].title);
    }
    for (var item in categoryPage.categories) {
      categoriesName.add(item.title);
      idOfCategory[item.title] = item.id;
    }
    while (categoryPage.nextPageUrl != null) {
      categoryPage =
          await CategoryApis.getAllCategories(url: categoryPage.nextPageUrl);
      for (var item in categoryPage.categories) {
        categoriesName.add(item.title);
        idOfCategory[item.title] = item.id;
      }
    }
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
          : Container(
              margin: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  return MenuItemTile(
                    enable: true,
                    menuItem: menuItems[index],
                    index: index,
                    userRole: userRole,
                  );
                },
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
              child: _newMenuItemBottomSheet(),
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

  Form _newMenuItemBottomSheet() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final FeaturedController featuredController =
        Get.find<FeaturedController>();
    final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

    return Form(
      key: globalKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "New Menu Item Info",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            AuthInput(
              title: 'Title',
              controller: titleController,
            ),
            const SizedBox(height: 16),
            AuthInput(
              title: 'Price',
              controller: priceController,
            ),
            const SizedBox(
              height: 16,
            ),
            Obx(() {
              return RadioListTile<bool>(
                title: const Text(
                  "Featured",
                  style: btitleTextStyle2,
                ),
                value: true,
                groupValue: featuredController.isFeatured.value,
                onChanged: (bool? value) {
                  featuredController.changeFeatured();
                },
              );
            }),
            Obx(
              () {
                return RadioListTile<bool>(
                  title: const Text(
                    "Not Featured",
                    style: btitleTextStyle2,
                  ),
                  value: false,
                  groupValue: featuredController.isFeatured.value,
                  onChanged: (bool? value) {
                    featuredController.changeFeatured();
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            Obx(() {
              return DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  // 🔹 (2) Styles the input field
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ), // Adds a visible border around the dropdown
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12), // Adds padding inside the field
                ),
                isExpanded: true,
                validator: (value) => value == null || value == ""
                    ? "Please select a category"
                    : null,
                hint: const Text("Choose a category"),
                value: categoryController.chosen.value,
                items: categoriesName.map((String categoryName) {
                  return DropdownMenuItem<String>(
                    value: categoryName,
                    child: Text(categoryName),
                  );
                }).toList(),
                onChanged: (newValue) {
                  categoryController.changeCategory(category: newValue ?? "");
                },
              );
            }),
            const SizedBox(height: 16),
            MyButton(
              onPressed: () async {
                if (globalKey.currentState!.validate()) {
                  bool result = await MenuApis.postMenuItem(
                    menuItem: MenuItem(
                      categoryId:
                          idOfCategory[categoryController.chosen.value]!,
                      title: titleController.text.trim(),
                      price: priceController.text.trim(),
                      featured: featuredController.isFeatured.value,
                    ),
                  );
                  if (result) {
                    Get.off(
                      () => Menu(),
                      transition: Transition.fade,
                      duration: const Duration(milliseconds: 300),
                    );
                  } else {
                    Get.snackbar(
                      'Error',
                      'Failed to add new menu item , try later.',
                      snackPosition: SnackPosition.TOP,
                    );
                  }
                }
              },
              title: 'Add Menu Item',
              color: Colors.amberAccent,
            )
          ],
        ),
      ),
    );
  }
}
