part of 'get_products_bloc.dart';

@immutable
sealed class GetProductsState {}

class GetProductInitial extends GetProductsState {}

class GetProductLoading extends GetProductsState {}

class ProductPagLoading extends GetProductsState {
  final List<Product> products;
  ProductPagLoading(this.products);
}

class GetProductSuccess extends GetProductsState {
  final List<Product> products;
  final bool canPag;
  GetProductSuccess(this.products, this.canPag);
}

class GetProductFailed extends GetProductsState {
  final String? message;
  final int? statusCode;
  GetProductFailed({this.message, this.statusCode});
}