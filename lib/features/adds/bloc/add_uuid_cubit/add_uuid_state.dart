part of 'add_uuid_cubit.dart';

@immutable
sealed class AddUuidState {}

final class AddUuidInitial extends AddUuidState {}

final class AddUuidLoading extends AddUuidState {}

final class AddUuidFailed extends AddUuidState {
  final Failure failure;
  AddUuidFailed(this.failure);
}

final class AddUuidSuccess extends AddUuidState {
  final Add add;
  AddUuidSuccess(this.add);
}
