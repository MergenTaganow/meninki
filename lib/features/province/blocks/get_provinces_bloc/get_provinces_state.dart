part of 'get_provinces_cubit.dart';

@immutable
sealed class GetProvincesState {}

final class GetProvincesInitial extends GetProvincesState {}

final class GetProvincesLoading extends GetProvincesState {}

final class GetProvincesFailed extends GetProvincesState {
  final Failure failure;
  GetProvincesFailed(this.failure);
}

final class GetProvincesSuccess extends GetProvincesState {
  final List<Province> provinces;
  GetProvincesSuccess(this.provinces);
}
