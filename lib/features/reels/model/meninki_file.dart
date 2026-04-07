import 'dart:io';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class MeninkiFile {
  int id;
  String? name;
  num? size;
  String? blurhash;
  String? mimetype;
  String? original_file;
  int? user_id;
  String? search_column;
  List<String>? playlists;
  String? thumbnail_url;
  String? status;
  ResizedFiles? resizedFiles;

  MeninkiFile({
    required this.id,
    this.name,
    this.size,
    this.blurhash,
    this.mimetype,
    this.original_file,
    this.user_id,
    this.search_column,
    this.thumbnail_url,
    this.resizedFiles,
    this.status,
    this.playlists,
  });

  factory MeninkiFile.fromJson(Map<String, dynamic> json) {
    return MeninkiFile(
      id: (json["id"] ?? 999),
      name: json["name"],
      size: (json["size"]),
      blurhash: json["blurhash"],
      mimetype: json["mimetype"],
      playlists: json['playlists'] != null ? List<String>.from(json['playlists']) : null,
      original_file: json["original_file"],
      user_id: json["user_id"],
      search_column: json["search_column"],
      thumbnail_url: json["thumbnail_url"],
      status: json["status"],
      resizedFiles:
          json['resized_files'] != null ? ResizedFiles.fromJson(json['resized_files']) : null,
    );
  }

  MeninkiFile copyWith({
    String? name,
    num? size,
    String? blurhash,
    String? mimetype,
    List<String>? video_chunks,
    String? original_file,
    int? user_id,
    String? search_column,
    String? thumbnail_url,
    String? status,
    ResizedFiles? resizedFiles,
  }) {
    return MeninkiFile(
      name: name ?? this.name,
      size: size ?? this.size,
      blurhash: blurhash ?? this.blurhash,
      mimetype: mimetype ?? this.mimetype,
      original_file: original_file ?? this.original_file,
      user_id: user_id ?? this.user_id,
      search_column: search_column ?? this.search_column,
      thumbnail_url: thumbnail_url ?? this.thumbnail_url,
      status: status ?? this.status,
      resizedFiles: resizedFiles ?? this.resizedFiles,
      id: id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "size": this.size,
      "blurhash": this.blurhash,
      "mimetype": this.mimetype,
      "original_file": this.original_file,
      "user_id": this.user_id,
      "search_column": this.search_column,
      "playlists": this.playlists,
      "thumbnail_url": this.thumbnail_url,
      "status": this.status,
      "resizedFiles": this.resizedFiles,
    };
  }

  //
}

class ResizedFiles {
  String? large;
  String? medium;
  String? small;

  ResizedFiles({this.large, this.medium, this.small});

  factory ResizedFiles.fromJson(Map<String, dynamic> json) {
    return ResizedFiles(large: json["large"], medium: json["medium"], small: json["small"]);
  }

  Map<String, dynamic> toMap() {
    return {"large": large, "medium": medium, "small": small};
  }

  //
}

bool isVideo(File file) {
  final mimeType = lookupMimeType(file.path);
  return mimeType != null && mimeType.startsWith('video/');
}

Future<Directory> getGalleryDirectory() async {
  late Directory baseDir;

  if (Platform.isAndroid) {
    final dir = await getExternalStorageDirectory();

    if (dir == null) {
      throw Exception("External storage not available");
    }

    final basePath = dir.path.split('Android').first;

    baseDir = Directory(p.join(basePath, 'Download', 'Meninki'));
  } else if (Platform.isIOS) {
    final dir = await getApplicationDocumentsDirectory();
    baseDir = Directory(p.join(dir.path, 'Meninki'));
  } else {
    throw UnsupportedError("Platform not supported");
  }

  if (!await baseDir.exists()) {
    await baseDir.create(recursive: true);
  }

  return baseDir;
}

Future<bool> fileExists(MeninkiFile meninkiFile) async {
  // var isImage =
  //     meninkiFile.name!.endsWith('.jpg') ||
  //     meninkiFile.name!.endsWith('.png') ||
  //     meninkiFile.name!.endsWith('.jpeg');
  final directory = await getGalleryDirectory();
  final file = File('${directory.path}/${meninkiFile.name}');

  if (await file.exists()) {
    return true;
  }

  return false;
}
