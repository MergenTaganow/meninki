part of 'market_favorites_cubit.dart';

@immutable
sealed class MarketFavoritesState {}

final class MarketFavoritesInitial extends MarketFavoritesState {}

final class MarketFavoritesLoading extends MarketFavoritesState {}

final class MarketFavoritesFailed extends MarketFavoritesState {
  final Failure failure;
  MarketFavoritesFailed(this.failure);
}

final class MarketFavoritesSuccess extends MarketFavoritesState {
  final List<int> marketIds;
  MarketFavoritesSuccess(this.marketIds);
}
