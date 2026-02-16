part of 'get_reels_bloc.dart';

@immutable
sealed class GetReelsEvent {}

class GetReel extends GetReelsEvent {
  final Query? query;
  GetReel([this.query]);
}

class ReelPag extends GetReelsEvent {
  final Query? query;
  ReelPag({this.query});
}

class ClearReels extends GetReelsEvent {}

class UpdateReels extends GetReelsEvent {
  final Reel reel;
  UpdateReels(this.reel);
}
