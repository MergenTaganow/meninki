part of 'get_product_by_id_cubit.dart';

@immutable
sealed class GetProductByIdState {}

final class GetProductByIdInitial extends GetProductByIdState {}

final class GetProductByIdLoading extends GetProductByIdState {}

final class GetProductByIdFailed extends GetProductByIdState {
  final Failure failure;
  GetProductByIdFailed(this.failure);
}

final class GetProductByIdSuccess extends GetProductByIdState {
  final Product product;
  GetProductByIdSuccess(this.product);
}
