import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing_api/controllers/cart_controller.dart';
import 'package:testing_api/controllers/menu_item_controller.dart';
import 'package:testing_api/controllers/menu_item_counter_controller.dart';
import 'package:testing_api/services/api.dart';
import 'package:testing_api/services/apis_services/cart_apis/cart_apis.dart';
import 'package:testing_api/views/cart_page.dart';
import 'package:testing_api/views/categories_page.dart';
import 'package:testing_api/views/customers_page.dart';
import 'package:testing_api/views/delivery_crew_page.dart';
import 'package:testing_api/views/menu.dart';
import 'package:testing_api/widgets/drawer_tile.dart';

class CustomerDrawer extends StatelessWidget {
  CustomerDrawer({super.key});
  final MenuItemCounterController counterController =
      Get.find<MenuItemCounterController>();
  final MenuItemController menuController = Get.find<MenuItemController>();
  final CartController cartController = Get.find<CartController>();

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
          DrawerTile(
            title: "My Cart",
            subtitle: "view all menu items",
            icon: Icons.shopping_cart,
            onTap: () async {
              await addMenuItemsToCart();
              Get.off(
                () => CartPage(),
                transition: Transition.leftToRightWithFade,
                duration: const Duration(milliseconds: 400),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> addMenuItemsToCart() async {
    if (!counterController.needUpdate) return;
    await CartApis.deleteAllCartItems();
    cartController.clear();
    print("updating cart items....");
    for (int i = 0; i < 1050; i++) {
      if (counterController.counter[i].value > 0) {
        bool result = await CartApis.addCartItem(
          menuItemId: menuController.menuItems[i].id!,
          menuItemTitle: menuController.menuItems[i].title,
          quantity: counterController.counter[i].value,
          userId: Api.box.read('userId'),
        );
        if (result) {
          double totalPrice = double.parse(menuController.menuItems[i].price) *
              (counterController.counter[i].value);
          cartController.addToTotalBill(totalPrice);
        }
      }
    }
    counterController.changeNeedUpdate(false);
  }
}
