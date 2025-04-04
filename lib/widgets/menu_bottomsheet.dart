import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing_api/controllers/chosen_category_controller.dart';
import 'package:testing_api/controllers/featured_controller.dart';
import 'package:testing_api/controllers/menu_item_controller.dart';
import 'package:testing_api/models/menu_item.dart';
import 'package:testing_api/services/apis_services/menu_apis/menu_apis.dart';
import 'package:testing_api/text_styles.dart';
import 'package:testing_api/views/menu.dart';
import 'package:testing_api/widgets/auth_input.dart';
import 'package:testing_api/widgets/my_button.dart';

class MenuBottomsheet extends StatelessWidget {
  MenuBottomsheet({
    super.key,
    this.menuItem,
  });

  final ChosenCategoryController categoryController =
      Get.find<ChosenCategoryController>();
  final MenuItemController menuController = Get.find<MenuItemController>();
  final MenuItem? menuItem;

  @override
  Widget build(BuildContext context) {
    print("Menu Item id from MenuBottomSheet update : ${menuItem?.id}");
    final TextEditingController titleController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final FeaturedController featuredController =
        Get.find<FeaturedController>();
    final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
    titleController.text = menuItem?.title ?? '';
    priceController.text = menuItem?.price ?? '';
    featuredController.isFeatured.value = menuItem?.featured ?? false;
    if (menuItem != null && menuItem!.category != null) {
      categoryController.changeCategory(
        category: menuItem!.category!.title,
      );
    }
    return Form(
      key: globalKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              menuItem == null ? "New Menu Item Info" : "Update Menu Item Info",
              style: btitleTextStyle1,
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
                items: categoryController.categoriesName
                    .map((String categoryName) {
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
                  bool result = menuItem == null
                      ? await MenuApis.postMenuItem(
                          menuItem: MenuItem(
                            categoryId: categoryController
                                .idOfCategory[categoryController.chosen.value]!,
                            title: titleController.text.trim(),
                            price: priceController.text.trim(),
                            featured: featuredController.isFeatured.value,
                          ),
                        )
                      : await MenuApis.updateMenuItem(
                          menuItem: MenuItem(
                            id: menuItem!.id,
                            categoryId: categoryController
                                .idOfCategory[categoryController.chosen.value]!,
                            title: titleController.text.trim(),
                            price: priceController.text.trim(),
                            featured: featuredController.isFeatured.value,
                          ),
                        );
                  // Get.back();

                  if (result) {
                    print("result $result");
                    menuController.changeNeedUpdate(true);
                    print("changed update to true");
                    categoryController.clear();
                    print("Navigating ...");
                    Get.offNamed(
                      '/menu',
                      preventDuplicates: false,
                    );
                  } else {
                    Get.snackbar(
                      'Error',
                      menuItem == null
                          ? 'Failed to add new menu item , try later.'
                          : 'Failed to update menu item , try later.',
                      snackPosition: SnackPosition.TOP,
                    );
                  }
                }
              },
              title: menuItem == null ? 'Add Menu Item' : 'Update Menu Item',
              color: Colors.amberAccent,
            )
          ],
        ),
      ),
    );
  }
}
