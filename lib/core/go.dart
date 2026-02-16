import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:meninki/core/routes.dart';

enum TypeRoute {
  main,
  fromDr,
  tasks,
  respons,
  chat,
}

class Go {
  static String? lastRoute;
  static String? currentRoute;
  static Future? to(
    String name, {
    TypeRoute route = TypeRoute.main,
    Object? argument,
    bool all = false,
    bool vibrate = true,
  }) {
    if (vibrate) {
      // HapticFeedback.lightImpact();
    }
    lastRoute = currentRoute;
    currentRoute = name;
    return getNavKeyState(route)?.pushNamed(name, arguments: argument);
  }

  static Future? popGo(
    String name, {
    TypeRoute route = TypeRoute.main,
    Object? argument,
    bool all = false,
  }) {
    // HapticFeedback.mediumImpact();
    lastRoute = currentRoute;
    currentRoute = name;
    return getNavKeyState(route)?.popAndPushNamed(name, arguments: argument);
  }

  static Future too(
    String name, {
    TypeRoute route = TypeRoute.main,
    Object? argument,
    bool all = false,
  }) async {
    // HapticFeedback.mediumImpact();
    log('$name $route $argument');
    lastRoute = currentRoute;
    currentRoute = name;
    getNavKeyState(route)?.pushNamedAndRemoveUntil(name, arguments: argument, (route) => false);
  }

  static popUntil({TypeRoute route = TypeRoute.main}) {
    if (getNavKeyState(route)?.canPop() ?? false) {
      getNavKeyState(route)?.popUntil((route) => route.isFirst);
    }
    currentRoute = null;
    lastRoute = null;
  }

  static pop({TypeRoute route = TypeRoute.main}) {
    if (getNavKeyState(route)?.canPop() ?? false) {
      getNavKeyState(route)?.pop();
    }
    currentRoute = lastRoute;
    lastRoute = null;
  }

  static NavigatorState? getNavKeyState(TypeRoute type) {
    return Routes.mainNavKey.currentState;
  }

  static emptyCurrent() {
    currentRoute = null;
    lastRoute = null;
  }
}
