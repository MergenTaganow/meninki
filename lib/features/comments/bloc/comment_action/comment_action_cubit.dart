import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/features/comments/models/comment.dart';

part 'comment_action_state.dart';

enum MessageActionType { edit, reply }

class CommentActionCubit extends Cubit<CommentActionState> {
  CommentActionCubit()
      : super(const CommentActionState(
          editingComment: null,
          actions: ['reply', 'copy', 'edit', 'delete'],
          actionsIcon: ['reply', 'Copy', 'edit', '_delete'],
        ));
  // final QuillController commentContr = QuillController.basic();

  void setEditingComment(Comment? comment, MessageActionType type) {
    emit(state.copyWith(editingComment: comment, type: type));
  }

  void setActions(List<String> actions, List<String> actionsIcon) {
    emit(state.copyWith(actions: actions, actionsIcon: actionsIcon));
  }

  void resetEditingComment() {
    emit(state.copyWithh(editingComment: null, type: null));
  }
}
