import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/province.dart';

part 'province_selecting_state.dart';

class ProvinceSelectingCubit extends Cubit<ProvinceSelectingState> {
  ProvinceSelectingCubit() : super(ProvinceSelectingSuccess({}));

  Map<String, List<Province>> selectedMap = {};

  void selectProvince({
    required String key,
    required Province province,
    bool singleSelection = false,
  }) {
    var selectedProvinces = selectedMap[key] ?? [];

    if (singleSelection) {
      var index = selectedProvinces.indexWhere((element) => element.id == province.id);
      if (index != -1) {
        selectedProvinces.removeAt(index);
      } else {
        selectedProvinces = [province];
      }
    } else {
      var index = selectedProvinces.indexWhere((element) => element.id == province.id);
      if (index != -1) {
        selectedProvinces.removeAt(index);
      } else {
        selectedProvinces.add(province);
      }
    }

    selectedMap[key] = selectedProvinces;
    emit(ProvinceSelectingSuccess(selectedMap));
  }

  selectList({required String key, required List<Province> provinces}) {
    selectedMap[key] = provinces;
    emit(ProvinceSelectingSuccess(selectedMap));
  }

  void emptySelections(String key) {
    selectedMap[key]?.clear();
    selectedMap[key] = [];
    emit(ProvinceSelectingSuccess(selectedMap));
  }

  // Example keys
  static String product_creating_province = 'product_creating_province';
  static String store_creating_province = 'store_creating_province';
  static String product_searching_province = 'product_searching_province';
  static String add_creating_province = 'add_creating_province';
}
