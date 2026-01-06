part of 'get_store_products_bloc.dart';

@immutable
sealed class GetStoreProductsEvent {}

class GetProductStores extends GetStoreProductsEvent {
  final String? search;
  GetProductStores({this.search});
}

class PaginateProductStores extends GetStoreProductsEvent {
  final String? search;
  PaginateProductStores({this.search});
}
