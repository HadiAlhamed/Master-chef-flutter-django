// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing_api/controllers/menu_item_controller.dart';

import 'package:testing_api/models/order_model.dart';
import 'package:testing_api/text_styles.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final MenuItemController menuController = Get.find<MenuItemController>();
  OrderCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "total cost : ${order.total}",
              style: btitleTextStyle1,
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
    );
  }
}
