part of 'reel_by_id_cubit.dart';

@immutable
sealed class ReelByIdState {}

final class ReelByIdInitial extends ReelByIdState {}

final class ReelByIdLoading extends ReelByIdState {}

final class ReelByIdFailed extends ReelByIdState {
  final Failure failure;
  ReelByIdFailed(this.failure);
}

final class ReelByIdSuccess extends ReelByIdState {
  final Reel reel;
  ReelByIdSuccess(this.reel);
}
