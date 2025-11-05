class MeninkiFile {
  int id;
  String name;
  num size;
  String? blurhash;
  String? mimetype;
  List<String>? video_chunks;
  String original_file;

  MeninkiFile({
    required this.id,
    required this.name,
    required this.size,
    this.blurhash,
    this.mimetype,
    this.video_chunks,
    required this.original_file,
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
    );
  }
  //
}
