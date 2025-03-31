import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing_api/auth/login.dart';
import 'package:testing_api/models/category.dart';
import 'package:testing_api/models/menu_item.dart';
import 'package:testing_api/models/menu_items_page.dart';
import 'package:testing_api/services/api.dart';
import 'package:testing_api/services/apis_services/auth_apis/auth_apis.dart';
import 'package:testing_api/services/apis_services/menu_apis/menu_apis.dart';
import 'package:testing_api/text_styles.dart';
import 'package:testing_api/widgets/drawer_tile.dart';
import 'package:testing_api/widgets/manager_drawer.dart';
import 'package:testing_api/widgets/menu_item_tile.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<MenuItem> menuItems = [];
  bool isManager = false;
  bool isDelivery = false;

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    isManager = Api.box.read("role") == 'manager';
    isDelivery = Api.box.read("role") == 'delivery';
    fetchMenuItems();
    for (var item in menuItems) {
      print(item.title);
    }
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
      appBar: AppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              margin: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  return MenuItemTile(
                    menuItem: menuItems[index],
                    index: index,
                  );
                },
              ),
            ),
      drawer: ManagerDrawer(),
      drawerEnableOpenDragGesture: true,
    );
  }
}
