import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../firebase_options.dart';
import '../auth/data/employee_local_data_source.dart';
import '/main.dart';
import 'local_notification.dart';

class FirebaseMessagingService {
  final EmployeeLocalDataSource localDs;
  final LocalNotificationService notification;
  // final NotificationCountCubit notifCount;

  FirebaseMessagingService({
    required this.localDs,
    required this.notification,
    // required this.notifCount,
  });

  Future<void> initFirebase() async {
    try {
      // if opts exist in local db, dont need to fetch it
      FirebaseOptions? opts = DefaultFirebaseOptions.currentPlatform;

      await Firebase.initializeApp(options: opts).timeout(const Duration(seconds: 5));
    } catch (e) {}
  }

  Future<String?> getToken() async {
    try {
      print("get token came");
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      String? token = await firebaseMessaging.getToken();

      print("firebase token was $token");
      if (token != null) {
        localDs.saveFirebaseToken = token;
        // await remoteDs.sendDeviceToken(token);
      }
      return token;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static FirebaseOptions converToFirebaseOptions(Map data) {
    return FirebaseOptions(
      apiKey: data['apiKey'],
      appId: data['appId'],
      messagingSenderId: data['messagingSenderId'],
      projectId: data['projectId'],
      storageBucket: data['storageBucket'],
      iosClientId: data['iosClientId'],
      iosBundleId: data['iosBundleId'],
    );
  }

  Future<void> setupFirebaseMessaging() async {
    if (localDs.user == null) {
      return;
    }
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    RemoteMessage? initialMessage = await firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      await Future.delayed(const Duration(milliseconds: 300));
      notification.onNotificationTapped(initialMessage.data);
    }

    firebaseMessaging.onTokenRefresh
        .listen((fcmToken) async {
          print('Firebase token updated:  $fcmToken');

          localDs.saveFirebaseToken = fcmToken;

          // await remoteDs.sendDeviceToken(fcmToken);
        })
        .onError((err) {
          // Error getting token.
        });

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Notification permission granted.');
    } else {
      print('Notification permission not granted.');
    }

    // Handle incoming messages when the app is in the foreground.

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // if (message.data['type'] == NotifTypes.assignmentComment) return;
      // if (message.data.containsKey('referenceUuid')) {
      //   notifCount.addUuid(message.data['referenceUuid']);
      // }
      notification.display(message);
      print("notifcation came");
      print("notifcation came");
    });

    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      notification.onNotificationTapped(event.data);
    });
  }
}

// Method to handle incoming messages when the app is in the background or terminated.
