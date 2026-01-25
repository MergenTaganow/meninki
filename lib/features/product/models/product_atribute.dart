import 'package:meninki/features/product/models/product_parameters.dart';

class ProductAttribute {
  int id;
  String slug;
  String name;
  ProductParameter? parameter;

  ProductAttribute({required this.id, required this.slug, required this.name, this.parameter});

  factory ProductAttribute.fromJson(Map<String, dynamic> json) {
    return ProductAttribute(
      id: (json["id"]),
      slug: json["slug"],
      name: json["name"],
      parameter: json['parameter'] != null ? ProductParameter.fromJson(json['parameter']) : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAttribute && other.id == id && other.slug == slug && other.name == name;

  @override
  int get hashCode => id.hashCode;
}
