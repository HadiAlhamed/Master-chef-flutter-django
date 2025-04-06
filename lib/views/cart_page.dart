import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:testing_api/Enums/user_role.dart';
import 'package:testing_api/controllers/cart_controller.dart';
import 'package:testing_api/controllers/chosen_category_controller.dart';
import 'package:testing_api/controllers/menu_item_controller.dart';
import 'package:testing_api/controllers/menu_item_counter_controller.dart';
import 'package:testing_api/models/category_page.dart';
import 'package:testing_api/models/menu_items_page.dart';
import 'package:testing_api/services/api.dart';
import 'package:testing_api/services/apis_services/cart_apis/cart_apis.dart';
import 'package:testing_api/services/apis_services/category_apis/category_apis.dart';
import 'package:testing_api/services/apis_services/menu_apis/menu_apis.dart';
import 'package:testing_api/widgets/customer_drawer.dart';
import 'package:testing_api/widgets/main_appbar.dart';
import 'package:testing_api/widgets/manager_drawer.dart';
import 'package:testing_api/widgets/menu_bottomsheet.dart';
import 'package:testing_api/widgets/menu_item_tile.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  UserRole userRole = UserRole.Customer;
  final ChosenCategoryController categoryController =
      Get.find<ChosenCategoryController>();
  final MenuItemController menuController = Get.find<MenuItemController>();

  final MenuItemCounterController counterController =
      Get.find<MenuItemCounterController>();

  final CartController cartController = Get.find<CartController>();
  bool isLoading = false;
  @override
  void initState() {
    print("Cart Page Loaded");

    super.initState();
    if (Api.box.read("role").toString().toLowerCase() == 'manager') {
      userRole = UserRole.Manager;
    } else if (Api.box.read("role").toString().toLowerCase() == 'delivery') {
      userRole = UserRole.Delivery;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        myTitle: "My Cart",
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GetBuilder<MenuItemController>(
              builder: (controller) => Container(
                margin: const EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: menuController.menuItems.length,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 400),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: MenuItemTile(
                            enable: !menuController.deleted[index],
                            menuItem: menuController.menuItems[index],
                            index: index,
                            userRole: userRole,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
      floatingActionButton: userRole == UserRole.Delivery
          ? null
          : FloatingActionButton.extended(
              onPressed: () async {
                if (userRole == UserRole.Manager) {
                  await addMenuItemFloatingButton();
                } else {
                  await addMenuItemsToCart();
                  Get.off(
                    () => CartPage(),
                    preventDuplicates: false,
                    transition: Transition.fadeIn,
                    duration: const Duration(milliseconds: 300),
                  );
                }
              },
              label: Text(userRole == UserRole.Manager
                  ? "Add Menu Item"
                  : "Check To Cart"),
              icon: Icon(userRole == UserRole.Manager
                  ? Icons.add
                  : Icons.shopping_cart),
            ),
      drawer: userRole == UserRole.Manager
          ? ManagerDrawer()
          : userRole == UserRole.Customer
              ? CustomerDrawer()
              : null,
      drawerEnableOpenDragGesture: true,
    );
  }

  Future<void> addMenuItemFloatingButton() async {
    await Get.bottomSheet(
      MenuBottomsheet(),
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> addMenuItemsToCart() async {
    if (!counterController.needUpdate) return;
    await CartApis.deleteAllCartItems();
    for (int i = 0; i < 1050; i++) {
      if (counterController.counter[i].value > 0) {
        bool result = await CartApis.addCartItem(
          menuItemId: menuController.menuItems[i].id!,
          quantity: counterController.counter[i].value,
          userId: Api.box.read('userId'),
        );
      }
    }
    counterController.changeNeedUpdate(false);
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }
}
