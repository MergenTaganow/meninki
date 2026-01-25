part of 'reel_playing_queue_cubit.dart';

@immutable
sealed class ReelPlayingQueueState {}

class ReelPlaying extends ReelPlayingQueueState {
  final int? currentPlayingId;
  ReelPlaying({this.currentPlayingId});
}
