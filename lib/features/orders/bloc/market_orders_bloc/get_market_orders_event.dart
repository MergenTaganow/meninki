part of 'get_market_orders_bloc.dart';

@immutable
sealed class GetMarketOrdersEvent {}

class GetMarketOrder extends GetMarketOrdersEvent {
  final Query? query;
  GetMarketOrder([this.query]);
}

class MarketOrderPag extends GetMarketOrdersEvent {
  final Query? query;
  MarketOrderPag({this.query});
}

class ClearMarketOrders extends GetMarketOrdersEvent {}