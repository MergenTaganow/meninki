import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  if (res.actionId == 'acceptResponsibility') {
    //TODO notif
    // ResponsiblesRemoteDs ds = sl();
    // ds.acceptResponsibiles(uuid: notification.referenceUuid ?? '');
  }
  //

  if (data.containsKey('taskUuid')) {
    // notification.extras?.taskUuid = data['taskUuid'];
    // hshould pay attention here and remove later by implementing another way if add object eelement creates error
    // notification.extras = notification.extras?.copyWith(
    //   taskUuid: data['taskUuid'],
    //   senderName: notification.body?.split(':').first,
    //   commentWriter: data['commentWriter'],
    // );
  }
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
    // Initialization  setting for android
    if (initialized) return;
    final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {
        onNotificationTapped(jsonDecode(payload ?? ''));
      }, //this part of code for specify ios notification buttons //TODO should test
      notificationCategories: [
        DarwinNotificationCategory(
          'demoCategory',
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain(
              'acceptResponsibility',
              'Accept',
              // options: <DarwinNotificationActionOption>{
              //   DarwinNotificationActionOption.foreground,
              // },
            ),
          ],
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
          },
        ),
      ],
    );
    InitializationSettings initializationSettingsAndroid = InitializationSettings(
      android: const AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: initializationSettingsDarwin,
    );

    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _localNotifPlugin.getNotificationAppLaunchDetails();
    final didNotificationLaunchApp =
        notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

    if (didNotificationLaunchApp) {
      var payload = notificationAppLaunchDetails!.notificationResponse;
      onNotificationTapped(jsonDecode(payload?.payload ?? ''), payload: payload);
    } else {
      await _localNotifPlugin.initialize(
        initializationSettingsAndroid,
        onDidReceiveNotificationResponse:
            (payload) => onNotificationTapped(jsonDecode(payload.payload ?? ''), payload: payload),
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );
    }
    await _localNotifPlugin.initialize(
      initializationSettingsAndroid,
      // to handle event when we receive notification
      onDidReceiveNotificationResponse: (details) {
        onNotificationTapped(jsonDecode(details.payload ?? ''), payload: details);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    initialized = true;
  }

  String currentCommUuid = '';

  int id = 1;

  Future<void> display(RemoteMessage message) async {
    log("-----------------------data from notification: ${message.data}");
    // to get active notifications
    List<ActiveNotification> activeNotifs = await _localNotifPlugin.getActiveNotifications();

    log("Active notifs number: ${activeNotifs.length}");

    List<String> list = [];
    String sender = '';
    String body = '';
    List commentBody =
        message.data['body'] != null && message.data['body'] is String
            ? (message.data['body'] as String).split(':')
            : [];

    if (commentBody.length > 1) {
      sender = commentBody.first;
      body = commentBody.last;
    } else if (commentBody.length == 1) {
      body = commentBody.first;
    }

    for (var notif in activeNotifs) {
      if (notif.groupKey == message.data['referenceUuid']) {
        list.addAll((notif.body ?? '').split('\n'));
        _localNotifPlugin.cancel(notif.id ?? 0);
      }
    }

    list.add(body);

    // To display the notification in device
    try {
      id += 1;
      log('THis is notif channel id: $id');
      log(message.data.toString());
      log(message.data.runtimeType.toString());
      InboxStyleInformation? inboxStyleInformation =
          list.length > 1 ? InboxStyleInformation(list, contentTitle: sender) : null;
      NotificationMeninki? notification = NotificationMeninki.fromMap(message.data);

      final extras =
          message.data['extras'] is String
              ? jsonDecode(message.data['extras']) as Map<String, dynamic>
              : message.data['extras'] as Map<String, dynamic>?;

      final isAccepted = extras?['isAccepted'] as bool? ?? false;

      NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'timix23',
          message.data['type'] ?? 'notification',
          priority: Priority.high,
          importance: Importance.max,
          groupKey: message.data['referenceUuid'] ?? id.toString(),
          setAsGroupSummary: true,
          styleInformation: inboxStyleInformation,
          playSound: true,
          // actions:
          //     // If the 'extras' field is a JSON-encoded string, decode it first before processing.
          //     (message.data['type'] == NotifTypes.responsibilityAsExecutor) && !isAccepted
          //         ? [
          //             const AndroidNotificationAction('acceptResponsibility', 'Accept'),
          //           ]
          //         : null,
        ),
        iOS: const DarwinNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      String title = notification.title ?? 'Notification';
      if (sender.isNotEmpty) {
        title = '${notification.title ?? ''}: $sender';
      }
      // NotificationTapCubit notifTap = sl();
      notifTap.onMessage(message.data);

      // to show notification
      if (currentCommUuid != message.data['referenceUuid']) {
        await _localNotifPlugin.show(
          id,
          title,
          list.join('\n'),
          notificationDetails,
          payload: message.data.isNotEmpty ? jsonEncode(message.data) : null,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> clearAllNotif() async => await _localNotifPlugin.cancelAll();

  Future clearOneNotif(String refUuid) async {
    List<ActiveNotification> activeNotifs = await _localNotifPlugin.getActiveNotifications();
    for (var not in activeNotifs) {
      if (not.groupKey == refUuid) {
        _localNotifPlugin.cancel(not.id ?? 0);
      }
    }
  }

  void setCommentUuid(String uuid) => currentCommUuid = uuid;
  void clearCommentUuid() => currentCommUuid = '';

  void onNotificationTapped(Map<String, dynamic> data, {NotificationResponse? payload}) {
    NotificationMeninki? notification = NotificationMeninki.fromMap(data);

    if (data.containsKey('taskUuid')) {
      // notification.extras?.taskUuid = data['taskUuid'];
      // notification.extras = notification.extras?.copyWith(
      //   taskUuid: data['taskUuid'],
      //   senderName: notification.body?.split(':').first,
      //   commentWriter: data['commentWriter'],
      // );
    }
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
      ..badCertificateCallback = (
          X509Certificate cert,
          String host,
          int port,
          ) =>
      true;
  }
}
