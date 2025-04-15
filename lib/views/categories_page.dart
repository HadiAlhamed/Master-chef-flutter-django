import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:testing_api/Enums/user_role.dart';
import 'package:testing_api/controllers/chosen_category_controller.dart';
import 'package:testing_api/models/category_page.dart';
import 'package:testing_api/services/api.dart';
import 'package:testing_api/services/apis_services/category_apis/category_apis.dart';
import 'package:testing_api/widgets/category_bottomsheet.dart';
import 'package:testing_api/widgets/category_tile.dart';
import 'package:testing_api/widgets/customer_drawer.dart';
import 'package:testing_api/widgets/main_appbar.dart';
import 'package:testing_api/widgets/manager_drawer.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  UserRole userRole = UserRole.Customer;
  final ChosenCategoryController categoryController =
      Get.find<ChosenCategoryController>();
  @override
  void initState() {
    print("Categories Page Loaded");
    print("categories needs to change : ${categoryController.needUpdate}");
    super.initState();
    if (Api.box.read("role").toString().toLowerCase() == 'manager') {
      userRole = UserRole.Manager;
    } else if (Api.box.read("role").toString().toLowerCase() == 'delivery') {
      userRole = UserRole.Delivery;
    }
    categoryController.changeIsLoading(true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  Future<void> _fetchData() async {
    //fetching categories
    print("fetching categories _fetch data ...");
    if (categoryController.needUpdate) {
      print("updating categories list ... ");
      categoryController.clear();
      CategoryPage categoryPage = await CategoryApis.getAllCategories();
      if (categoryPage.categories.isNotEmpty) {
        categoryController.changeCategory(
            category: categoryPage.categories[0].title);
      }
      for (var item in categoryPage.categories) {
        categoryController.addCategory(category: item);
        categoryController.setCategoryId(name: item.title, id: item.id!);
      }
      while (categoryPage.nextPageUrl != null) {
        categoryPage =
            await CategoryApis.getAllCategories(url: categoryPage.nextPageUrl);
        for (var item in categoryPage.categories) {
          categoryController.addCategory(category: item);
          categoryController.setCategoryId(name: item.title, id: item.id!);
        }
      }
      categoryController.changeNeedUpdate(false);
    }
    categoryController.changeIsLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        myTitle: "Categories",
      ),
      body: Obx(
        () {
          if (categoryController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Container(
            margin: const EdgeInsets.all(10),
            child: RefreshIndicator(
              onRefresh: _fetchData,
              child: ListView.builder(
                itemCount: categoryController.categories.length,
                itemBuilder: (context, index) {
                  try {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 400),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Obx(
                            () => CategoryTile(
                              category: categoryController.categories[index],
                              enable: !categoryController.deleted[index].value,
                              index: index,
                            ),
                          ),
                        ),
                      ),
                    );
                  } catch (e) {
                    print("Error in listing categories : $e");
                  }
                  return null;
                },
              ),
            ),
          );
        },
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
  }
}
