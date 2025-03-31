import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing_api/auth/login.dart';
import 'package:testing_api/models/category.dart';
import 'package:testing_api/models/menu_item.dart';
import 'package:testing_api/models/menu_items_page.dart';
import 'package:testing_api/services/apis_services/auth_apis/auth_apis.dart';
import 'package:testing_api/services/apis_services/menu_apis/menu_apis.dart';
import 'package:testing_api/text_styles.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<MenuItem> menuItems = [];
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                  return ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    title: Text(
                      menuItems[index].title,
                      style: TextStyle(
                        fontFamily: "Lobster",
                        color: Colors.amber,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text(
                      "${menuItems[index].category.title} , ${menuItems[index].price} \$",
                      style: TextStyle(
                        fontFamily: "Lobster",
                      ),
                    ),
                    trailing: menuItems[index].featured
                        ? const Icon(Icons.star, color: Colors.orange)
                        : null,
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
            ListTile(
              title: const Text(
                "my cart",
                style: btitleTextStyle2,
              ),
              subtitle: const Text("show my cart", style: subtitleTextStyle),
              trailing: const Icon(
                Icons.shopping_cart,
                color: Colors.amber,
              ),
            ),
            ListTile(
              title: const Text("categories", style: btitleTextStyle2),
              subtitle: const Text("explore food categories",
                  style: subtitleTextStyle),
              trailing: const Icon(
                Icons.category,
                color: Colors.amber,
              ),
            ),
            Divider(),
          ],
        ),
      ),
      drawerEnableOpenDragGesture: true,
    );
  }
}
