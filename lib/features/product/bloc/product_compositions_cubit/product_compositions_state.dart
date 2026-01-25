part of 'product_compositions_cubit.dart';

@immutable
sealed class ProductCompositionsState {}

final class ProductCompositionsLoading extends ProductCompositionsState {}

final class ProductCompositionsSuccess extends ProductCompositionsState {
  final Map<ProductParameter, List<ProductAttribute>> allAttributes;
  final Map<ProductParameter, ProductAttribute> selected;

  ProductCompositionsSuccess({required this.allAttributes, required this.selected});
}
