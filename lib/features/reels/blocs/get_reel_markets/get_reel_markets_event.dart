part of 'get_reel_markets_bloc.dart';

@immutable
sealed class GetReelMarketsEvent {}

class GetReelMarkets extends GetReelMarketsEvent {
  final String? search;
  final String type;
  GetReelMarkets({this.search, required this.type});
}

class PaginateReelMarkets extends GetReelMarketsEvent {
  final String? search;
  final String type;
  PaginateReelMarkets({this.search, required this.type});
}
