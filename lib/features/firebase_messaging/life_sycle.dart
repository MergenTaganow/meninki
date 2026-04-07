import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

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

Future<void> callPhone(String? phoneNumber) async {
  if (phoneNumber == null) return;
  if (!phoneNumber.startsWith('+993')) {
    phoneNumber = "+993$phoneNumber";
  }
  final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  } else {
    throw 'Could not launch $phoneNumber';
  }
}
