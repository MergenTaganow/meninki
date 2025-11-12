part of 'current_reel_cubit.dart';

@immutable
sealed class CurrentReelState {}

final class CurrentReelSuccess extends CurrentReelState {
  final Reel? reel;
  CurrentReelSuccess(this.reel);
}
