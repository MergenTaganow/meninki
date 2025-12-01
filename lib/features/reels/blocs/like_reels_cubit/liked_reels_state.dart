part of 'liked_reels_cubit.dart';

@immutable
sealed class LikedReelsState {}

final class LikedReelsSuccess extends LikedReelsState {
  final List<int> reelIds;
  LikedReelsSuccess(this.reelIds);
}
