part of 'get_brands_bloc.dart';

@immutable
sealed class GetBrandsEvent {}

class GetBrand extends GetBrandsEvent {
  final Query? query;
  GetBrand([this.query]);
}

class BrandPag extends GetBrandsEvent {
  final Query? query;
  BrandPag({this.query});
}