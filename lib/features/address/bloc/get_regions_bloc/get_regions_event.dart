part of 'get_regions_bloc.dart';

@immutable
sealed class GetRegionsEvent {}

class GetRegion extends GetRegionsEvent {
  final Query? query;
  GetRegion([this.query]);
}

class RegionPag extends GetRegionsEvent {
  final Query? query;
  RegionPag({this.query});
}

class ClearRegions extends GetRegionsEvent {}