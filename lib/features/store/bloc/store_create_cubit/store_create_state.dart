part of 'store_create_cubit.dart';

@immutable
sealed class StoreCreateState {}

final class StoreCreateInitial extends StoreCreateState {}

final class StoreCreateLoading extends StoreCreateState {}

final class StoreCreateFailed extends StoreCreateState {
  final Failure failure;
  StoreCreateFailed(this.failure);
}

final class StoreCreateSuccess extends StoreCreateState {}

final class StoreEditSuccess extends StoreCreateState {}
