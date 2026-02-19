part of 'reels_controllers_bloc.dart';

@immutable
sealed class ReelsControllersEvent {}

class NewReels extends ReelsControllersEvent {
  final List<Reel> reels;
  NewReels(this.reels);
}

class PauseAllReels extends ReelsControllersEvent {}

class PlayAllReels extends ReelsControllersEvent {}

class CloseAllControllers extends ReelsControllersEvent {
  CloseAllControllers();
}
