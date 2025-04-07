import 'package:get/get.dart';
import 'package:testing_api/models/order_model.dart';

class OrdersController extends GetxController {
  bool needUpdate = true;
  List<OrderModel> Orders = [];
  bool isLoading = true;
  int orderIdToPick = 0;
  int indexOfOrder = 0;
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

  void setOrderToPickFor({required int id, required int index}) {
    orderIdToPick = id;
    indexOfOrder = index;
  }

  void setDeliveryFor({required int deliveryId}) {
    Orders[indexOfOrder].deliveryCrew = deliveryId;
    update();
  }

  void setStatusFor({required int index, required bool status}) {
    Orders[index].status = status;
    update();
  }

  void clear() {
    Orders.clear();
    needUpdate = true;
    isLoading = true;
  }
}
