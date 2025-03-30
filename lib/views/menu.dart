import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing_api/auth/login.dart';
import 'package:testing_api/models/category.dart';
import 'package:testing_api/models/menu_item.dart';
import 'package:testing_api/services/apis_services/auth_apis/auth_apis.dart';
import 'package:testing_api/services/apis_services/menu_apis/menu_apis.dart';

class Menu extends StatelessWidget {
  Menu({super.key});
  final MenuItem menuItem = MenuItem(
    title: "Meat Balls",
    price: '100',
    featured: true,
    categoryId: 0,
    category: Category(
      slug: "1232",
      title: "Meat",
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                bool result = await MenuApis.postMenuItem(menuItem: menuItem);
              },
              child: const Text("Add Meal Item"),
            ),
            TextButton(
              onPressed: () async {
                bool result = await AuthApis.logout();
                if (result) {
                  Get.off(
                    () => Login(),
                    transition: Transition.native,
                    duration: const Duration(milliseconds: 500),
                  );
                }
              },
              child: const Text("Sign out"),
            ),
          ],
        ),
      ),
    );
  }
}
