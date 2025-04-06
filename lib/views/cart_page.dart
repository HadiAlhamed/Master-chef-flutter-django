import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:testing_api/Enums/user_role.dart';
import 'package:testing_api/controllers/cart_controller.dart';
import 'package:testing_api/services/api.dart';
import 'package:testing_api/text_styles.dart';
import 'package:testing_api/widgets/cart_item_tile.dart';
import 'package:testing_api/widgets/customer_drawer.dart';
import 'package:testing_api/widgets/main_appbar.dart';
import 'package:testing_api/widgets/manager_drawer.dart';
import 'package:testing_api/widgets/menu_bottomsheet.dart';
import 'package:testing_api/widgets/my_button.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  UserRole userRole = UserRole.Customer;
  final CartController cartController = Get.find<CartController>();
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
      body: GetBuilder<CartController>(
        init: cartController,
        builder: (controller) => Container(
          margin: const EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: cartController.cartItems.isEmpty
                ? cartController.cartItems.length + 1
                : cartController.cartItems.length + 2,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 400),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: index == cartController.cartItems.length
                        ? Card(
                            child: ListTile(
                              title: Text(
                                "Total bill : ${cartController.totalbill}",
                                style: btitleTextStyle2,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : index == cartController.cartItems.length + 1
                            ? MyButton(
                                onPressed: () {},
                                title: "Place Order",
                                color: Colors.amberAccent,
                              )
                            : CartItemTile(
                                cartItem: cartController.cartItems[index],
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

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }
}
