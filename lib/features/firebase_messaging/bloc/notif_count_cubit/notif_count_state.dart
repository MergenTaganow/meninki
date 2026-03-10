part of 'notif_count_cubit.dart';

@immutable
sealed class NotifCountState {}

final class NotifCountInitial extends NotifCountState {}

final class NotifCountLoading extends NotifCountState {}

final class NotifCountFailed extends NotifCountState {
  final Failure failure;
  NotifCountFailed(this.failure);
}

final class NotifCountSuccess extends NotifCountState {
  final int count;
  NotifCountSuccess(this.count);
}
