part of 'get_product_attributes_bloc.dart';

@immutable
sealed class GetProductAttributesEvent {}

class GetProductAttribute extends GetProductAttributesEvent {
  final Query? query;
  GetProductAttribute([this.query]);
}

class ProductAttributePag extends GetProductAttributesEvent {
  final Query? query;
  ProductAttributePag({this.query});
}