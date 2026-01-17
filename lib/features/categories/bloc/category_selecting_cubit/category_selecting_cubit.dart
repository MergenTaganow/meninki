import 'package:bloc/bloc.dart';
import 'package:meninki/features/categories/models/category.dart';
import 'package:meta/meta.dart';

part 'category_selecting_state.dart';

class CategorySelectingCubit extends Cubit<CategorySelectingState> {
  CategorySelectingCubit() : super(CategorySelectingSuccess({}));

  Map<String, List<Category>> selectedMap = {};

  selectCategory({required String key, required Category category, bool singleSelection = false}) {
    var selectedDivisions = selectedMap[key] ?? [];
    if (singleSelection) {
      var index = selectedDivisions.indexWhere((element) => element.id == category.id);
      if (index != -1) {
        selectedDivisions.removeAt(index);
      } else {
        selectedDivisions = [category];
      }
    } else {
      var index = selectedDivisions.indexWhere((element) => element.id == category.id);
      if (index != -1) {
        selectedDivisions.removeAt(index);
      } else {
        selectedDivisions.add(category);
      }
    }
    selectedMap[key] = selectedDivisions;
    emit.call(CategorySelectingSuccess(selectedMap));
  }

  selectList({required String key, required List<Category> categories}) {
    selectedMap[key] = categories;
    emit.call(CategorySelectingSuccess(selectedMap));
  }

  emptySelections(String key) {
    selectedMap[key]?.clear();
    selectedMap[key] = [];
    emit.call(CategorySelectingSuccess(selectedMap));
  }

  static String product_creating_category = 'product_creating_category';
  static String product_searching_category = 'product_searching_category';
  static String reels_searching_category = 'reels_searching_category';
  static String add_creating_category = 'add_creating_category';
}
