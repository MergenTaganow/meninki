// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

class NotificationMeninki {
  String? uuid;
  String? model;
  String? type;
  String? title;
  String? body;
  String? deliveryFrom;
  String? deliveryTo;
  String? status;
  String? referenceUuid;
  String? sentTime;
  String? createdAt;
  // Employee? sender;
  // NotifExtras? extras;
  List<String?> notifUuids = [];
  List<String?> bodies = [];
  NotificationMeninki({
    this.uuid,
    this.model,
    this.type,
    this.title,
    this.body,
    this.deliveryFrom,
    this.deliveryTo,
    this.status,
    this.referenceUuid,
    this.sentTime,
    this.createdAt,
    // this.sender,
    // this.extras,
    required this.notifUuids,
    required this.bodies,
  });

  NotificationMeninki copyWith({
    String? uuid,
    String? model,
    String? type,
    String? title,
    String? body,
    String? deliveryFrom,
    String? deliveryTo,
    String? status,
    String? referenceUuid,
    String? sentTime,
    String? createdAt,
    // Employee? sender,
    // NotifExtras? extras,
    List<String?>? notifUuids,
    List<String?>? bodies,
  }) {
    return NotificationMeninki(
      uuid: uuid ?? this.uuid,
      model: model ?? this.model,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      deliveryFrom: deliveryFrom ?? this.deliveryFrom,
      deliveryTo: deliveryTo ?? this.deliveryTo,
      status: status ?? this.status,
      referenceUuid: referenceUuid ?? this.referenceUuid,
      sentTime: sentTime ?? this.sentTime,
      createdAt: createdAt ?? this.createdAt,
      // sender: sender ?? this.sender,
      // extras: extras ?? this.extras,
      notifUuids: notifUuids ?? this.notifUuids,
      bodies: bodies ?? this.bodies,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'model': model,
      'type': type,
      'title': title,
      'body': body,
      'deliveryFrom': deliveryFrom,
      'deliveryTo': deliveryTo,
      'status': status,
      'referenceUuid': referenceUuid,
      'sentTime': sentTime,
      'createdAt': createdAt,
      // 'sender': sender?.toMap(),
      // 'extras': extras?.toMap(),
      'notifUuids': notifUuids,
      'bodies': bodies,
    };
  }

  factory NotificationMeninki.fromMap(Map<String, dynamic> map) {
    log(map.toString());
    return NotificationMeninki(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      model: map['model'] != null ? map['model'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      body: map['body'] != null ? map['body'] as String : null,
      deliveryFrom: map['deliveryFrom'] != null ? map['deliveryFrom'] as String : null,
      deliveryTo: map['deliveryTo'] != null ? map['deliveryTo'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      referenceUuid: map['referenceUuid'] != null ? map['referenceUuid'] as String : null,
      sentTime: map['sentTime'] != null ? map['sentTime'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      // sender: map['sender'] != null
      //     ? Employee.fromMap(map['sender'] as Map<String, dynamic>)
      //     : null,
      // extras: map['extras'] != null
      //     ? NotifExtras.fromMap(map['extras'] is String
      //         ? jsonDecode(map['extras'])
      //         : map['extras'])
      //     : null,
      notifUuids: [map['uuid']],
      bodies: [map['body']],
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationMeninki.fromJson(String source) =>
      NotificationMeninki.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationHr(uuid: $uuid, model: $model, type: $type, title: $title, body: $body, deliveryFrom: $deliveryFrom, deliveryTo: $deliveryTo, status: $status, referenceUuid: $referenceUuid, sentTime: $sentTime,  notifUuids: $notifUuids, bodies: $bodies)';
  }

  @override
  bool operator ==(covariant NotificationMeninki other) {
    if (identical(this, other)) return true;

    return other.uuid == uuid &&
        other.model == model &&
        other.type == type &&
        other.title == title &&
        other.body == body &&
        other.deliveryFrom == deliveryFrom &&
        other.deliveryTo == deliveryTo &&
        other.status == status &&
        other.referenceUuid == referenceUuid &&
        other.sentTime == sentTime &&
        // other.sender == sender &&
        // other.extras == extras &&
        listEquals(other.notifUuids, notifUuids) &&
        listEquals(other.bodies, bodies);
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        model.hashCode ^
        type.hashCode ^
        title.hashCode ^
        body.hashCode ^
        deliveryFrom.hashCode ^
        deliveryTo.hashCode ^
        status.hashCode ^
        referenceUuid.hashCode ^
        sentTime.hashCode ^
        // sender.hashCode ^
        // extras.hashCode ^
        notifUuids.hashCode ^
        bodies.hashCode;
  }
}
