part of 'reels_controllers_bloc.dart';

@immutable
abstract class ReelsControllersState {
  final Map<int, BetterPlayerController> controllers;
  const ReelsControllersState(this.controllers);
}

class ReelsControllersLoading extends ReelsControllersState {
  const ReelsControllersLoading(super.controllers);
}

class ReelsControllersReady extends ReelsControllersState {
  const ReelsControllersReady(super.controllers);
}
