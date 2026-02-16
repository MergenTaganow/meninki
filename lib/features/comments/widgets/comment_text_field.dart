import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/features/comments/bloc/comment_action/comment_action_cubit.dart';
import 'package:meninki/features/comments/bloc/send_comment_cubit/send_comment_cubit.dart';

import '../../../core/colors.dart';
import '../../../core/helpers.dart';

class CommentTextField extends StatelessWidget {
  const CommentTextField({super.key, required this.controller, required this.reelId});

  final TextEditingController controller;
  final int reelId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentActionCubit, CommentActionState>(
      builder: (context, actionstate) {
        return Container(
          // height: 110,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
          padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //comment editing field
              if (actionstate.editingComment != null)
                IntrinsicHeight(
                  child: Container(
                    // height: 40,
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F3F3),
                      borderRadius: BorderRadius.circular(14),
                      border: Border(left: BorderSide(color: Col.primBlue, width: 5)),
                    ),
                    margin: EdgeInsets.only(bottom: 10),
                    // padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        //editing text initial
                        Expanded(
                          child: Padd(
                            left: 12,
                            top: 6,
                            bot: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (actionstate.type == MessageActionType.edit
                                      ? 'Kementariýany üy1tget'
                                      : 'Jogap ber'),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(color: Col.primBlue),
                                ),
                                Text(
                                  actionstate.editingComment!.comment_text,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(fontSize: 14),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                        //closing button
                        Padd(
                          left: 8,
                          child: IconButton(
                            onPressed: () {
                              context.read<CommentActionCubit>().resetEditingComment();
                              controller.clear();
                            },
                            icon: Icon(Icons.highlight_remove),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TexField(
                      ctx: context,
                      cont: controller,
                      filCol: Color(0xFFF3F3F3),
                      hint: AppLocalizations.of(context)!.yourComment,
                      hintCol: Color(0xFF969696),
                      borderRadius: 14,
                      horPad: 12,
                      verPad: 12,
                    ),
                  ),
                  Box(w: 12),
                  BlocBuilder<SendCommentCubit, SendCommentState>(
                    builder: (context, state) {
                      return InkWell(
                        onTap: () {
                          if (state is! SendCommentLoading && controller.text.trim().isNotEmpty) {
                            context.read<SendCommentCubit>().sendComment({
                              "reel_id": reelId,
                              "comment_text": controller.text.trim(),
                              if (actionstate.editingComment != null &&
                                  actionstate.type == MessageActionType.reply)
                                "reply_to_comment_id": actionstate.editingComment?.id,
                            });
                          }
                        },
                        child: Container(
                          height: 46,
                          width: 46,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Col.primary,
                          ),
                          child: Center(
                            child:
                                state is SendCommentLoading
                                    ? Padd(
                                      pad: 12,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : Svvg.asset('comment_send'),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
