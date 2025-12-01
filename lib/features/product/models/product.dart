import 'package:meninki/features/categories/models/brand.dart';
import 'package:meninki/features/categories/models/category.dart';
import 'package:meninki/features/reels/model/meninki_file.dart';
import 'package:meninki/features/store/models/market.dart';

class Product {
  int id;
  String name;
  String description;
  bool? is_active;
  bool? is_verified;
  num? price;
  num? discount;
  Market? market;
  String? created_at;
  int? user_rate_count;
  int? user_favorite_count;
  int? rate_count;
  Brand? brand;
  List<Category>? categories;
  List<MeninkiFile>? product_files;

  Product({
    required this.id,
    required this.name,
    required this.description,
    this.is_active,
    this.is_verified,
    this.price,
    this.discount,
    this.market,
    this.created_at,
    this.user_rate_count,
    this.user_favorite_count,
    this.rate_count,
    this.brand,
    this.categories,
    this.product_files,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json["id"]),
      name: json["name"],
      description: json["description"],
      is_active: json["is_active"],
      is_verified: json["is_verified"],
      price: (json["price"]),
      discount: (json["discount"]),
      market: json["market"] != null ? Market.fromJson(json["market"]) : null,
      created_at: json["created_at"],
      user_rate_count: (json["user_rate_count"]),
      user_favorite_count: (json["user_favorite_count"]),
      rate_count: (json["rate_count"]),
      brand: json["brand"] != null ? Brand.fromJson(json["brand"]) : null,
      categories:
          json["categories"] != null
              ? (json["categories"] as List).map((e) => Category.fromJson(e)).toList()
              : null,
      product_files:
          json["product_files"] != null
              ? (json["product_files"] as List).map((e) => MeninkiFile.fromJson(e)).toList()
              : null,
    );
  }
}
