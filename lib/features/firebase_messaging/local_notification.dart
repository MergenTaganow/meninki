import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meninki/core/api.dart';
import 'package:meninki/features/firebase_messaging/models/notification_meninki.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/injector.dart';
import '/main.dart';
import 'bloc/notification_tap/notification_tap_cubit.dart';
import 'firebase_mess.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse res) async {
  if (lifecycleEventHandler.isInBackground) {
    log('in background notificationTapBackground');
    HttpOverrides.global = MyHttpOverrides();
    WidgetsFlutterBinding.ensureInitialized();
    await init();
    var path =
        (Platform.isAndroid
                ? await getExternalStorageDirectory()
                : await getApplicationDocumentsDirectory())
            ?.path;
    // Hive.init(path);
    // await Hive.openBox('firebase');
    await init();
    final FirebaseMessagingService firebaseService = sl();
    final LocalNotificationService notification = sl();
    await firebaseService.setupFirebaseMessaging();
    notification.initialize();
  } else {
    log('in foreground  notificationTapBackground');
    try {
      await init();
    } catch (e) {
      log(e.toString());
    }
  }
  var data = (res.payload?.isNotEmpty ?? false) ? jsonDecode(res.payload ?? '') : {};
  NotificationMeninki? notification = NotificationMeninki.fromMap(data);
  Future.delayed(const Duration(seconds: 1), () {
    NotificationTapCubit notifTap = sl();
    notifTap.moveTo(notification: notification);
  });
}

class LocalNotificationService {
  final NotificationTapCubit notifTap;

  LocalNotificationService({required this.notifTap});
  static bool initialized = false;
  final FlutterLocalNotificationsPlugin _localNotifPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    if (initialized) return;

    final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      notificationCategories: [
        DarwinNotificationCategory(
          'demoCategory',
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain('acceptResponsibility', 'Accept'),
          ],
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
          },
        ),
      ],
    );

    final initializationSettings = InitializationSettings(
      android: const AndroidInitializationSettings("@mipmap/launcher_icon"),
      iOS: initializationSettingsDarwin,
    );

    /// Initialize only once
    await _localNotifPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        _handleNotificationResponse(response);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    final details = await _localNotifPlugin.getNotificationAppLaunchDetails();

    if (details?.didNotificationLaunchApp ?? false) {
      final response = details!.notificationResponse;

      if (response?.payload != null) {
        // Delay to ensure navigator ready
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleNotificationResponse(response!);
        });
      }
    }
    initialized = true;
  }

  int id = 1;

  Future<void> display(RemoteMessage message) async {
    print("here is what we get:${message.toMap()}");

    // Handle image if present in notification data
    NotificationMeninki? notification = NotificationMeninki.fromMap(message.data);
    final String? imageUrl = notification.image_url;
    String title = notification.title ?? 'Notification';
    String? localImagePath;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      // Download and cache the image
      localImagePath = await _downloadAndCacheImage(imageUrl);
      print("localImagePath--$localImagePath");
    }

    List<DarwinNotificationAttachment> iosAttachments = [];

    if (localImagePath != null) {
      iosAttachments.add(DarwinNotificationAttachment(localImagePath));
    }

    id += 1;

    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'timix23',
        message.data['type'] ?? 'notification',
        priority: Priority.high,
        importance: Importance.max,
        largeIcon: localImagePath != null ? FilePathAndroidBitmap(localImagePath) : null,
        // styleInformation: DefaultStyleInformation(true, false),
        styleInformation: BigTextStyleInformation(
          notification.description ?? '',
          contentTitle: title,
          htmlFormatBigText: true,
          htmlFormatContentTitle: true,
        ),
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(
        sound: 'default.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        // attachments: iosAttachments,
      ),
    );

    notifTap.onMessage(message.data);

    await _localNotifPlugin.show(
      id,
      title,
      notification.description?.trim().replaceAll('\n', '').replaceAll("  ", ' '),
      notificationDetails,
      payload: message.data.isNotEmpty ? jsonEncode(message.data) : null,
    );
  }

  Future<String?> _downloadAndCacheImage(String url) async {
    try {
      final dir = await getTemporaryDirectory();
      final fileName = Uri.parse(url).pathSegments.last;
      final file = File('${dir.path}/$fileName');

      if (await file.exists()) {
        return file.path;
      }

      final request = await HttpClient().getUrl(Uri.parse(url));
      final response = await request.close();

      final bytes = await consolidateHttpClientResponseBytes(response);

      await file.writeAsBytes(bytes);

      return file.path;
    } catch (e) {
      print("Download error: $e");
      return null;
    }
  }

  void _handleNotificationResponse(NotificationResponse response) {
    print("Notification tapped from: ${response.notificationResponseType}");
    print("Payload: ${response.payload}");
    if (response.payload == null) return;

    final data = jsonDecode(response.payload!);

    onNotificationTapped(data, payload: response);
  }

  void onNotificationTapped(Map<String, dynamic> data, {NotificationResponse? payload}) {
    print("on notification i am getting::${data}");
    NotificationMeninki? notification = NotificationMeninki.fromMap(data);

    Future.delayed(const Duration(seconds: 1), () async {
      NotificationTapCubit notifTap = sl();
      if (payload?.actionId == 'acceptResponsibility') {
        log('action button acceptResponsibility tapped');
        // ResponsiblesRemoteDsImpl ds = sl();
        // ds.acceptResponsibiles(uuid: jsonDecode(payload?.payload ?? '')['referenceUuid']);

        ///TODO notif
        return;
      }
      notifTap.moveTo(notification: notification);
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
