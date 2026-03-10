import 'package:meninki/features/orders/model/order.dart';
import 'package:meninki/features/product/widgets/composition.dart';
import 'package:meninki/features/reels/model/meninki_file.dart';
import 'package:meninki/features/store/models/market.dart';

import '../../global/model/name.dart';

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

class OrderProduct {
  int? id;
  num? price;
  Name? title;
  Market? market;
  String? status;
  int? quantity;
  int? product_id;
  int? compoisition_id;
  MeninkiOrder? order;
  MeninkiFile? file;

  OrderProduct({
    this.id,
    this.price,
    this.title,
    this.market,
    this.status,
    this.quantity,
    this.product_id,
    this.compoisition_id,
    this.file,
    this.order,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      id: (json["id"]),
      price: (json["price"]),
      title: json["title"] != null ? Name.fromJson(json["title"]) : null,
      market: json["market"] != null ? Market.fromJson(json["market"]) : null,
      status: json["status"],
      quantity: (json["quantity"]),
      product_id: (json["product_id"]),
      compoisition_id: (json["compoisition_id"]),
      file: json["file"] != null ? MeninkiFile.fromJson(json["file"]) : null,
      order: json["order"] != null ? MeninkiOrder.fromJson(json["order"]) : null,
    );
  }
  //
}
