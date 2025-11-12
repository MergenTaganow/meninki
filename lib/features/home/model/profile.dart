import 'package:meninki/features/home/model/market.dart';

class Profile {
  int id;
  String username;
  String? lang;
  String first_name;
  String last_name;
  int following_count;
  int followers_coun;
  List<Market>? markets;

  Profile({
    required this.id,
    required this.username,
    this.lang,
    required this.first_name,
    required this.last_name,
    required this.following_count,
    required this.followers_coun,
    this.markets,
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
      // markets: (json["markets"] ?? []),
    );
  }
}
