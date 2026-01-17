part of 'get_products_bloc.dart';

@immutable
sealed class GetProductsEvent {}

class GetProduct extends GetProductsEvent {
  final Query? query;
  GetProduct([this.query]);
}

class ProductPag extends GetProductsEvent {
  final Query? query;
  ProductPag({this.query});
}

class ClearProducts extends GetProductsEvent {}
