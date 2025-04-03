import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:testing_api/models/menu_item.dart';
import 'package:testing_api/models/menu_items_page.dart';
import 'package:testing_api/services/api.dart';
import 'dart:convert';

import 'package:testing_api/services/http_client/my_http_client.dart';

class MenuApis {
  static Future<bool> postMenuItem({required MenuItem menuItem}) async {
    print("Post Menu Item ......");
    print(menuItem);
    try {
      final http.Response response = await MyHttpClient.client.post(
        Uri.parse("${Api.baseUrl}/api/menu-items/"),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': Api.box.read('csrfToken') ?? '',
          if (Api.box.read('sessionId') != null)
            'Cookie':
                'sessionid=${Api.box.read('sessionId')}; csrftoken=${Api.box.read('csrfToken')}',
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
          .get(Uri.parse(url ?? "${Api.baseUrl}/api/menu-items"), headers: {
        'Content-Type': 'application/json',
        'X-CSRFToken': Api.box.read('csrfToken') ?? '',
        if (Api.box.read('sessionId') != null)
          'Cookie':
              'sessionid=${Api.box.read('sessionId')}; csrftoken=${Api.box.read('csrfToken')}',
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

  static Future<bool> deleteMenuItem({required int menuItemId}) async {
    print("deleting Menu Item with id $menuItemId......");
    try {
      final http.Response response = await MyHttpClient.client.delete(
        Uri.parse("${Api.baseUrl}/api/menu-items/$menuItemId/"),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': Api.box.read('csrfToken') ?? '',
          if (Api.box.read('sessionId') != null)
            'Cookie':
                'sessionid=${Api.box.read('sessionId')}; csrftoken=${Api.box.read('csrfToken')}',
        },
        body: jsonEncode({
          'id': menuItemId,
        }),
      );
      print("response status code : ${response.statusCode}");
      if (response.statusCode == 204) {
        print("deleting Menu item Succeed!!!!");

        return true;
      } else {
        print("deleting Menu item Faild!!!");
      }
    } catch (e) {
      print("Network Error : $e");
    }
    return false;
  }
}
