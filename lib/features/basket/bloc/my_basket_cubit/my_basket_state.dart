part of 'my_basket_cubit.dart';

@immutable
sealed class MyBasketState {}

final class MyBasketInitial extends MyBasketState {}

final class MyBasketLoading extends MyBasketState {
  final int loadingId;
  final String loadingAction;
  MyBasketLoading({required this.loadingId, required this.loadingAction});
}

final class MyBasketFailed extends MyBasketState {
  final Failure failure;
  MyBasketFailed(this.failure);
}

final class MyBasketSuccess extends MyBasketState {
  final List<int> compositionIds;
  MyBasketSuccess(this.compositionIds);
}

final class ProductAdded extends MyBasketState {}

final class ProductRemoved extends MyBasketState {}
