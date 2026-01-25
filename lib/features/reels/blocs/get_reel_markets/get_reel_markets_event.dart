part of 'get_reel_markets_bloc.dart';

@immutable
sealed class GetReelMarketsEvent {}

class GetReelMarkets extends GetReelMarketsEvent {
  final String? search;
  GetReelMarkets({this.search});
}

class PaginateReelMarkets extends GetReelMarketsEvent {
  final String? search;
  PaginateReelMarkets({this.search});
}