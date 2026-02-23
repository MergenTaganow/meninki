import 'dart:convert';
import 'dart:developer';
import 'package:meninki/features/auth/models/user.dart';

class NotificationMeninki {
  int? id;
  String? title;
  String? description;
  bool? is_read;
  String? image_url;
  int? user_id;
  User? user;
  DateTime? createdAt;
  NotificationMeninki({
    this.id,
    this.user_id,
    this.title,
    this.description,
    this.is_read,
    this.image_url,
    this.user,
    this.createdAt,
    // this.sender,
    // this.extras,
  });

  NotificationMeninki copyWith({
    int? id,
    String? model,
    int? user_id,
    String? title,
    String? body,
    bool? is_read,
    String? image_url,
    User? user,
    DateTime? createdAt,
  }) {
    return NotificationMeninki(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      title: title ?? this.title,
      description: body ?? this.description,
      is_read: is_read ?? this.is_read,
      image_url: image_url ?? this.image_url,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': id,
      'type': user_id,
      'title': title,
      'body': description,
      'deliveryFrom': is_read,
      'deliveryTo': image_url,
      'status': user,
      'createdAt': createdAt,
    };
  }

  factory NotificationMeninki.fromMap(Map<String, dynamic> map) {
    log(map.toString());
    return NotificationMeninki(
      id: map['id'] != null ? map['id'] as int : null,
      user_id: map['type'] != null ? map['type'] as int : null,
      title: map['title'] != null ? map['title'] as String : null,
      description: map['body'] != null ? map['body'] as String : null,
      is_read: map['deliveryFrom'] != null ? map['deliveryFrom'] as bool : null,
      image_url: map['deliveryTo'] != null ? map['deliveryTo'] as String : null,
      user: map['status'] != null ? User.fromJson(map['status']) : null,
      createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationMeninki.fromJson(String source) =>
      NotificationMeninki.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant NotificationMeninki other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user_id == user_id &&
        other.title == title &&
        other.description == description &&
        other.is_read == is_read &&
        other.image_url == image_url &&
        other.user == user;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user_id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        is_read.hashCode ^
        image_url.hashCode ^
        user.hashCode;
  }
}
