import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:testing_api/Enums/user_role.dart';
import 'package:testing_api/controllers/chosen_category_controller.dart';
import 'package:testing_api/controllers/menu_item_controller.dart';
import 'package:testing_api/models/category_page.dart';
import 'package:testing_api/models/menu_items_page.dart';
import 'package:testing_api/services/api.dart';
import 'package:testing_api/services/apis_services/category_apis/category_apis.dart';
import 'package:testing_api/services/apis_services/menu_apis/menu_apis.dart';
import 'package:testing_api/widgets/category_bottomsheet.dart';
import 'package:testing_api/widgets/category_tile.dart';
import 'package:testing_api/widgets/customer_drawer.dart';
import 'package:testing_api/widgets/main_appbar.dart';
import 'package:testing_api/widgets/manager_drawer.dart';
import 'package:testing_api/widgets/menu_bottomsheet.dart';
import 'package:testing_api/widgets/menu_item_tile.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  UserRole userRole = UserRole.Customer;
  final ChosenCategoryController categoryController =
      Get.find<ChosenCategoryController>();
  bool isLoading = true;
  @override
  void initState() {
    print("Categories Page Loaded");
    super.initState();
    if (Api.box.read("role").toString().toLowerCase() == 'manager') {
      userRole = UserRole.Manager;
    } else if (Api.box.read("role").toString().toLowerCase() == 'delivery') {
      userRole = UserRole.Delivery;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  Future<void> _fetchData() async {
    //fetching categories
    print("fetching categories _fetch data ...");
    if (categoryController.needUpdate) {
      CategoryPage categoryPage = await CategoryApis.getAllCategories();
      if (categoryPage.categories.isNotEmpty) {
        categoryController.changeCategory(
            category: categoryPage.categories[0].title);
      }
      for (var item in categoryPage.categories) {
        categoryController.categories.add(item);
        categoryController.categoriesName.add(item.title);
        categoryController.setCategoryId(name: item.title, id: item.id!);
      }
      while (categoryPage.nextPageUrl != null) {
        categoryPage =
            await CategoryApis.getAllCategories(url: categoryPage.nextPageUrl);
        for (var item in categoryPage.categories) {
          categoryController.categories.add(item);
          categoryController.categoriesName.add(item.title);
          categoryController.setCategoryId(name: item.title, id: item.id!);
        }
      }
      categoryController.changeNeedUpdate(false);
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
          : GetBuilder<ChosenCategoryController>(
              builder: (controller) => Container(
                margin: const EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: categoryController.categories.length,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 400),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: CategoryTile(
                            category: categoryController.categories[index],
                            enable: !categoryController.deleted[index],
                            index: index,
                          ),
                        ),
                      ),
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
              child: CategoryBottomsheet(),
            ),
            isDismissible: true,
            enableDrag: true,
            backgroundColor: Colors.transparent,
          );
        },
        label: const Text("Add Category"),
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
  }
}
