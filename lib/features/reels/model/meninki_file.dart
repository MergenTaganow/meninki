class MeninkiFile {
  int id;
  String name;
  num? size;
  String? blurhash;
  String? mimetype;
  List<String>? video_chunks;
  String? original_file;
  int? user_id;
  String? search_column;
  String? video_master_playlist;
  String? thumbnail_url;
  ResizedFiles? resizedFiles;

  MeninkiFile({
    required this.id,
    required this.name,
    this.size,
    this.blurhash,
    this.mimetype,
    this.video_chunks,
     this.original_file,
    this.user_id,
    this.search_column,
    this.video_master_playlist,
    this.thumbnail_url,
    this.resizedFiles,
  });

  factory MeninkiFile.fromJson(Map<String, dynamic> json) {
    return MeninkiFile(
      id: (json["id"]),
      name: json["name"],
      size: (json["size"]),
      blurhash: json["blurhash"],
      mimetype: json["mimetype"],
      video_chunks: json['video_chunks'] != null ? List<String>.from(json['video_chunks']) : null,
      original_file: json["original_file"],
      user_id: json["user_id"],
      search_column: json["search_column"],
      video_master_playlist: json["video_master_playlist"],
      thumbnail_url: json["thumbnail_url"],
      resizedFiles:
          json['resized_files'] != null ? ResizedFiles.fromJson(json['resized_files']) : null,
    );
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
