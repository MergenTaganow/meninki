part of 'send_comment_cubit.dart';

@immutable
sealed class SendCommentState {}

final class SendCommentInitial extends SendCommentState {}

final class SendCommentLoading extends SendCommentState {}

final class SendCommentFailed extends SendCommentState {
  final Failure failure;
  SendCommentFailed(this.failure);
}

final class SendCommentSuccess extends SendCommentState {
  final Comment comment;
  SendCommentSuccess(this.comment);
}
