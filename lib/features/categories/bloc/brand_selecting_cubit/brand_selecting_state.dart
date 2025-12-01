part of 'brand_selecting_cubit.dart';

@immutable
sealed class BrandSelectingState {}

final class BrandSelectingSuccess extends BrandSelectingState {
  final Map<String, List<Brand>> selectedMap;
  BrandSelectingSuccess(this.selectedMap);
}