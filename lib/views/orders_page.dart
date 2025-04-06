import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:testing_api/Enums/user_role.dart';
import 'package:testing_api/controllers/orders_controller.dart';
import 'package:testing_api/models/paginated_order.dart';
import 'package:testing_api/services/api.dart';
import 'package:testing_api/services/apis_services/order_apis/order_apis.dart';
import 'package:testing_api/text_styles.dart';
import 'package:testing_api/widgets/customer_drawer.dart';
import 'package:testing_api/widgets/main_appbar.dart';
import 'package:testing_api/widgets/manager_drawer.dart';
import 'package:testing_api/widgets/menu_bottomsheet.dart';
import 'package:testing_api/widgets/order_card.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  UserRole userRole = UserRole.Customer;
  final OrdersController ordersController = Get.find<OrdersController>();
  @override
  void initState() {
    print("Orders Page Loaded");
    super.initState();
    if (Api.box.read("role").toString().toLowerCase() == 'manager') {
      userRole = UserRole.Manager;
    } else if (Api.box.read("role").toString().toLowerCase() == 'delivery') {
      userRole = UserRole.Delivery;
    }

    // if (ordersController.needUpdate) {
    _fetchData();
    // }
  }

  Future<void> _fetchData() async {
    print("fetching orders....");
    ordersController.clear();
    ordersController.changeIsLoading(true);
    PaginatedOrder pOrder = await OrderApis.getAllOrders();
    for (var item in pOrder.orders) {
      ordersController.addOrder(item);
    }
    while (pOrder.nextUrlPage != null) {
      pOrder = await OrderApis.getAllOrders(url: pOrder.nextUrlPage);
      for (var item in pOrder.orders) {
        ordersController.addOrder(item);
      }
    }
    ordersController.changeIsLoading(false);
    ordersController.changeNeedUpdate(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        myTitle: "Orders",
      ),
      body: GetBuilder<OrdersController>(
          init: ordersController,
          builder: (controller) {
            if (ordersController.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (ordersController.Orders.isEmpty) {
              return const Center(
                child: Text(
                  "You Have No Orders Yet.",
                  style: btitleTextStyle1,
                ),
              );
            }
            return Container(
              margin: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: ordersController.Orders.length,
                itemBuilder: (context, index) {
                  int len = ordersController.Orders.length;
                  return AnimationConfiguration.staggeredGrid(
                    columnCount: 1,
                    position: index,
                    duration: const Duration(milliseconds: 400),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: OrderCard(
                          order: ordersController.Orders[len - index - 1],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
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
