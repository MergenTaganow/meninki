part of 'get_my_reels_bloc.dart';

@immutable
sealed class GetMyReelsState {}

class GetMyReelInitial extends GetMyReelsState {}

class GetMyReelLoading extends GetMyReelsState {}

class MyReelPagLoading extends GetMyReelsState {
  final List<Reel> reels;
  MyReelPagLoading(this.reels);
}

class GetMyReelSuccess extends GetMyReelsState {
  final List<Reel> reels;
  final bool canPag;
  GetMyReelSuccess(this.reels, this.canPag);
}

class GetMyReelFailed extends GetMyReelsState {
  final String? message;
  final int? statusCode;
  GetMyReelFailed({this.message, this.statusCode});
}
