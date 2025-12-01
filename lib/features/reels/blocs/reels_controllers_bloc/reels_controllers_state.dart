part of 'reels_controllers_bloc.dart';

@immutable
sealed class ReelsControllersState {}

final class ReelsControllersLoading extends ReelsControllersState {
  final Map<int, BetterPlayerController> controllersMap;
  ReelsControllersLoading(this.controllersMap);
}
