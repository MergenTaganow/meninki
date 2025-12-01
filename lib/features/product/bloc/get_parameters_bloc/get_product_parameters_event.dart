part of 'get_product_parameters_bloc.dart';

@immutable
sealed class GetProductParametersEvent {}

class GetProductParameter extends GetProductParametersEvent {
  final Query? query;
  GetProductParameter([this.query]);
}

class ProductParameterPag extends GetProductParametersEvent {
  final Query? query;
  ProductParameterPag({this.query});
}