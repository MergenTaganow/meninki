part of 'key_filter_cubit.dart';

@immutable
sealed class KeyFilterState {}

final class KeyFilterSuccess extends KeyFilterState {
  final Map<String, String?> selectedMap;
  KeyFilterSuccess(this.selectedMap);
}
