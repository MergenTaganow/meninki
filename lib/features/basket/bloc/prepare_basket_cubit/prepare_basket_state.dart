part of 'prepare_basket_cubit.dart';

@immutable
sealed class PrepareBasketState {}

final class PrepareBasketInitial extends PrepareBasketState {}

final class PrepareBasketLoading extends PrepareBasketState {}

final class PrepareBasketFailed extends PrepareBasketState {
  final Failure failure;
  PrepareBasketFailed(this.failure);
}

final class PrepareBasketSuccess extends PrepareBasketState {
  final PreparedBasket preparedBasket;
  PrepareBasketSuccess(this.preparedBasket);
}
