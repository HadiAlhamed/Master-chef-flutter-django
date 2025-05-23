import 'package:get/get.dart';
import 'package:testing_api/controllers/auth_loading_controller.dart';
import 'package:testing_api/controllers/cart_controller.dart';
import 'package:testing_api/controllers/chosen_category_controller.dart';
import 'package:testing_api/controllers/customer_controller.dart';
import 'package:testing_api/controllers/delivery_crew_controller.dart';
import 'package:testing_api/controllers/featured_controller.dart';
import 'package:testing_api/controllers/menu_item_controller.dart';
import 'package:testing_api/controllers/menu_item_counter_controller.dart';
import 'package:testing_api/controllers/orders_controller.dart';
import 'package:testing_api/controllers/passwordController.dart';

class MyBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthLoadingController());
    Get.put(Passwordcontroller()); // Initialize here
    Get.put(MenuItemCounterController());
    Get.put(DeliveryCrewController());
    Get.put(CustomerController());
    Get.put(FeaturedController());
    Get.put(ChosenCategoryController());
    Get.put(MenuItemController());
    Get.put(CartController());
    Get.put(OrdersController());
  }
}
