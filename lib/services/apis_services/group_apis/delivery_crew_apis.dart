import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:testing_api/models/user.dart';
import 'package:testing_api/models/user_page.dart';
import 'package:testing_api/services/api.dart';
import 'package:testing_api/services/http_client/my_http_client.dart';

class DeliveryCrewApis {
  static const String deliveryApi = "api/groups/delivery-crew/users/";
  static Future<UserPage> getAllDeliveryCrew({String? url}) async {
    print("Fetching all delivery crew ... ");
    try {
      final http.Response response = await MyHttpClient.client.get(
        Uri.parse("${Api.baseUrl}/$deliveryApi"),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': Api.box.read('csrfToken') ?? '',
          if (Api.box.read('sessionId') != null)
            'Cookie':
                'sessionid=${Api.box.read('sessionId')}; csrftoken=${Api.box.read('csrfToken')}',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        List<User> list = (jsonData['results'] as List).map((item) {
          return User.fromJson(item);
        }).toList();
        return UserPage(users: list, nextPageUrl: jsonData['next']);
      } else {
        print("Failed to fetch Delivery crew...!!! ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      print("Network Error : $e");
    }
    return UserPage(users: [], nextPageUrl: null);
  }
}
