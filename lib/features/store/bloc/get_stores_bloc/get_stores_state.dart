part of 'get_stores_bloc.dart';

@immutable
sealed class GetStoresState {}

final class GetStoresInitial extends GetStoresState {}

final class GetStoresLoading extends GetStoresState {}

final class GetStoresFailed extends GetStoresState {
  final Failure fl;
  GetStoresFailed(this.fl);
}

final class GetStoresSuccess extends GetStoresState {
  final List<Market> stores;
  GetStoresSuccess(this.stores);
}

final class GetStoresPaginating extends GetStoresState {}