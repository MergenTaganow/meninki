import 'package:meninki/features/product/widgets/composition.dart';

class BasketProduct {
  int? id;
  num? quantity;
  Composition? composition;

  BasketProduct({this.id, this.quantity, this.composition});

  factory BasketProduct.fromJson(Map<String, dynamic> json) {
    return BasketProduct(
      id: (json["id"]),
      quantity: (json["quantity"]),
      composition: json["composition"] != null ? Composition.fromJson(json["composition"]) : null,
    );
  }

  BasketProduct copyWith({required num quantity}) {
    return BasketProduct(id: id, quantity: quantity, composition: composition);
  }
}
