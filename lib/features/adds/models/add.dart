import 'package:meninki/features/auth/models/user.dart';
import 'package:meninki/features/categories/models/category.dart';
import 'package:meninki/features/province/models/province.dart';
import 'package:meninki/features/reels/model/meninki_file.dart';

class Add {
  int? id;
  String? title;
  String? description;
  bool? is_active;
  bool? is_verified;
  // String? created_at;
  String? link;
  String? link_type;
  num? price;
  Category? category;
  Province? province;
  User? user;
  MeninkiFile? cover_image;

  Add({
    this.id,
    this.title,
    this.is_active,
    this.is_verified,
    // this.created_at,
    this.link,
    this.link_type,
    this.price,
    this.category,
    this.province,
    this.user,
    this.cover_image,
    this.description,
  });

  factory Add.fromJson(Map<String, dynamic> json) {
    return Add(
      id: (json["id"]),
      title: json["title"],
      is_active: json["is_active"],
      description: json["description"],
      is_verified: json["is_verified"],
      // created_at: json["created_at"],
      link: json["link"],
      link_type: json["link_type"],
      price: (json["price"]),
      category: json["category"] != null ? Category.fromJson(json["category"]) : null,
      province: json["province"] != null ? Province.fromJson(json["province"]) : null,
      user: json["user"] != null ? User.fromJson(json["user"]) : null,
      cover_image: json["cover_image"] != null ? MeninkiFile.fromJson(json["cover_image"]) : null,
    );
  }
  //
}
