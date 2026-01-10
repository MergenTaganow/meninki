part of 'get_my_reels_bloc.dart';

@immutable
sealed class GetMyReelsEvent {}

class GetMyReel extends GetMyReelsEvent {
  final Query? query;
  GetMyReel([this.query]);
}

class MyReelPag extends GetMyReelsEvent {
  final Query? query;
  MyReelPag({this.query});
}
