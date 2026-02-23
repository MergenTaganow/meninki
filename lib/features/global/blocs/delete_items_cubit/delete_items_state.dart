part of 'delete_items_cubit.dart';

@immutable
sealed class DeleteItemsState {}

final class DeleteItemsInitial extends DeleteItemsState {}

final class DeleteItemsLoading extends DeleteItemsState {}

final class DeleteItemsFailed extends DeleteItemsState {
  final Failure failure;
  DeleteItemsFailed(this.failure);
}

final class DeleteItemsSuccess extends DeleteItemsState {
  final String deletedThing;
  final int deletedId;
  DeleteItemsSuccess({required this.deletedThing, required this.deletedId});
}
