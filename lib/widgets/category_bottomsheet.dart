import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing_api/controllers/chosen_category_controller.dart';
import 'package:testing_api/models/category.dart';
import 'package:testing_api/services/apis_services/category_apis/category_apis.dart';
import 'package:testing_api/text_styles.dart';
import 'package:testing_api/views/categories_page.dart';
import 'package:testing_api/widgets/auth_input.dart';
import 'package:testing_api/widgets/my_button.dart';

class CategoryBottomsheet extends StatelessWidget {
  CategoryBottomsheet({
    super.key,
    this.category,
    this.index,
  });

  final ChosenCategoryController categoryController =
      Get.find<ChosenCategoryController>();
  final Category? category;
  final int? index;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController slugController = TextEditingController();
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print("Category Item id from CategoryBottomSheet update : ${category?.id}");
    titleController.text = category?.title ?? '';
    slugController.text = category?.slug ?? '';
    return Form(
      key: globalKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category == null ? "New Category Info" : "Update Existing Info",
              style: btitleTextStyle1,
            ),
            const SizedBox(height: 16),
            AuthInput(
              title: 'Title',
              controller: titleController,
            ),
            const SizedBox(height: 16),
            AuthInput(
              title: 'Slug',
              controller: slugController,
            ),
            const SizedBox(
              height: 16,
            ),
            MyButton(
              onPressed: () async {
                if (globalKey.currentState!.validate()) {
                  bool result = category == null
                      ? await CategoryApis.addNewCategory(
                          category: Category(
                            title: titleController.text.trim(),
                            slug: slugController.text.trim(),
                          ),
                        )
                      : await CategoryApis.updateCategory(
                          category: Category(
                            id: category!.id!,
                            title: titleController.text.trim(),
                            slug: slugController.text.trim(),
                          ),
                        );

                  if (result) {
                    print("add/update result :  $result");
                    if (category == null) {
                      categoryController.clear();
                      print("changed update to true");
                      print("Navigating ...");

                      Get.off(
                        () => CategoriesPage(),
                        transition: Transition.fade,
                        duration: const Duration(milliseconds: 300),
                        preventDuplicates: false,
                      );
                    } else {
                      print("only update");
                      categoryController.changeCategoryAt(
                          index: index!,
                          category: Category(
                            title: titleController.text.trim(),
                            slug: slugController.text.trim(),
                          ));
                      Future.delayed(const Duration(milliseconds: 100));
                      Get.back();
                    }
                  } else {
                    Get.snackbar(
                      'Error',
                      category == null
                          ? 'Failed to add new category , try later.'
                          : 'Failed to update category , try later.',
                      snackPosition: SnackPosition.TOP,
                    );
                  }
                }
              },
              title: category == null
                  ? 'Add New Category'
                  : 'Update Existing Category',
              color: Colors.amberAccent,
            )
          ],
        ),
      ),
    );
  }
}
