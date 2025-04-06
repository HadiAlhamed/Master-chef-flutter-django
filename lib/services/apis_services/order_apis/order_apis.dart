import 'dart:convert';

import 'package:http/http.dart' as http;
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
}
