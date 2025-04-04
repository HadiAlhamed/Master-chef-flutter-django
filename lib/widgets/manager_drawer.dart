import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing_api/views/categories_page.dart';
import 'package:testing_api/views/customers_page.dart';
import 'package:testing_api/views/delivery_crew_page.dart';
import 'package:testing_api/views/menu.dart';
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
            title: "Delivery Crew",
            subtitle: "view all delivery crew of the app",
            icon: Icons.pedal_bike,
            onTap: () {
              Get.off(
                () => DeliveryCrewPage(),
                transition: Transition.leftToRightWithFade,
                duration: const Duration(milliseconds: 400),
              );
            },
          ),
          DrawerTile(
            title: "Customers",
            subtitle: "view all customers accounts",
            icon: Icons.person_2,
            onTap: () {
              Get.off(
                () => CustomersPage(
                  addToDelivery: false,
                ),
                transition: Transition.leftToRightWithFade,
                duration: const Duration(milliseconds: 200),
              );
            },
          ),
          DrawerTile(
            title: "Menu",
            subtitle: "view, update or delete all menu items",
            icon: Icons.menu_book,
            onTap: () {
              Get.off(
                () => Menu(),
                transition: Transition.leftToRightWithFade,
                duration: const Duration(milliseconds: 400),
              );
            },
          ),
          DrawerTile(
            title: "Categories",
            subtitle: "view, update or delete all existing categories",
            icon: Icons.category_rounded,
            onTap: () => Get.off(
              () => CategoriesPage(),
              transition: Transition.leftToRightWithFade,
              duration: const Duration(milliseconds: 400),
            ),
          ),
        ],
      ),
    );
  }
}
