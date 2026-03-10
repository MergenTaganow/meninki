import 'package:flutter/material.dart';
import 'package:meninki/features/firebase_messaging/models/notification_meninki.dart';

import '../../core/go.dart';
import '../../core/routes.dart';

class NotifHelper {
  static void onTap({required BuildContext context, required NotificationMeninki? notif}) {
    print(notif?.type);

    String id = notif?.id ?? '';

    if (id.isEmpty) return;

    switch (notif?.type) {
      // 1
      case NotifTypes.product_approved:
        Go.to(Routes.myProductDetailPage, argument: {'productId': int.tryParse(id)});
        break;

      default:
    }
  }
}

class NotifTypes {
  static const String product_approved = "product_approved";
}
