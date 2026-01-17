part of 'add_create_cubit.dart';

@immutable
sealed class AddCreateState {}

final class AddCreateInitial extends AddCreateState {}

final class AddCreateLoading extends AddCreateState {}

final class AddCreateFailed extends AddCreateState {
  final Failure failure;
  AddCreateFailed(this.failure);
}

final class AddCreateSuccess extends AddCreateState {
  final Add add;
  AddCreateSuccess(this.add);
}