import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:testing_api/models/menu_item.dart';
import 'package:testing_api/models/menu_items_page.dart';
import 'dart:convert';

import 'package:testing_api/services/http_client/my_http_client.dart';

class MenuApis {
  static const String _baseUrl = "http://10.0.2.2:8000";
  static final GetStorage _box = GetStorage();

  static Future<bool> postMenuItem({required MenuItem menuItem}) async {
    print("Post Menu Item ......");
    print(menuItem);
    try {
      final http.Response response = await MyHttpClient.client.post(
        Uri.parse("$_baseUrl/api/menu-items/"),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': _box.read('csrfToken') ?? '',
          if (_box.read('sessionId') != null)
            'Cookie':
                'sessionid=${_box.read('sessionId')}; csrftoken=${_box.read('csrfToken')}',
        },
        body: jsonEncode(menuItem.toApiJson()),
      );
      print("response status code : ${response.statusCode}");
      if (response.statusCode == 201) {
        print("Post Menu Items Succeed!!!!");

        return true;
      } else {
        print("Post Menu Items Faild!!!");
      }
    } catch (e) {
      print("Network Error : $e");
    }
    return false;
  }

  static Future<MenuItemsPage> getMenuItems({String? url}) async {
    print("fetching menu items ....");
    try {
      final http.Response response = await MyHttpClient.client
          .get(Uri.parse(url ?? "$_baseUrl/api/menu-items"), headers: {
        'Content-Type': 'application/json',
        'X-CSRFToken': _box.read('csrfToken') ?? '',
        if (_box.read('sessionId') != null)
          'Cookie':
              'sessionid=${_box.read('sessionId')}; csrftoken=${_box.read('csrfToken')}',
      });

      if (response.statusCode == 200) {
        //map{ , , , ,result : [m1 , m2]}
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        List<MenuItem> list = (jsonData['results'] as List).map((item) {
          print(item);
          return MenuItem.fromJson(item);
        }).toList();
        return MenuItemsPage(menuItems: list, nextPageUrl: jsonData['next']);
      } else {
        print("Failed to fetch menu items!");
      }
    } catch (e) {
      print("Network Error : $e");
    }
    return MenuItemsPage(menuItems: [], nextPageUrl: null);
  }
}
