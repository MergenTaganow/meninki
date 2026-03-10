part of 'get_regions_bloc.dart';

@immutable
sealed class GetRegionsState {}

class GetRegionInitial extends GetRegionsState {}

class GetRegionLoading extends GetRegionsState {}

class RegionPagLoading extends GetRegionsState {
  final List<Region> regions;
  RegionPagLoading(this.regions);
}

class GetRegionSuccess extends GetRegionsState {
  final List<Region> regions;
  final bool canPag;
  GetRegionSuccess(this.regions, this.canPag);
}

class GetRegionFailed extends GetRegionsState {
  final String? message;
  final int? statusCode;
  GetRegionFailed({this.message, this.statusCode});
}
