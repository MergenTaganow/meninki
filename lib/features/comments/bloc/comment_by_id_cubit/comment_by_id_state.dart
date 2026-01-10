part of 'comment_by_id_cubit.dart';

@immutable
sealed class CommentByIdState {}

final class CommentByIdInitial extends CommentByIdState {}

final class CommentByIdLoading extends CommentByIdState {}

final class CommentByIdFailed extends CommentByIdState {
  final Failure failure;
  CommentByIdFailed(this.failure);
}

final class CommentByIdSuccess extends CommentByIdState {
  final Comment comment;
  CommentByIdSuccess(this.comment);
}
