import 'dart:convert';

import 'package:meninki/features/auth/models/token.dart';

class User {
  Token? token;
  int? id;
  DateTime? created_at;
  String? phonenumber;
  String? username;
  String? first_name;
  String? last_name;
  String? status;
  String? role;
  bool? is_super_user;
  String? temporaryToken;

  User({
    this.token,
    this.id,
    this.created_at,
    this.phonenumber,
    this.username,
    this.first_name,
    this.last_name,
    this.status,
    this.role,
    this.is_super_user,
    this.temporaryToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json["token"] != null ? Token.fromMap(json["token"]) : null,
      id: (json["id"]),
      created_at: json["created_at"] != null ? DateTime.tryParse(json["created_at"]) : null,
      phonenumber:
          (json["phonenumber"] is int)
              ? (json["phonenumber"] as int).toString()
              : json["phonenumber"],
      username: json["username"],
      first_name: json["first_name"],
      last_name: json["last_name"],
      status: json["status"],
      role: json["role"],
      is_super_user: json["is_super_user"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "token": token?.toMap(),
      "id": id,
      "created_at": created_at?.toIso8601String(),
      "phonenumber": phonenumber,
      "username": username,
      "first_name": first_name,
      "last_name": last_name,
      "status": status,
      "role": role,
      "is_super_user": is_super_user,
    };
  }

  User copyWith({
    Token? token,
    int? id,
    DateTime? created_at,
    String? phonenumber,
    String? username,
    String? first_name,
    String? last_name,
    String? status,
    String? role,
    bool? is_super_user,
    String? temporaryToken,
  }) {
    return User(
      token: token ?? this.token,
      id: id ?? this.id,
      created_at: created_at ?? this.created_at,
      phonenumber: phonenumber ?? this.phonenumber,
      username: username ?? this.username,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      status: status ?? this.status,
      role: role ?? this.role,
      is_super_user: is_super_user ?? this.is_super_user,
      temporaryToken: temporaryToken ?? this.temporaryToken,
    );
  }

  String toJson() => jsonEncode(toMap());
}
