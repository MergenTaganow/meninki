import 'package:meninki/features/reels/model/meninki_file.dart';

class Banner {
  int id;
  MeninkiFile? file;
  bool? is_active;
  String? slug;
  String? type;
  String? link_id;
  String? page;
  int? priority;
  String? size_type;
  String? lang;

  Banner({
    required this.id,
    this.file,
    this.is_active,
    this.slug,
    this.type,
    this.link_id,
    this.page,
    this.priority,
    this.size_type,
    this.lang,
  });

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      id: (json["id"]),
      file: json["file"] != null ? MeninkiFile.fromJson(json["file"]) : null,
      is_active: json["is_active"],
      slug: json["slug"],
      type: json["type"],
      link_id: json["link_id"],
      page: json["page"],
      priority: (json["priority"]),
      size_type: json["size_type"],
      lang: json["lang"],
    );
  }
  //
}
