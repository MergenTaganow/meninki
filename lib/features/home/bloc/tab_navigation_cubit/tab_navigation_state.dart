part of 'tab_navigation_cubit.dart';

@immutable
sealed class TabNavigationState {}

final class TabNavigationInitial extends TabNavigationState {}

final class NavigateTab extends TabNavigationState {
  final TabPages page;
  final int index;
  NavigateTab({required this.page, required this.index});
}
