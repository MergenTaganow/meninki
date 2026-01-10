import 'package:meninki/features/auth/models/user.dart';
import 'package:meninki/features/product/models/product.dart';
import 'package:meninki/features/reels/model/meninki_file.dart';

import '../../province/models/province.dart';
import '../pages/select_location_page.dart';

class Market {
  int id;
  String name;
  MeninkiFile? cover_image;
  String? address;
  LatLng? location;
  String? username;
  String? description;
  String? profile_color;
  int? rate_count;
  int? user_rate_count;
  int? user_favorite_count;
  List<MeninkiFile>? files;
  List<Product>? products;
  Province? province;
  User? user;
  int? product_verified_count;
  int? reel_verified_count;

  Market({
    required this.id,
    required this.name,
    this.cover_image,
    this.address,
    this.location,
    this.username,
    this.description,
    this.profile_color,
    this.rate_count,
    this.user_rate_count,
    this.user_favorite_count,
    this.files,
    this.province,
    this.products,
    this.user,
    this.product_verified_count,
    this.reel_verified_count,
  });

  factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
      id: (json["id"]),
      name: json["name"],
      cover_image: json["cover_image"] != null ? MeninkiFile.fromJson(json["cover_image"]) : null,
      address: json["address"],
      location: json["location"] != null ? LatLng.fromJson(json["location"]) : null,
      username: json["username"],
      description: json["description"],
      profile_color: json["profile_color"],
      rate_count: json["rate_count"],
      user_rate_count: json["user_rate_count"],
      user_favorite_count: json["user_favorite_count"],
      product_verified_count: json["product_verified_count"],
      reel_verified_count: json["reel_verified_count"],
      files:
          json["files"] != null
              ? (json["files"] as List).map((e) => MeninkiFile.fromJson(e)).toList()
              : null,
      products:
          json["products"] != null
              ? (json["products"] as List).map((e) => Product.fromJson(e)).toList()
              : null,
      province: json["province"] != null ? Province.fromJson(json["province"]) : null,
      user: json["user"] != null ? User.fromJson(json["user"]) : null,
    );
  }
  //

  //
}
