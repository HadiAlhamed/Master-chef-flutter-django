import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing_api/controllers/delivery_crew_controller.dart';
import 'package:testing_api/controllers/menu_item_counter_controller.dart';
import 'package:testing_api/controllers/passwordController.dart';

class MyBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(Passwordcontroller()); // Initialize here
    Get.put(MenuItemCounterController());
    Get.put(DeliveryCrewController());
  }
}
