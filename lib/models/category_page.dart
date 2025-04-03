import 'package:testing_api/models/category.dart';

class CategoryPage {
  final List<Category>categories;
  final String? nextPageUrl;

  CategoryPage({required this.categories, required this.nextPageUrl});
}