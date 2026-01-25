part of 'get_basket_cubit.dart';

@immutable
sealed class GetBasketState {}

final class GetBasketInitial extends GetBasketState {}

final class GetBasketLoading extends GetBasketState {}

final class GetBasketFailed extends GetBasketState {
  final Failure failure;
  GetBasketFailed(this.failure);
}

final class GetBasketSuccess extends GetBasketState {
  final List<BasketProduct> products;
  GetBasketSuccess(this.products);
}
