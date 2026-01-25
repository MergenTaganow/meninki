part of 'get_my_stores_bloc.dart';

@immutable
sealed class GetMyStoresEvent {}

class GetMyStores extends GetMyStoresEvent {
  final String? search;
  GetMyStores({this.search});
}

class PaginateMyStores extends GetMyStoresEvent {
  final String? search;
  PaginateMyStores({this.search});
}
