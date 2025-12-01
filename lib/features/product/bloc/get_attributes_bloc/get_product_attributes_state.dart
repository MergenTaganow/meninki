part of 'get_product_attributes_bloc.dart';

@immutable
sealed class GetProductAttributesState {}

class GetProductAttributeInitial extends GetProductAttributesState {}

class GetProductAttributeLoading extends GetProductAttributesState {}

class ProductAttributePagLoading extends GetProductAttributesState {
  final List<ProductAttribute> productAttributes;
  ProductAttributePagLoading(this.productAttributes);
}

class GetProductAttributeSuccess extends GetProductAttributesState {
  final List<ProductAttribute> productAttributes;
  final bool canPag;
  GetProductAttributeSuccess(this.productAttributes, this.canPag);
}

class GetProductAttributeFailed extends GetProductAttributesState {
  final String? message;
  final int? statusCode;
  GetProductAttributeFailed({this.message, this.statusCode});
}