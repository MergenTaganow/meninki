part of 'product_favorites_cubit.dart';

@immutable
sealed class ProductFavoritesState {}

final class ProductFavoritesInitial extends ProductFavoritesState {}

final class ProductFavoritesLoading extends ProductFavoritesState {}

final class ProductFavoritesFailed extends ProductFavoritesState {
  final Failure failure;
  ProductFavoritesFailed(this.failure);
}

final class ProductFavoritesSuccess extends ProductFavoritesState {
  final List<int> productIds;
  ProductFavoritesSuccess(this.productIds);
}
