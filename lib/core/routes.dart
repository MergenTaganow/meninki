import 'package:flutter/material.dart';
import 'package:meninki/features/auth/pages/login_methods_screen.dart';
import 'package:meninki/features/auth/pages/otp_screen.dart';
import 'package:meninki/features/auth/pages/register_screen.dart';
import 'package:meninki/features/reels/pages/reels_screen.dart';

import '../features/home/pages/home_page.dart';

class Routes {
  static final GlobalKey<NavigatorState> mainNavKey = GlobalKey();

  //auth
  static const String loginMethodsScreen = '/login';
  static const String reelsScreen = '/reelsScreen';
  static const String otpScreen = '/otpScreen';
  static const String registerScreen = '/registerScreen';

  //home
  static const String homePage = '/homePage';

  static Route? onGenerateRoute(RouteSettings settings) {
    final Map? data = settings.arguments as Map?;
    switch (settings.name) {
      case loginMethodsScreen:
        return MaterialPageRoute(builder: (_) => LoginMethodsScreen());
      case reelsScreen:
        return MaterialPageRoute(builder: (_) => const ReelsScreen());
      case otpScreen:
        return MaterialPageRoute(builder: (_) => OtpScreen(data?['phoneNumber']));
      case registerScreen:
        return MaterialPageRoute(builder: (_) => RegisterScreen(data?['temporaryToken']));
      case homePage:
        return MaterialPageRoute(builder: (_) => HomePage());
    }

    return null;
  }
}
