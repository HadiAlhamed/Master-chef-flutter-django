import 'package:flutter/material.dart';
import 'package:testing_api/widgets/drawer_tile.dart';

class ManagerDrawer extends StatelessWidget {
  const ManagerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(),
            child: Text(
              'MasterChef\nManager',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Lobster",
                fontWeight: FontWeight.w800,
                fontSize: 30,
                color: Colors.amber,
              ),
            ),
          ),
          DrawerTile(
              title: "Manage Orders",
              subtitle: "view and assign orders to delivery crew",
              icon: Icons.manage_accounts),
          DrawerTile(
              title: "Users",
              subtitle: "view all users of the app",
              icon: Icons.person),
          DrawerTile(
              title: "Delivery Crew",
              subtitle: "view all delivery crew of the app",
              icon: Icons.pedal_bike),
          DrawerTile(
              title: "Menu",
              subtitle: "view, update or delete all menu items",
              icon: Icons.menu_book),
          DrawerTile(
              title: "Categories",
              subtitle: "view, update or delete all existing categories",
              icon: Icons.category_rounded),
          DrawerTile(
              title: "Add Menu Item",
              subtitle: "add new menu item to the current menu",
              icon: Icons.add_card),
          DrawerTile(
              title: "Add Category",
              subtitle: "add new category to the current categories",
              icon: Icons.category_outlined),
        ],
      ),
    );
  }
}
