import 'package:testing_api/models/category.dart';

class MenuItem {
  final String title;
  final String price; // Kept as String to match API's decimal format
  final bool featured;
  final int? categoryId;
  final Category category;

  MenuItem({
    required this.title,
    required this.price,
    required this.featured,
    this.categoryId,
    required this.category,
  });

  Map<String, dynamic> toApiJson() {
    return {
      'title': title,
      'price': price, // Send as decimal string
      'featured': featured,
      'category_id': categoryId,
      'category': {
        'slug': category.slug,
        'title': category.title,
      },
    };
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      title: json["title"],
      price: json["price"], // Ensure correct type
      featured: json["featured"],
      categoryId: json["category_id"] ?? 0,
      category: Category.fromJson(json["category"]),
    );
  }
}
