class Category {
  final String slug;
  final String title;

  Category({
    required this.slug,
    required this.title,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      slug: json['slug'],
      title: json['title'],
    );
  }
  Map<String, dynamic> toApiJson() {
    return {
      'slug': slug,
      'title': title,
    };
  }
}
