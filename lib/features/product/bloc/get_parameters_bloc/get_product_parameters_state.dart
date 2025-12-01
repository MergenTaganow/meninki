part of 'get_product_parameters_bloc.dart';

@immutable
sealed class GetProductParametersState {}

class GetProductParameterInitial extends GetProductParametersState {}

class GetProductParameterLoading extends GetProductParametersState {}

class ProductParameterPagLoading extends GetProductParametersState {
  final List<ProductParameter> productParameters;
  ProductParameterPagLoading(this.productParameters);
}

class GetProductParameterSuccess extends GetProductParametersState {
  final List<ProductParameter> productParameters;
  final bool canPag;
  GetProductParameterSuccess(this.productParameters, this.canPag);
}

class GetProductParameterFailed extends GetProductParametersState {
  final String? message;
  final int? statusCode;
  GetProductParameterFailed({this.message, this.statusCode});
}