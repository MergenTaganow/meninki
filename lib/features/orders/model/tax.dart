import 'package:meninki/features/global/model/name.dart';

class Tax {
  num? tax;
  Name? name;

  Tax({this.tax, this.name});

  factory Tax.fromJson(Map<String, dynamic> json) {
    return Tax(tax: (json["tax"]), name: json["name"] != null ? Name.fromJson(json["name"]) : null);
  }
}
