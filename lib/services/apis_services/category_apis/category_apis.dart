import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:testing_api/models/category.dart';
import 'package:testing_api/models/category_page.dart';
import 'package:http/http.dart' as http;
import 'package:testing_api/services/api.dart';
import 'package:testing_api/services/http_client/my_http_client.dart';

class CategoryApis {
  static const String categoryApi = "/api/categories/";

  static Future<CategoryPage> getAllCategories({String? url}) async {
    print("Fetching categories of this page ... ");
    try {
      final http.Response response = await MyHttpClient.client.get(
        Uri.parse(url ?? '${Api.baseUrl}/$categoryApi'),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': Api.box.read('csrfToken') ?? '',
          // Explicitly send cookies if needed
          if (Api.box.read('sessionId') != null)
            'Cookie':
                'sessionid=${Api.box.read('sessionId')}; csrftoken=${Api.box.read('csrfToken')}',
        },
      );
      if (response.statusCode == 200) {
        debugPrint("fetching categories succeed ...");
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        List<Category> list = (jsonData['results'] as List)
            .map((item) => Category.fromJson(item))
            .toList();
        return CategoryPage(categories: list, nextPageUrl: jsonData['next']);
      } else {
        debugPrint("Falid Fetching categories !! : ${response.statusCode} ...");
      }
    } catch (e) {
      print("Network Error : $e");
    }
    return CategoryPage(categories: [], nextPageUrl: null);
  }
}
