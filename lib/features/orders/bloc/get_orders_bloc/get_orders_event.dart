part of 'get_orders_bloc.dart';

@immutable
sealed class GetOrdersEvent {}

class GetOrder extends GetOrdersEvent {
  final Query? query;
  GetOrder([this.query]);
}

class OrderPag extends GetOrdersEvent {
  final Query? query;
  OrderPag({this.query});
}

class ClearOrders extends GetOrdersEvent {}