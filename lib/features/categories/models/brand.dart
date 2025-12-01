import 'package:meninki/features/reels/model/meninki_file.dart';

class Brand {
  int id;
  int priority;
  String name;
  MeninkiFile? file;

  Brand({required this.id, required this.priority, required this.name, this.file});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: (json["id"]),
      priority: (json["priority"]),
      name: json["name"],
      file: json["file"] != null ? MeninkiFile.fromJson(json["file"]) : null,
    );
  }
  //
}
