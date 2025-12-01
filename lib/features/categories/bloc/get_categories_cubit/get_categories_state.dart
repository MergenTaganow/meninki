part of 'get_categories_cubit.dart';

@immutable
sealed class GetCategoriesState {}

final class GetCategoriesInitial extends GetCategoriesState {}

final class GetCategoriesLoading extends GetCategoriesState {}

final class GetCategoriesFailed extends GetCategoriesState {
  final Failure failure;
  GetCategoriesFailed(this.failure);
}

final class GetCategoriesSuccess extends GetCategoriesState {
  final List<Category> categories;
  GetCategoriesSuccess(this.categories);
}
