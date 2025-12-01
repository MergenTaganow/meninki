import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/brand.dart';

part 'brand_selecting_state.dart';

class BrandSelectingCubit extends Cubit<BrandSelectingState> {
  BrandSelectingCubit() : super(BrandSelectingSuccess({}));

  Map<String, List<Brand>> selectedMap = {};

  selectBrand(String key, Brand brand, [bool isSingle = false]) {
    var selectedBrands = selectedMap[key] ?? [];
    var index = selectedBrands.indexWhere((element) => element.id == brand.id);

    if (index != -1) {
      if (isSingle) {
        selectedBrands = [];
      } else {
        selectedBrands.removeAt(index);
      }
    } else {
      if (isSingle) {
        selectedBrands = [brand];
      } else {
        selectedBrands.add(brand);
      }
    }

    selectedMap[key] = selectedBrands;
    emit(BrandSelectingSuccess(selectedMap));
  }

  emptySelections(String key) {
    selectedMap[key]?.clear();
    selectedMap[key] = [];
    emit(BrandSelectingSuccess(selectedMap));
  }

  static String product_creating_brand = 'product_creating_brand';
}
