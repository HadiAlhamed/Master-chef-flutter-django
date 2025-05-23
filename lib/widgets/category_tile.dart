// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:testing_api/controllers/chosen_category_controller.dart';
import 'package:testing_api/models/category.dart';
import 'package:testing_api/services/apis_services/category_apis/category_apis.dart';
import 'package:testing_api/widgets/category_bottomsheet.dart';

class CategoryTile extends StatelessWidget {
  final Category category;
  final int index;
  final bool enable;
  final ChosenCategoryController categoryController =
      Get.find<ChosenCategoryController>();
  CategoryTile({
    super.key,
    required this.category,
    required this.index,
    required this.enable,
  });

  @override
  Widget build(BuildContext context) {
    print("Category tile index : $index");
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      // color: const Color.fromARGB(255, 210, 186, 186),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: !enable //update category item
              ? null
              : () async {
                  Get.bottomSheet(
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: CategoryBottomsheet(
                        category: category,
                        index: index,
                      ),
                    ),
                  );
                },
          enabled: enable,
          contentPadding: const EdgeInsets.all(10),
          title: Text(
            enable
                ? "${index + 1} ${category.title}"
                : "${index + 1} ${category.title} (DELETED)",
            style: TextStyle(
              fontFamily: "Lobster",
              color: Colors.amber,
              fontSize: 20,
            ),
          ),
          subtitle: Text(
            category.slug,
            style: TextStyle(
              fontFamily: "Lobster",
            ),
          ),
          trailing: IconButton(
            onPressed: !enable
                ? null
                : () async {
                    //delete Delivery guy from here
                    //apply deleteDeliveryCrewApi here
                    AwesomeDialog(
                      context: context,
                      alignment: Alignment.center,
                      animType: AnimType.leftSlide,
                      dialogType: DialogType.warning,
                      body: const Text(
                        "The category will be deleted from categories",
                        textAlign: TextAlign.center,
                      ),
                      btnCancelText: "Delete",
                      btnOkText: "Cancel",
                      btnOkOnPress: () {},
                      btnCancelOnPress: () async {
                        bool result = await CategoryApis.deleteCategory(
                            categoryId: category.id!);
                        //implement delete category here

                        Get.showSnackbar(
                          GetSnackBar(
                            duration: const Duration(seconds: 5),
                            title: result ? "Info" : "Error",
                            message: result
                                ? "User Added To Delivery Crew"
                                : "An Error Has Occurred, try later.",
                            icon: Icon(result ? Icons.check : Icons.error),
                            backgroundColor: result ? Colors.green : Colors.red,
                          ),
                        );
                        if (result) {
                          categoryController.deleted[index].value = true;
                          categoryController.changeNeedUpdate(true);
                        }
                      },
                    ).show();
                  },
            icon: enable
                ? Icon(
                    Icons.remove_circle_outline,
                    color: Colors.red,
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
