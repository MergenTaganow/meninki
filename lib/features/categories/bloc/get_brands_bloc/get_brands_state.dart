part of 'get_brands_bloc.dart';

@immutable
sealed class GetBrandsState {}

class GetBrandInitial extends GetBrandsState {}

class GetBrandLoading extends GetBrandsState {}

class BrandPagLoading extends GetBrandsState {
  final List<Brand> brands;
  BrandPagLoading(this.brands);
}

class GetBrandSuccess extends GetBrandsState {
  final List<Brand> brands;
  final bool canPag;
  GetBrandSuccess(this.brands, this.canPag);
}

class GetBrandFailed extends GetBrandsState {
  final String? message;
  final int? statusCode;
  GetBrandFailed({this.message, this.statusCode});
}