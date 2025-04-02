import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:testing_api/models/user.dart';
import 'package:testing_api/models/user_page.dart';
import 'package:testing_api/services/api.dart';
import 'package:testing_api/services/http_client/my_http_client.dart';

class DeliveryCrewApis {
  static const String deliveryApi = "/api/groups/delivery-crew/users/";

  static Future<UserPage> getAllDeliveryCrew({String? url}) async {
    print("Fetching all delivery crew ... ");
    try {
      final http.Response response = await MyHttpClient.client.get(
        Uri.parse(url ?? "${Api.baseUrl}$deliveryApi"),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': Api.box.read('csrfToken') ?? '',
          if (Api.box.read('sessionId') != null)
            'Cookie':
                'sessionid=${Api.box.read('sessionId')}; csrftoken=${Api.box.read('csrfToken')}',
        },
      );

      if (response.statusCode == 200) {
        print("fetching delivery crew of this page succeed!");
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

  static Future<bool> deleteDeliveryCrew({required int userId}) async {
    print("Deleting user with id $userId");
    try {
      final http.Response response = await MyHttpClient.client.delete(
        Uri.parse("${Api.baseUrl}$deliveryApi$userId/"),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': Api.box.read('csrfToken') ?? '',
          if (Api.box.read('sessionId') != null)
            'Cookie':
                'sessionid=${Api.box.read('sessionId')}; csrftoken=${Api.box.read('csrfToken')}',
        },
        body: jsonEncode(
          {
            'id': userId,
          },
        ),
      );

      if (response.statusCode == 200) {
        print("user removed from delivery crew ...");
        return true;
      } else if (response.statusCode == 404) {
        print("Failed to delete Delivery crew : User not found !!!");
      } else {
        print("Failed to delete delivery crew : ${response.statusCode}");
      }
    } catch (e) {
      print("Network Error : $e");
    }
    return false;
  }

  static Future<bool> addDeliveryCrew({required int userId}) async {
    //implement here
    return true;
  }
}
