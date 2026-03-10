import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meninki/features/auth/data/auth_remote_data_source.dart';

import '../../firebase_options.dart';
import '../auth/data/employee_local_data_source.dart';
import '/main.dart';
import 'local_notification.dart';

class FirebaseMessagingService {
  final EmployeeLocalDataSource localDs;
  final LocalNotificationService notification;
  final AuthRemoteDataSource dataSource;

  FirebaseMessagingService({
    required this.localDs,
    required this.notification,
    required this.dataSource,
  });

  Future<void> initFirebase() async {
    try {
      // if opts exist in local db, dont need to fetch it
      FirebaseOptions? opts = DefaultFirebaseOptions.currentPlatform;

      await Firebase.initializeApp(options: opts).timeout(const Duration(seconds: 5));

      await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true);
    } catch (e) {}
  }

  Future<String?> getToken() async {
    try {
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      print("after setForegroundNotificationPresentationOptions");
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      String? token = await firebaseMessaging.getToken().timeout(const Duration(seconds: 5));

      print("token was $token");
      if (token != null) {
        localDs.saveFirebaseToken = token;
        await dataSource.sendFirebaseToken();
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
    try {
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

      firebaseMessaging.onTokenRefresh
          .listen((fcmToken) async {
            localDs.saveFirebaseToken = fcmToken;

            await dataSource.sendFirebaseToken();

            // await remoteDs.sendDeviceToken(fcmToken);
          })
          .onError((err) {
            // Error getting token.
          });

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      } else {}

      // Handle incoming messages when the app is in the foreground.

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // if (message.data['type'] == NotifTypes.assignmentComment) return;
        // if (message.data.containsKey('referenceUuid')) {
        //   notifCount.addUuid(message.data['referenceUuid']);
        // }
        print("message came");
        print("message came");
        print(message.toMap());
        notification.display(message);
      });

      FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        notification.onNotificationTapped(event.data);
      });
    } catch (e) {}
  }
}

// Method to handle incoming messages when the app is in the background or terminated.
