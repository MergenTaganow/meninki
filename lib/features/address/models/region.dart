import 'package:meninki/features/province/models/province.dart';

import '../../global/model/name.dart';

class Region {
  int? id;
  Name? name;
  String? slug;
  int? province_id;
  num? delivery_cost;
  Province? province;

  Region({this.id, this.name, this.slug, this.province_id, this.delivery_cost, this.province});

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: (json["id"]),
      name: json["name"] != null ? Name.fromJson(json["name"]) : null,
      slug: json["slug"],
      province_id: (json["province_id"]),
      delivery_cost: (json["delivery_cost"]),
      province: json["province"] != null ? Province.fromJson(json["province"]) : null,
    );
  }
  //
}
