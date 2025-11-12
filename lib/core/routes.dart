import 'package:flutter/material.dart';
import 'package:meninki/features/auth/pages/login_methods_screen.dart';
import 'package:meninki/features/auth/pages/otp_screen.dart';
import 'package:meninki/features/auth/pages/register_screen.dart';
import 'package:meninki/features/reels/pages/reels_screen.dart';

import '../features/home/pages/home_page.dart';
import '../features/store/pages/store_create_page.dart';

class Routes {
  static final GlobalKey<NavigatorState> mainNavKey = GlobalKey();

  //auth
  static const String loginMethodsScreen = '/login';
  static const String reelScreen = '/reelsScreen';
  static const String otpScreen = '/otpScreen';
  static const String registerScreen = '/registerScreen';

  //home
  static const String homePage = '/homePage';

  //store
  static const String storeCreatePage = '/storeCreatePage';

  static Route? onGenerateRoute(RouteSettings settings) {
    final Map? data = settings.arguments as Map?;
    switch (settings.name) {
      case loginMethodsScreen:
        return MaterialPageRoute(builder: (_) => LoginMethodsScreen());
      case reelScreen:
        return MaterialPageRoute(builder: (_) => ReelPage(reel: data?['reel']));
      case otpScreen:
        return MaterialPageRoute(builder: (_) => OtpScreen(data?['phoneNumber']));
      case registerScreen:
        return MaterialPageRoute(builder: (_) => RegisterScreen(data?['temporaryToken']));
      case homePage:
        return MaterialPageRoute(builder: (_) => HomePage());
      case storeCreatePage:
        return MaterialPageRoute(builder: (_) => StoreCreatePage());
    }

    return null;
  }
}
