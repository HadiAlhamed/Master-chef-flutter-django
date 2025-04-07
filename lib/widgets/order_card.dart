// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing_api/Enums/user_role.dart';
import 'package:testing_api/controllers/delivery_crew_controller.dart';
import 'package:testing_api/controllers/menu_item_controller.dart';
import 'package:testing_api/controllers/orders_controller.dart';

import 'package:testing_api/models/order_model.dart';
import 'package:testing_api/services/apis_services/order_apis/order_apis.dart';
import 'package:testing_api/text_styles.dart';
import 'package:testing_api/views/delivery_crew_page.dart';
import 'package:testing_api/widgets/my_snackbar.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final UserRole userRole;
  final int index;
  final MenuItemController menuController = Get.find<MenuItemController>();
  final DeliveryCrewController crewController =
      Get.find<DeliveryCrewController>();
  final OrdersController ordersController = Get.find<OrdersController>();
  OrderCard({
    super.key,
    required this.order,
    required this.userRole,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: userRole == UserRole.Customer
          ? null
          : () {
              crewController.changePickDelivery(
                value: true,
              );
              ordersController.setOrderToPickFor(
                id: order.orderId,
                index: index,
              );
              Get.off(
                () => DeliveryCrewPage(),
                transition: Transition.fadeIn,
                duration: const Duration(milliseconds: 300),
              );
            },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  userRole == UserRole.Customer
                      ? "total cost : ${order.total}"
                      : "User Id : ${order.userId}",
                  style: btitleTextStyle1,
                ),
                trailing: userRole == UserRole.Manager
                    ? IconButton(
                        onPressed: () async {
                          bool result = await OrderApis.deleteOrder(
                              orderId: order.orderId);
                          if (result) {
                            ordersController.deleteOrderAt(index);
                          }
                          Get.showSnackbar(
                            MySnackbar(
                              success: result,
                              title: "Delete Order",
                              message: result
                                  ? "Order Deleted Successfully"
                                  : "Failed to delete order , please try later",
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: Colors.red,
                          size: 30,
                        ),
                      )
                    : userRole == UserRole.Delivery
                        ? IconButton(
                            onPressed: () async {
                              bool result =
                                  await OrderApis.updateOrderStatusByDelivery(
                                orderId: order.orderId,
                                status: order.status ? 0 : 1,
                              );
                              if (result) {
                                ordersController.setStatusFor(
                                    index: index, status: !order.status);
                              }
                              print(result);
                            },
                            icon: Icon(
                              order.status
                                  ? Icons.remove_circle_outline
                                  : Icons.check,
                              color: order.status ? Colors.red : Colors.green,
                              size: 30,
                            ),
                          )
                        : null,
              ),
              if (userRole == UserRole.Manager)
                ListTile(
                  title: Text(
                    "Assigned to : ${order.deliveryCrew ?? "None"}",
                    style: btitleTextStyle1,
                    textAlign: TextAlign.start,
                  ),
                ),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: order.orderItems.length + 1,
                  itemBuilder: (context, index) {
                    if (index == order.orderItems.length) {
                      return ListTile(
                        leading:
                            Icon(order.status ? Icons.check : Icons.lock_clock),
                        title: Text(
                          order.status ? "Delivered" : "In progress",
                          style: btitleTextStyle2,
                        ),
                      );
                    }
                    String? menuItemTitle = menuController
                        .menuItemTitleById[order.orderItems[index].menuItemId];
                    int quantity = order.orderItems[index].quantity;
                    String total = order.orderItems[index].price;

                    return ListTile(
                      leading: Icon(Icons.shopping_bag),
                      title: Text(
                        '$menuItemTitle | #$quantity | $total',
                        style: btitleTextStyle2,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
