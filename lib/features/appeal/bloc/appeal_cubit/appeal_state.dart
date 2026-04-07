part of 'appeal_cubit.dart';

@immutable
sealed class AppealState {}

final class AppealInitial extends AppealState {}

final class AppealLoading extends AppealState {}

final class AppealFailed extends AppealState {
  final Failure failure;
  AppealFailed(this.failure);
}

final class AppealSuccess extends AppealState {}
