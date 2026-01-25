part of 'add_favorite_cubit.dart';

@immutable
sealed class AddFavoriteState {}

final class AddFavoriteInitial extends AddFavoriteState {}

final class AddFavoritesLoading extends AddFavoriteState {}

final class AddFavoritesFailed extends AddFavoriteState {
  final Failure failure;
  AddFavoritesFailed(this.failure);
}

final class AddFavoritesSuccess extends AddFavoriteState {
  final List<int> addIds;
  AddFavoritesSuccess(this.addIds);
}
