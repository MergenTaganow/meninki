import 'package:bloc/bloc.dart';
import 'package:meninki/features/categories/models/category.dart';
import 'package:meta/meta.dart';

part 'category_selecting_state.dart';

class CategorySelectingCubit extends Cubit<CategorySelectingState> {
  CategorySelectingCubit() : super(CategorySelectingSuccess({}));

  Map<String, List<Category>> selectedMap = {};

  selectCategory(String key, Category category) {
    var selectedDivisions = selectedMap[key] ?? [];
    var index = selectedDivisions.indexWhere((element) => element.id == category.id);
    if (index != -1) {
      selectedDivisions.removeAt(index);
    } else {
      selectedDivisions.add(category);
    }
    selectedMap[key] = selectedDivisions;
    emit.call(CategorySelectingSuccess(selectedMap));
  }

  emptySelections(String key) {
    selectedMap[key]?.clear();
    selectedMap[key] = [];
    emit.call(CategorySelectingSuccess(selectedMap));
  }

  static String product_creating_category = 'product_creating_category';
}
