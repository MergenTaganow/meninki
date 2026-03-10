part of 'order_create_cubit.dart';

@immutable
sealed class OrderCreateState {}

final class OrderCreateInitial extends OrderCreateState {}

final class OrderCreateLoading extends OrderCreateState {}

final class OrderCreateFailed extends OrderCreateState {
  final Failure failure;
  OrderCreateFailed({required this.failure});
}

final class OrderCreateSuccess extends OrderCreateState {}
