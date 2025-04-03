import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing_api/Enums/user_role.dart';
import 'package:testing_api/controllers/featured_controller.dart';
import 'package:testing_api/models/menu_item.dart';
import 'package:testing_api/models/menu_items_page.dart';
import 'package:testing_api/services/api.dart';
import 'package:testing_api/services/apis_services/menu_apis/menu_apis.dart';
import 'package:testing_api/text_styles.dart';
import 'package:testing_api/widgets/auth_input.dart';
import 'package:testing_api/widgets/customer_drawer.dart';
import 'package:testing_api/widgets/main_appbar.dart';
import 'package:testing_api/widgets/manager_drawer.dart';
import 'package:testing_api/widgets/menu_item_tile.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<MenuItem> menuItems = [];
  UserRole userRole = UserRole.Customer;
  bool isLoading = true;
  bool? isFeatured = true;
  @override
  void initState() {
    super.initState();
    if (Api.box.read("role") == 'manager') {
      userRole = UserRole.Manager;
    } else if (Api.box.read("role") == 'delivery') {
      userRole = UserRole.Delivery;
    }
    fetchMenuItems();
  }

  Future<void> fetchMenuItems() async {
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
              child: newMenuItemBottomSheet(),
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

  Form newMenuItemBottomSheet() {
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
            AuthInput(title: 'Title'),
            const SizedBox(height: 16),
            AuthInput(
              title: 'Price',
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
          ],
        ),
      ),
    );
  }
}
