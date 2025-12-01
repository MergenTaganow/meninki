part of 'get_stores_bloc.dart';

@immutable
sealed class GetStoresEvent {}

class GetStores extends GetStoresEvent {
  final String? search;
  GetStores({this.search});
}

class PaginateStores extends GetStoresEvent {
  final String? search;
  PaginateStores({this.search});
}
