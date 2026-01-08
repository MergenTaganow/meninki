import 'package:meninki/features/global/model/name.dart';

class Category {
  int id;
  Name? name;
  int? parent_id;
  bool is_active;
  String? icon;
  String? slug;
  int? level;
  List<Category>? children;

  Category({
    required this.id,
    required this.name,
    this.parent_id,
    required this.is_active,
    this.icon,
    this.slug,
    this.level,
    this.children,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: (json["id"]),
      name: json["name"] != null ? Name.fromJson(json["name"]) : null,
      parent_id: (json["parent_id"]),
      is_active: json["is_active"],
      icon: json["icon"],
      slug: json["slug"],
      level: (json["level"]),
      children:
          (json["children"] != null && (json["children"] as List).isNotEmpty)
              ? (json["children"] as List).map((e) => Category.fromJson(e)).toList()
              : null,
    );
  }
}
