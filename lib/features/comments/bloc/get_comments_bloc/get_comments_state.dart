part of 'get_comments_bloc.dart';

@immutable
sealed class GetCommentsState {}

class GetCommentsInitial extends GetCommentsState {}

class GetCommentsLoading extends GetCommentsState {}

class CommentPagLoading extends GetCommentsState {
  final List<Comment> comments;
  CommentPagLoading(this.comments);
}

class GetCommentsSuccess extends GetCommentsState {
  final List<Comment> comments;
  final bool canPag;
  GetCommentsSuccess(this.comments, this.canPag);
}

class GetCommentsFailed extends GetCommentsState {
  final String? message;
  final int? statusCode;
  GetCommentsFailed({this.message, this.statusCode});
}