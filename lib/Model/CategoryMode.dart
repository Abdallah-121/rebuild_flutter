// ignore_for_file: file_names

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['categoryId'], name: json['categoryName']);
  }
}
