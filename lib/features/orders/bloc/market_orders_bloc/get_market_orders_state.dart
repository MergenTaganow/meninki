part of 'get_market_orders_bloc.dart';

@immutable
sealed class GetMarketOrdersState {}

class GetMarketOrderInitial extends GetMarketOrdersState {}

class GetMarketOrderLoading extends GetMarketOrdersState {}

class MarketOrderPagLoading extends GetMarketOrdersState {
  final List<OrderProduct> orders;
  MarketOrderPagLoading(this.orders);
}

class GetMarketOrderSuccess extends GetMarketOrdersState {
  final List<OrderProduct> orders;
  final bool canPag;
  GetMarketOrderSuccess(this.orders, this.canPag);
}

class GetMarketOrderFailed extends GetMarketOrdersState {
  final String? message;
  final int? statusCode;
  GetMarketOrderFailed({this.message, this.statusCode});
}