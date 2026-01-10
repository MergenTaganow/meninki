import 'package:meninki/features/auth/models/user.dart';

class Comment {
  int id;
  String comment_text;
  int? like_count;
  int? reply_to_comment_id;
  int? reply_count;
  User? creator;
  List<Comment>? children;

  Comment({
    required this.id,
    required this.comment_text,
    this.like_count,
    this.reply_to_comment_id,
    this.reply_count,
    this.creator,
    this.children,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: (json["id"]),
      comment_text: json["comment_text"],
      like_count: (json["like_count"]),
      reply_to_comment_id: (json["reply_to_comment_id"]),
      reply_count: (json["reply_count"]),
      creator: json["creator"] != null ? User.fromJson(json["creator"]) : null,
      children:
          json["children"] != null
              ? List<Comment>.from(json["children"].map((x) => Comment.fromJson(x)))
              : null,
    );
  }
  //

  Comment copyWith({
    String? comment_text,
    int? like_count,
    User? creator,
    int? reply_to_comment_id,
    int? reply_count,
  }) {
    return Comment(
      id: id,
      comment_text: comment_text ?? this.comment_text,
      like_count: like_count ?? this.like_count,
      creator: creator ?? this.creator,
      reply_to_comment_id: reply_to_comment_id ?? this.reply_to_comment_id,
      reply_count: reply_count ?? this.reply_count,
    );
  }
}
