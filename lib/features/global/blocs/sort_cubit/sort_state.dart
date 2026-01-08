part of 'sort_cubit.dart';

@immutable
sealed class SortState {}

final class SortSuccess extends SortState {
  final Map<String, Sort?>? sort;
  SortSuccess(this.sort);
}
