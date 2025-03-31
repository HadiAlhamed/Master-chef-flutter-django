import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:testing_api/services/api.dart';
import 'package:testing_api/services/http_client/my_http_client.dart';

class RoleApi {
  static Future<void> getRole() async {
    print("fetching user role ....");
    try {
      final http.Response response = await MyHttpClient.client.get(
        Uri.parse("${Api.baseUrl}/api/role"),
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
        print(jsonData['role']);
        Api.box.write("role", jsonData['role'].toString().toLowerCase());
      } else {
        print("Unauthrized!!!");
      }
    } catch (e) {
      print("Network Error : $e");
    }
  }
}
