part of 'category_selecting_cubit.dart';

@immutable
sealed class CategorySelectingState {}

final class CategorySelectingSuccess extends CategorySelectingState {
  final Map<String, List<Category>> selectedMap;
  CategorySelectingSuccess(this.selectedMap);
}
