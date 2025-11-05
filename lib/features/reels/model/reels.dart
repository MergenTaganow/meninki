import 'package:meninki/features/reels/model/meninki_file.dart';

class Reel {
  int id;
  String? title;
  int? user_favorite_count;
  String? link;
  int? link_id;
  String type;
  bool is_active;
  bool is_verified;
  int user_id;
  DateTime? created_at;
  MeninkiFile file;

  Reel({
    required this.id,
    this.title,
    this.user_favorite_count,
    this.link,
    this.link_id,
    required this.type,
    required this.is_active,
    required this.is_verified,
    required this.user_id,
    this.created_at,
    required this.file,
  });

  factory Reel.fromJson(Map<String, dynamic> json) {
    return Reel(
      id: json["id"],
      title: json["title"],
      user_favorite_count: json["user_favorite_count"],
      link: json["link"],
      link_id: json["link_id"],
      type: json["type"],
      is_active: json["is_active"],
      is_verified: json["is_verified"],
      user_id: json["user_id"],
      created_at: DateTime.tryParse(json["created_at"]),
      file: MeninkiFile.fromJson(json["file"]),
    );
  }
}
