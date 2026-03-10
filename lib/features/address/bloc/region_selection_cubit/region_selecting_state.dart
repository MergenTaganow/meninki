part of 'region_selecting_cubit.dart';

@immutable
sealed class RegionSelectingState {}

class RegionSelectingSuccess extends RegionSelectingState {
  final Map<String, List<Region>> selectedMap;
  RegionSelectingSuccess(this.selectedMap);
}
