part of 'reels_controllers_bloc.dart';

@immutable
sealed class ReelsControllersState {}

final class ReelsControllersLoading extends ReelsControllersState {
  final Map<int, VideoPlayerController> controllersMap;
  ReelsControllersLoading(this.controllersMap);
}
