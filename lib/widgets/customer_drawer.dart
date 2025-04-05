import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing_api/views/categories_page.dart';
import 'package:testing_api/views/customers_page.dart';
import 'package:testing_api/views/delivery_crew_page.dart';
import 'package:testing_api/views/menu.dart';
import 'package:testing_api/widgets/drawer_tile.dart';

class CustomerDrawer extends StatelessWidget {
  const CustomerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(),
            child: Text(
              'MasterChef\nCustomer',
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
              title: "My Orders",
              subtitle: "view and assign orders to delivery crew",
              icon: Icons.manage_accounts),
          DrawerTile(
            title: "Menu",
            subtitle: "view all menu items",
            icon: Icons.menu_book,
            onTap: () {
              Get.off(
                () => Menu(),
                transition: Transition.leftToRightWithFade,
                duration: const Duration(milliseconds: 400),
              );
            },
          ),
        ],
      ),
    );
  }
}
