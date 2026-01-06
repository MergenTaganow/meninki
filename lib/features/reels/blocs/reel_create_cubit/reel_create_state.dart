part of 'reel_create_cubit.dart';

@immutable
sealed class ReelCreateState {}

final class ReelCreateInitial extends ReelCreateState {}

final class ReelCreateLoading extends ReelCreateState {}

final class ReelCreateFailed extends ReelCreateState {
  final Failure failure;
  ReelCreateFailed(this.failure);
}

final class LaterCreateReel extends ReelCreateState {
  final Map<String, dynamic> map;
  LaterCreateReel(this.map);
}

final class ReelCreateSuccess extends ReelCreateState {}
