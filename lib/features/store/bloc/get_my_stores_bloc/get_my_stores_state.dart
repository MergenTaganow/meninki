part of 'get_my_stores_bloc.dart';

@immutable
sealed class GetMyStoresState {}

final class GetMyStoresInitial extends GetMyStoresState {}

final class GetMyStoresLoading extends GetMyStoresState {}

final class GetMyStoresFailed extends GetMyStoresState {
  final Failure fl;
  GetMyStoresFailed(this.fl);
}

final class GetMyStoresSuccess extends GetMyStoresState {
  final List<Market> stores;
  GetMyStoresSuccess(this.stores);
}

final class GetMyStoresPaginating extends GetMyStoresState {}
