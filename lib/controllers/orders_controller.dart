import 'package:get/get.dart';
import 'package:testing_api/models/order_model.dart';

class OrdersController extends GetxController {
  bool needUpdate = true;
  List<OrderModel> Orders = [];
  bool isLoading = true;
  void changeNeedUpdate(bool value) {
    needUpdate = value;
  }

  void changeIsLoading(bool value) {
    isLoading = value;
    update();
  }

  void addOrder(OrderModel order) {
    Orders.add(order);
  }

  void clear() {
    Orders.clear();
    needUpdate = true;
    isLoading = true;
  }
}
