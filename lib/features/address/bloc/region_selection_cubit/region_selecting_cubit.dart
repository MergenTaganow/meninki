import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/region.dart';

part 'region_selecting_state.dart';

class RegionSelectingCubit extends Cubit<RegionSelectingState> {
  RegionSelectingCubit() : super(RegionSelectingSuccess({}));

  Map<String, List<Region>> selectedMap = {};

  void selectRegion({required String key, required Region region, bool singleSelection = false}) {
    var selectedRegions = selectedMap[key] ?? [];

    if (singleSelection) {
      var index = selectedRegions.indexWhere((element) => element.id == region.id);
      if (index != -1) {
        selectedRegions.removeAt(index);
      } else {
        selectedRegions = [region];
      }
    } else {
      var index = selectedRegions.indexWhere((element) => element.id == region.id);
      if (index != -1) {
        selectedRegions.removeAt(index);
      } else {
        selectedRegions.add(region);
      }
    }

    selectedMap[key] = selectedRegions;
    emit(RegionSelectingSuccess(selectedMap));
  }

  void selectList({required String key, required List<Region> regions}) {
    selectedMap[key] = regions;
    emit(RegionSelectingSuccess(selectedMap));
  }

  void emptySelections(String key) {
    selectedMap[key]?.clear();
    selectedMap[key] = [];
    emit(RegionSelectingSuccess(selectedMap));
  }

  // Example keys
  static String address_creating_region = 'address_creating_region';
}
