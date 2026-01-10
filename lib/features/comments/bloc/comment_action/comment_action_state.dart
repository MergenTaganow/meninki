part of 'comment_action_cubit.dart';

@immutable
class CommentActionState {
  final Comment? editingComment;
  final MessageActionType? type;
  final List<String> actions;
  final List<String> actionsIcon;

  const CommentActionState({
    required this.editingComment,
    required this.actions,
    required this.actionsIcon,
    this.type,
  });

  CommentActionState copyWith({
    Comment? editingComment,
    List<String>? actions,
    List<String>? actionsIcon,
    MessageActionType? type,
  }) {
    return CommentActionState(
      editingComment: editingComment ?? this.editingComment,
      actions: actions ?? this.actions,
      actionsIcon: actionsIcon ?? this.actionsIcon,
      type: type ?? this.type,
    );
  }

  CommentActionState copyWithh({
    Comment? editingComment,
    List<String>? actions,
    List<String>? actionsIcon,
    MessageActionType? type,
  }) {
    return CommentActionState(
      editingComment: editingComment,
      type: type,
      actions: actions ?? this.actions,
      actionsIcon: actionsIcon ?? this.actionsIcon,
    );
  }
}
