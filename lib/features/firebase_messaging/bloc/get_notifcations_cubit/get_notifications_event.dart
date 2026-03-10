part of 'get_notifications_bloc.dart';

@immutable
sealed class GetNotificationsEvent {}

class GetNotifications extends GetNotificationsEvent {
  final Query? query;
  GetNotifications([this.query]);
}

class NotificationsPag extends GetNotificationsEvent {
  final Query? query;
  NotificationsPag({this.query});
}

class ClearNotifications extends GetNotificationsEvent {}