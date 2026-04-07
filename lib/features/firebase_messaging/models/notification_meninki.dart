import 'dart:convert';
import 'dart:developer';
import 'package:meninki/features/auth/models/user.dart';

class NotificationMeninki {
  String? id;
  String? title;
  String? description;
  bool? is_read;
  String? image_url;
  String? user_id;
  User? user;
  DateTime? createdAt;
  String? type;
  String? entity;
  NotificationMeninki({
    this.id,
    this.user_id,
    this.title,
    this.description,
    this.is_read,
    this.image_url,
    this.user,
    this.createdAt,
    this.type,
    this.entity,
  });

  NotificationMeninki copyWith({
    String? id,
    String? model,
    String? user_id,
    String? title,
    String? body,
    bool? is_read,
    String? image_url,
    String? type,
    String? entity,
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
      type: type ?? this.type,
      entity: entity ?? this.entity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': id,
      'user_id': user_id,
      'title': title,
      'body': description,
      'deliveryFrom': is_read,
      'deliveryTo': image_url,
      'status': user,
      'createdAt': createdAt,
      'type': type,
      'entity': entity,
    };
  }

  factory NotificationMeninki.fromMap(Map<String, dynamic> map) {
    return NotificationMeninki(
      id:
          map['id'] != null
              ? map['id'] is String
                  ? map['id']
                  : map['id'].toString()
              : null,
      user_id:
          map['user_id'] != null
              ? map['user_id'] is String
                  ? map['user_id']
                  : map['user_id'].toString()
              : null,
      title: map['title'] != null ? map['title'] as String : null,
      description:
          (map['body'] ?? map['description']) != null
              ? (map['body'] ?? map['description']) as String
              : null,
      is_read: map['is_read'] != null ? map['is_read'] as bool : null,
      image_url:
          (map['imageUrl'] ?? map['image_url'] ?? map['android']['imageUrl']) != null
              ? (map['imageUrl'] ?? map['image_url'] ?? map['android']['imageUrl']) as String
              : null,
      type:
          (map['type'] ?? map['data']['type']) != null
              ? (map['type'] ?? map['data']['type']) as String
              : null,
      entity:
          (map['entity'] ?? map['data']['entity']) != null
              ? (map['entity'] ?? map['data']['entity']) as String
              : null,
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
