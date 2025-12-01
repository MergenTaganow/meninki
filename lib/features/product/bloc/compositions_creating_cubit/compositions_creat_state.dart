part of 'compositions_creat_cubit.dart';

@immutable
sealed class CompositionsCreatState {}

final class CompositionsCreatInitial extends CompositionsCreatState {}

final class CompositionsCreating extends CompositionsCreatState {
  final Map<ProductParameter, List<ProductAttribute>> selectedParameters;
  CompositionsCreating(this.selectedParameters);
}
