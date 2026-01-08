part of 'province_selecting_cubit.dart';

@immutable
sealed class ProvinceSelectingState {}

final class ProvinceSelectingSuccess extends ProvinceSelectingState {
  final Map<String, List<Province>> selectedMap;
  ProvinceSelectingSuccess(this.selectedMap);
}