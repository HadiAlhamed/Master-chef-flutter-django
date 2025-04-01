import 'package:testing_api/models/user.dart';

class UserPage {
  final List<User> users;
  final String? nextPageUrl;

  UserPage({required this.users, required this.nextPageUrl});
}
