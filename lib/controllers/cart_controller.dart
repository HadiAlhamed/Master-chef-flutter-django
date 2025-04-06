import 'package:get/get.dart';
import 'package:testing_api/models/cart_item.dart';

class CartController extends GetxController {
  List<CartItem> cartItems = [];
  double totalbill = 0.0;
  void addToCart(CartItem cartItem) {
    cartItems.add(cartItem);
  }

  void addAllToCart(List<CartItem> list) {
    cartItems.addAll(list);
  }

  void addToTotalBill(double value) {
    totalbill += value;
  }

  void clear() {
    cartItems.clear();
    totalbill = 0;
  }
}
