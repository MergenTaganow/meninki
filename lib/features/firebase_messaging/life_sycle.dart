import 'package:flutter/widgets.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  bool _isInBackground = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        _isInBackground = false;
        break;
      case AppLifecycleState.paused:
        _isInBackground = true;
        break;
      default:
    }
  }

  bool get isInBackground => _isInBackground;
}
