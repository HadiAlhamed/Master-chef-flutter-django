import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:testing_api/services/http_client/my_http_client.dart';

class AuthApis {
  static const String _baseUrl = "http://10.0.2.2:8000";

  static final GetStorage _box = GetStorage();

  // Enhanced cookie/CSRF handling
  static String? _extractCookie(String? headers, String name) {
    return RegExp('$name=([^;]+)').firstMatch(headers ?? '')?.group(1);
  }

  // Login with full cookie tracking
  static Future<bool> login(
      {required String username, required String password}) async {
    try {
      final response = await MyHttpClient.client.post(
        Uri.parse("$_baseUrl/auth/login/"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      print('Login Headers: ${response.headers}');

      if (response.statusCode == 200) {
        // Store all critical auth data
        _box.write('authHeaders', response.headers);
        _box.write('csrfToken',
            _extractCookie(response.headers['set-cookie'], 'csrftoken'));
        _box.write('sessionId',
            _extractCookie(response.headers['set-cookie'], 'sessionid'));
        return true;
      }
    } catch (e) {
      print('Login Error: $e');
    }
    return false;
  }

  // Robust logout implementation
  static Future<bool> logout() async {
    try {
      final response = await MyHttpClient.client.post(
        Uri.parse("$_baseUrl/auth/logout/"),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': _box.read('csrfToken') ?? '',
          // Explicitly send cookies if needed
          if (_box.read('sessionId') != null)
            'Cookie':
                'sessionid=${_box.read('sessionId')}; csrftoken=${_box.read('csrfToken')}',
        },
      );

      print('Logout Headers: ${response.headers}');
      print('Logout Body: ${response.body}');

      if (response.statusCode == 200) {
        await _cleanupAuth(); // Clear stored credentials
        return true;
      }
    } catch (e) {
      print('Logout Error: $e');
    }
    return false;
  }

  static Future<void> _cleanupAuth() async {
    await _box.remove('authHeaders');
    await _box.remove('csrfToken');
    await _box.remove('sessionId');
    MyHttpClient.client.close(); // Properly close old client
    MyHttpClient.client = http.Client(); //
  }

  static Future<bool> signup(
      {required String username,
      required String password,
      required String email}) async {
    print("starting post signup $_baseUrl .......");
    try {
      final http.Response response = await MyHttpClient.client.post(
        Uri.parse("$_baseUrl/auth/signup/"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'username': username,
            'password': password,
            'email': email,
          },
        ),
      );
      print("auth Signup post response code : ${response.statusCode}");
      if (response.statusCode == 201) {
        print("Signed up successfully!!!!!!");
        return true;
        //go to homepage
      } else {
        print("Falied to Signup !!!!!!!");
      }
    } catch (e) {
      print('Network error: $e');
    }
    return false;
  }

  static void dispose() {
    MyHttpClient.client.close(); // Call when app exits
  }
}
