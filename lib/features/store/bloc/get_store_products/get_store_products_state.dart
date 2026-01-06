part of 'get_store_products_bloc.dart';

@immutable
sealed class GetStoreProductsState {}

final class GetStoreProductsInitial extends GetStoreProductsState {}

final class GetProductStoresLoading extends GetStoreProductsState {}

final class GetProductStoresFailed extends GetStoreProductsState {
  final Failure fl;
  GetProductStoresFailed(this.fl);
}

final class GetProductStoresSuccess extends GetStoreProductsState {
  final List<Market> stores;
  GetProductStoresSuccess(this.stores);
}

final class GetProductStoresPaginating extends GetStoreProductsState {}
