import 'package:get/get.dart';
import 'package:testing_api/models/cart_item.dart';

class CartController extends GetxController {
  List<CartItem> cartItems = [];
  bool needUpdate = true;

  void changeNeedUpdate(bool value) {
    needUpdate = value;
  }

  void addToCart(CartItem cartItem) {
    cartItems.add(cartItem);
  }
  void addAllToCart(List<CartItem>list) {
    cartItems.addAll(list);
  }


  void clear() {
    cartItems.clear();
    needUpdate = true;
  }
}
