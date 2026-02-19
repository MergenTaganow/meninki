part of 'notification_tap_cubit.dart';

class NotificationTapState {}

class NotificationTapInitial extends NotificationTapState {}

class NotificationTapLoading extends NotificationTapState {}

class NotificationTapSuccess extends NotificationTapState {
  final NotificationMeninki? notification;
  NotificationTapSuccess({required this.notification});
}

class NotificationOnMessage extends NotificationTapState {
  final Map<String, dynamic> messageData;
  NotificationOnMessage(this.messageData);
}
