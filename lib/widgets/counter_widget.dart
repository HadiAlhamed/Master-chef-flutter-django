// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing_api/controllers/menu_item_controller.dart';
import 'package:testing_api/controllers/menu_item_counter_controller.dart';

class CounterWidget extends StatelessWidget {
  final int index;
  CounterWidget({
    super.key,
    required this.index,
  });

  final MenuItemCounterController counterController =
      Get.find<MenuItemCounterController>();
  final MenuItemController menuController = Get.find<MenuItemController>();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              print("index : $index");
              counterController.decrementCounter(index);
            },
            icon: const Icon(Icons.remove, color: Colors.red),
          ),
          IconButton(
            onPressed: () {
              print("index : $index");
              counterController.incrementCounter(index);
            },
            icon: const Icon(
              Icons.add,
              color: Colors.green,
            ),
          ),
          Obx(() {
            return Text("${counterController.counter[index].value}");
          })
        ],
      ),
    );
  }
}
