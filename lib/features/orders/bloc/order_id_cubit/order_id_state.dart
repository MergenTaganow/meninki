part of 'order_id_cubit.dart';

@immutable
sealed class OrderIdState {}

final class OrderIdInitial extends OrderIdState {}

final class OrderIdLoading extends OrderIdState {}

final class OrderIdFailed extends OrderIdState {
  final Failure failure;
  OrderIdFailed(this.failure);
}

final class OrderIdSuccess extends OrderIdState {
  final MeninkiOrder order;
  OrderIdSuccess(this.order);
}
