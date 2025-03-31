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
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(),
              child: Text(
                'MasterChef',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Lobster",
                  fontWeight: FontWeight.w800,
                  fontSize: 30,
                  color: Colors.amber,
                ),
              ),
            ),
            //user stuff
            DrawerTile(
              title: "My Cart",
              subtitle: "show my cart",
              icon: Icons.shopping_cart,
            ),
            DrawerTile(
              title: "Orders",
              subtitle: "show my orders",
              icon: Icons.lock_clock,
            ),
            Divider(),
            //delivery part
            if (isDelivery || isManager)
              DrawerTile(
                title: 'Assigned Orders',
                subtitle: 'show orders assigned by manager',
                icon: Icons.food_bank,
              ),
            if (isDelivery  || isManager) Divider(),
            if (isManager)
              DrawerTile(
                  title: "New Menu Item",
                  subtitle: "add new menu item to the current menu",
                  icon: Icons.add_card),
            if (isManager)
              DrawerTile(
                  title: "Manage Orders",
                  subtitle: "view and assign orders to delivery crew",
                  icon: Icons.manage_accounts),
          ],
        ),
      ),
      drawerEnableOpenDragGesture: true,
    );
  }
}
