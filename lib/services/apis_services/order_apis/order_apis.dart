import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:testing_api/models/order_model.dart';
import 'package:testing_api/models/paginated_order.dart';
import 'package:testing_api/services/api.dart';
import 'package:testing_api/services/http_client/my_http_client.dart';

class OrderApis {
  static const String orderApi = "/api/orders/";
  static Future<bool> addNewOrder() async {
    try {
      final http.Response response = await MyHttpClient.client
          .post(Uri.parse('${Api.baseUrl}$orderApi'), headers: {
        'Content-Type': 'application/json',
        'X-CSRFToken': Api.box.read('csrfToken') ?? '',
        if (Api.box.read('sessionId') != null)
          'Cookie':
              'sessionid=${Api.box.read('sessionId')}; csrftoken=${Api.box.read('csrfToken')}',
      });
      if (response.statusCode == 201) {
        print("order added successfully ...");
        return true;
      } else {
        print("Failed to add order : ${response.statusCode}");
        print(jsonDecode(response.body));
      }
    } catch (e) {
      print("Network Error : $e");
    }
    return false;
  }

  static Future<bool> updateOrderDelivery(
      {required int orderId,
      required int deliveryId,
      required bool status}) async {
    print("Assigning Delivery with id $deliveryId to order $orderId");
    try {
      final http.Response response = await MyHttpClient.client.put(
        Uri.parse('${Api.baseUrl}$orderApi$orderId/'),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': Api.box.read('csrfToken') ?? '',
          if (Api.box.read('sessionId') != null)
            'Cookie':
                'sessionid=${Api.box.read('sessionId')}; csrftoken=${Api.box.read('csrfToken')}',
        },
        body: jsonEncode({
          'delivery_crew': deliveryId,
          'status': status,
        }),
      );
      if (response.statusCode == 200) {
        print("order updated with delivery crew successfully ...");
        return true;
      } else {
        print(
            "Failed to update order with delivery crew  : ${response.statusCode}");
        print(jsonDecode(response.body));
      }
    } catch (e) {
      print("Network Error : $e");
    }
    return false;
  }

  static Future<PaginatedOrder> getAllOrders({String? url}) async {
    try {
      final http.Response response = await MyHttpClient.client.get(
        Uri.parse(url ?? '${Api.baseUrl}$orderApi'),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': Api.box.read('csrfToken') ?? '',
          if (Api.box.read('sessionId') != null)
            'Cookie':
                'sessionid=${Api.box.read('sessionId')}; csrftoken=${Api.box.read('csrfToken')}',
        },
      );
      if (response.statusCode == 200) {
        print("order Fetched successfully ...");
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        print(jsonData);
        List<OrderModel> list = (jsonData['results'] as List).map((item) {
          return OrderModel.fromJson(item);
        }).toList();
        print(list);
        return PaginatedOrder(
          nextUrlPage: jsonData['next'],
          orders: list,
        );
      } else {
        print("Failed to get all orders : ${response.statusCode}");
        print(jsonDecode(response.body));
      }
    } catch (e) {
      print("Network Error : $e");
    }
    return PaginatedOrder(
      nextUrlPage: null,
      orders: [],
    );
  }
}
