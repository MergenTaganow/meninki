import 'package:meninki/features/basket/models/basket_product.dart';
import 'package:meninki/features/orders/model/tax.dart';

import '../../global/model/name.dart';

class MeninkiOrder {
  int? id;
  String? first_name;
  String? last_name;
  String? phonenumber;
  String? additional_phonenumber;
  num? total_cost;
  num? delivery_cost;
  String? status;
  DateTime? created_at;
  DateTime? updated_at;
  String? address;
  List<Tax>? taxes;
  Name? region_name;
  num? net_taxes;
  String? additional_notes;
  String? code;
  List<OrderProduct>? items;

  MeninkiOrder({
    this.id,
    this.first_name,
    this.last_name,
    this.phonenumber,
    this.additional_phonenumber,
    this.total_cost,
    this.delivery_cost,
    this.status,
    this.created_at,
    this.updated_at,
    this.address,
    this.taxes,
    this.region_name,
    this.net_taxes,
    this.additional_notes,
    this.code,
    this.items,
  });

  factory MeninkiOrder.fromJson(Map<String, dynamic> json) {
    return MeninkiOrder(
      id: (json["id"]),
      first_name: json["first_name"],
      last_name: json["last_name"],
      phonenumber: json["phonenumber"],
      additional_phonenumber: json["additional_phonenumber"],
      total_cost: (json["total_cost"]),
      delivery_cost: (json["delivery_cost"]),
      status: json["status"],
      created_at:
          json["created_at"] != null
              ? DateTime.fromMillisecondsSinceEpoch(
                json["created_at"] is String ? int.parse(json["created_at"]) : json["created_at"],
              ).toLocal()
              : null,
      updated_at:
          json["updated_at"] != null
              ? DateTime.fromMillisecondsSinceEpoch(int.parse(json["updated_at"])).toLocal()
              : null,
      address: json["address"],
      taxes:
          json['taxes'] != null
              ? (json['taxes'] as List).map((e) => Tax.fromJson(e)).toList()
              : null,
      region_name: Name.fromJson(json["region_name"]),
      net_taxes: (json["net_taxes"]),
      additional_notes: json["additional_notes"],
      code: json["code"],
      items:
          json['order_items'] != null
              ? (json['order_items'] as List).map((e) => OrderProduct.fromJson(e)).toList()
              : null,
    );
  }
  //
}
