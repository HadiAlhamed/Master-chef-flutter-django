import 'package:testing_api/models/menu_item.dart';

class MenuItemsPage {
  final List<MenuItem> menuItems;
  final String? nextPageUrl;

  MenuItemsPage({required this.menuItems, this.nextPageUrl});
}
