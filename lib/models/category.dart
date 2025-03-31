class Category {
  final int id;
  final String slug;
  final String title;

  Category({
    required this.id,
    required this.slug,
    required this.title,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      slug: json['slug'],
      title: json['title'],
    );
  }
  Map<String, dynamic> toApiJson() {
    return {
      'id': id,
      'slug': slug,
      'title': title,
    };
  }
}
