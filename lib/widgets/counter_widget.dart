// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing_api/controllers/menu_item_counter_controller.dart';

class CounterWidget extends StatelessWidget {
  final int index;
  const CounterWidget({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final MenuItemCounterController counterController =
        Get.find<MenuItemCounterController>();
    return Row(
      children: [
        TextButton(
            onPressed: () {
              counterController.decrementCounter(index);
            },
            child: const Text("-")),
        TextButton(
            onPressed: () {
              counterController.incrementCounter(index);
            },
            child: const Text("+")),
        Obx(() {
          return Text("${counterController.counter[index].value}");
        })
      ],
    );
  }
}
