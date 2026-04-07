part of 'current_reel_cubit.dart';

@immutable
sealed class CurrentReelState {}

final class CurrentReelSuccess extends CurrentReelState {
  final List<Reel>? reels;
  final String? reelType;
  CurrentReelSuccess(this.reelType, this.reels);
}

final class PaginateReels extends CurrentReelState {
  final String? reelType;
  PaginateReels(this.reelType);
}
