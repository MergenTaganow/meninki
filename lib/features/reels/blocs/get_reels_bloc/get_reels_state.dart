part of 'get_reels_bloc.dart';

@immutable
sealed class GetReelsState {}

class GetReelInitial extends GetReelsState {}

class GetReelLoading extends GetReelsState {}

class ReelPagLoading extends GetReelsState {
  final List<Reel> reels;
  ReelPagLoading(this.reels);
}

class GetReelSuccess extends GetReelsState {
  final List<Reel> reels;
  final bool canPag;
  GetReelSuccess(this.reels, this.canPag);
}

class GetReelFailed extends GetReelsState {
  final String? message;
  final int? statusCode;
  GetReelFailed({this.message, this.statusCode});
}
