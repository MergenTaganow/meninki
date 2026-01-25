import 'package:meninki/features/global/model/name.dart';
import 'package:meninki/features/product/models/product.dart';
import 'package:meninki/features/product/models/product_atribute.dart';

class Composition {
  int? id;
  Name? title;
  bool? is_main;
  bool? is_active;
  num? quantity;
  List<ProductAttribute>? attributes;
  Product? product;

  Composition({
    this.id,
    this.title,
    this.is_main,
    this.is_active,
    this.quantity,
    this.attributes,
    this.product,
  });

  factory Composition.fromJson(Map<String, dynamic> json) {
    return Composition(
      id: json["id"],
      title: json["title"] != null ? Name.fromJson(json["title"]) : null,
      is_main: json["is_main"],
      is_active: json["is_active"],
      quantity: json["quantity"],
      attributes:
          json["attributes"] != null
              ? (json["attributes"] as List).map((i) => ProductAttribute.fromJson(i)).toList()
              : null,
      product: json["product"] != null ? Product.fromJson(json["product"]) : null,
    );
  }
  //
}
