import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:testing_api/controllers/cart_controller.dart';
import 'package:testing_api/models/cart_item.dart';

import '../../api.dart';
import '../../http_client/my_http_client.dart';

class CartApis {
  static const cartApi = '/api/cart/menu-items/';
  static final CartController cartController = Get.find<CartController>();
  static Future<bool> postCart(
      {required int userId,
      required int menuItemId,
      required int quantity}) async {
    print("adding menu Item $menuItemId to cart ...");

    try {
      print(" CSRFTOKEN : ${Api.box.read('csrfToken')}");

      final http.Response response = await MyHttpClient.client.post(
        Uri.parse('${Api.baseUrl}$cartApi'),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': Api.box.read('csrfToken') ?? '',
          if (Api.box.read('sessionId') != null)
            'Cookie':
                "sessionid=${Api.box.read('sessionId')}; csrftoken=${Api.box.read('csrfToken')}",
        },
        body: jsonEncode({
          'user': userId,
          'menuitem': menuItemId,
          'quantity': quantity,
        }),
      );
      if (response.statusCode == 201) {
        print("added to cart successfully ...");
        //will return a cart object handle it carefully;
        //add it to the cartController.cartItems
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        List<CartItem> list = (jsonData['results'] as List)
            .map(
              (item) => CartItem.fromJson(item),
            )
            .toList();
        cartController.addAllToCart(list);
        return true;
      } else {
        print("Failed to add to cart .... ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      print("Network Error : $e");
    }
    return false;
  }
}
