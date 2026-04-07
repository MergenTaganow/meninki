import 'package:meninki/features/reels/model/meninki_file.dart';

import '../../store/models/market.dart';

class Profile {
  int id;
  String? username;
  String? lang;
  String? first_name;
  String? last_name;
  String? phonenumber;
  int? following_count;
  int? followers_coun;
  MeninkiFile? cover_image;
  List<Market>? markets;

  Profile({
    required this.id,
    this.username,
    this.lang,
    this.first_name,
    this.last_name,
    this.following_count,
    this.followers_coun,
    this.markets,
    this.cover_image,
    this.phonenumber,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: (json["id"]),
      username: json["username"],
      lang: json["lang"],
      first_name: json["first_name"],
      last_name: json["last_name"],
      following_count: (json["following_count"]),
      followers_coun: (json["followers_coun"]),
      phonenumber: (json["phonenumber"]),
      cover_image: (json["cover_image"] != null ? MeninkiFile.fromJson(json['cover_image']) : null),
      markets:
          json["markets"] != null
              ? (json["markets"] as List).map((e) => Market.fromJson(e)).toList()
              : null,
    );
  }
}
