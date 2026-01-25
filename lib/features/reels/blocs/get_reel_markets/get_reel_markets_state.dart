part of 'get_reel_markets_bloc.dart';

@immutable
sealed class GetReelMarketsState {}

final class GetReelMarketsInitial extends GetReelMarketsState {}

final class GetReelMarketsLoading extends GetReelMarketsState {}

final class GetReelMarketsFailed extends GetReelMarketsState {
  final Failure fl;
  GetReelMarketsFailed(this.fl);
}

final class GetReelMarketsSuccess extends GetReelMarketsState {
  final List<ReelMarket> reelMarkets;
  GetReelMarketsSuccess(this.reelMarkets);
}

final class GetReelMarketsPaginating extends GetReelMarketsState {}