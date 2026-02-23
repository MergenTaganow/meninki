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
    } catch (e) {}
  }

  Future<String?> getToken() async {
    try {
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      String? token = await firebaseMessaging.getToken().timeout(const Duration(seconds: 5));

      print("firebase token was $token");
      if (token != null) {
        localDs.saveFirebaseToken = token;
        await dataSource.sendFirebaseToken();
      }
      print("get token finished");
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
      print("setupFirebaseMessaging");
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      print("firebaseMessaging");

      NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
      );

      print("settings");

      RemoteMessage? initialMessage = await firebaseMessaging.getInitialMessage().timeout(
        const Duration(seconds: 5),
      );
      print("getInitialMessage");

      if (initialMessage != null) {
        await Future.delayed(const Duration(milliseconds: 300));
        notification.onNotificationTapped(initialMessage.data);
        print("delayed(const Duration(milliseconds: 300))notification");
      }

      firebaseMessaging.onTokenRefresh
          .listen((fcmToken) async {
            print('Firebase token updated:  $fcmToken');

            localDs.saveFirebaseToken = fcmToken;

            await dataSource.sendFirebaseToken();

            // await remoteDs.sendDeviceToken(fcmToken);
          })
          .onError((err) {
            // Error getting token.
          });

      print("firebaseMessaging.onTokenRefresh");

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

      print("FirebaseMessaging.onMessage");

      FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

      print("FirebaseMessaging.onBackgroundMessage");

      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        notification.onNotificationTapped(event.data);
      });

      print("FirebaseMessaging.onMessageOpenedApp");
    } catch (e) {}
  }
}

// Method to handle incoming messages when the app is in the background or terminated.
