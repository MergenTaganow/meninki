part of 'product_create_cubit.dart';

@immutable
sealed class ProductCreateState {}

final class ProductCreateInitial extends ProductCreateState {}

final class ProductCreateLoading extends ProductCreateState {}

final class ProductCreateFailed extends ProductCreateState {
  final Failure failure;
  ProductCreateFailed(this.failure);
}

final class ProductCreateSuccess extends ProductCreateState {
  final Product product;
  ProductCreateSuccess(this.product);
}
