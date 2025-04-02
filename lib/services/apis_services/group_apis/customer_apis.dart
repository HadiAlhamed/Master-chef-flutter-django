import 'dart:convert';

import 'package:testing_api/models/user.dart';
import 'package:testing_api/models/user_page.dart';
import 'package:http/http.dart' as http;
import 'package:testing_api/services/api.dart';
import 'package:testing_api/services/http_client/my_http_client.dart';

class CustomerApis {
  static Future<List<User>> getAllCustomers() async {
    //get
    print("fetching all customers ...");
    try {
      final http.Response response = await MyHttpClient.client.get(
        Uri.parse('${Api.baseUrl}/api/users/'),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': Api.box.read('csrfToken') ?? '',
          if (Api.box.read('sessionId') != null)
            'Cookie':
                'sessionid=${Api.box.read('sessionId')}; csrftoken=${Api.box.read('csrfToken')}',
        },
      );
      if (response.statusCode == 200) {
        print("fetching customers succeed");
        List<dynamic> jsonData = jsonDecode(response.body);
        List<User> list = jsonData.map((item) {
          return User.fromJson(item);
        }).toList();
        return list;
      } else if (response.statusCode == 401) {
        print("Error Fetching Customers: Unauthorized!!!");
      } else if (response.statusCode == 403) {
        print("Error Fetching Customers: Manager Access Required!!!");
      } else if (response.statusCode == 404) {
        print("Error Fetching Customers: Customer group not found!!!");
      } else {
        print("Error Fetching Customers: ${response.statusCode}!!!");
      }
    } catch (e) {
      print("Network Error : $e");
    }
    return <User>[];
  }
}
