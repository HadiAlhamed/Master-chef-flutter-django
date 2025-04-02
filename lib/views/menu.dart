import 'package:flutter/material.dart';
import 'package:testing_api/Enums/user_role.dart';
import 'package:testing_api/models/menu_item.dart';
import 'package:testing_api/models/menu_items_page.dart';
import 'package:testing_api/services/api.dart';
import 'package:testing_api/services/apis_services/menu_apis/menu_apis.dart';
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
      drawer: userRole == UserRole.Manager
          ? ManagerDrawer()
          : userRole == UserRole.Customer
              ? CustomerDrawer()
              : null,
      drawerEnableOpenDragGesture: true,
    );
  }
}
