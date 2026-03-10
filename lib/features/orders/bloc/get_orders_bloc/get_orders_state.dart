part of 'get_orders_bloc.dart';

@immutable
sealed class GetOrdersState {}

class GetOrderInitial extends GetOrdersState {}

class GetOrderLoading extends GetOrdersState {}

class OrderPagLoading extends GetOrdersState {
  final List<MeninkiOrder> orders;
  OrderPagLoading(this.orders);
}

class GetOrderSuccess extends GetOrdersState {
  final List<MeninkiOrder> orders;
  final bool canPag;
  GetOrderSuccess(this.orders, this.canPag);
}

class GetOrderFailed extends GetOrdersState {
  final String? message;
  final int? statusCode;
  GetOrderFailed({this.message, this.statusCode});
}
