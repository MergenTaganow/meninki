part of 'get_notifications_bloc.dart';

@immutable
sealed class GetNotificationsState {}

class GetNotificationsInitial extends GetNotificationsState {}

class GetNotificationsLoading extends GetNotificationsState {}

class NotificationsPagLoading extends GetNotificationsState {
  final List<NotificationMeninki> notifications;
  NotificationsPagLoading(this.notifications);
}

class GetNotificationsSuccess extends GetNotificationsState {
  final List<NotificationMeninki> notifications;
  final bool canPag;

  GetNotificationsSuccess(this.notifications, this.canPag);
}

class GetNotificationsFailed extends GetNotificationsState {
  final String? message;
  final int? statusCode;

  GetNotificationsFailed({this.message, this.statusCode});
}
