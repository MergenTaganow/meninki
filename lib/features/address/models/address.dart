import 'package:meninki/features/address/models/region.dart';

class Address {
  int? id;
  String? info;
  int? region_id;
  int? user_id;
  Region? region;

  Address({this.id, this.info, this.region_id, this.user_id, this.region});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: (json["id"]),
      info: json["info"],
      region_id: (json["region_id"]),
      user_id: (json["user_id"]),
      region: (json["region"] != null ? Region.fromJson(json["region"]) : null),
    );
  }
}
