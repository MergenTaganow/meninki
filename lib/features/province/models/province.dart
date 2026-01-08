import 'package:meninki/features/global/model/name.dart';

class Province {
  int id;
  num? delivery_cost;
  Name name;

  Province({required this.id, this.delivery_cost, required this.name});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: (json["id"]),
      delivery_cost: (json["delivery_cost"]),
      name: Name.fromJson(json["name"]),
    );
  }
}
