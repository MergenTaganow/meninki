import 'package:meninki/features/global/model/name.dart';

class ProductParameter {
  int id;
  String slug;
  Name name;
  String? attribute_count;

  ProductParameter({
    required this.id,
    required this.slug,
    required this.name,
    this.attribute_count,
  });

  factory ProductParameter.fromJson(Map<String, dynamic> json) {
    return ProductParameter(
      id: (json["id"]),
      slug: json["slug"],
      name: Name.fromJson(json["name"]),
      attribute_count: json["attribute_count"],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductParameter &&
          other.id == id &&
          other.slug == slug &&
          other.name == name &&
          other.attribute_count == attribute_count;

  @override
  int get hashCode => id.hashCode;
}
