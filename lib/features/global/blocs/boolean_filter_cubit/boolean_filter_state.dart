part of 'boolean_filter_cubit.dart';

@immutable
sealed class BooleanFilterState {
  final Map<String, bool?> map;
  BooleanFilterState(this.map);
}

final class BooleanFilterSuccess extends BooleanFilterState {
  BooleanFilterSuccess(super.map);
}
