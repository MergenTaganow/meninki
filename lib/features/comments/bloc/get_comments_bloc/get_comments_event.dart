part of 'get_comments_bloc.dart';

@immutable
sealed class GetCommentsEvent {}

class GetComment extends GetCommentsEvent {
  final int reelId;
  final Query? query;
  GetComment(this.reelId, [this.query]);
}

class CommentPag extends GetCommentsEvent {
  final int reelId;
  final Query? query;
  CommentPag(this.reelId, {this.query});
}

class AddSentComment extends GetCommentsEvent {
  final Comment comment;
  AddSentComment(this.comment);
}
