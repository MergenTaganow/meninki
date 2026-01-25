import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/features/auth/data/employee_local_data_source.dart';
import 'package:meninki/features/comments/bloc/comment_action/comment_action_cubit.dart';
import 'package:meninki/features/comments/models/comment.dart';

import '../../../core/colors.dart';
import '../../../core/helpers.dart';
import '../../../core/injector.dart';
import '../bloc/comment_by_id_cubit/comment_by_id_cubit.dart';

class MessageCard extends StatefulWidget {
  final Comment comment;

  const MessageCard({required this.comment, super.key});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  bool showChildren = false;

  @override
  Widget build(BuildContext context) {
    var me = sl<EmployeeLocalDataSource>().user;

    return Container(
      decoration: BoxDecoration(color: Color(0xFFF3F3F3), borderRadius: BorderRadius.circular(14)),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 10, backgroundColor: Color(0xFF474747)),
                  Box(w: 6),
                  Text(
                    widget.comment.creator?.username ?? '',
                    style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF474747)),
                  ),
                ],
              ),
              if (me?.id == widget.comment.creator?.id)
                Text(
                  AppLocalizations.of(context)!.yourComment,
                  style: TextStyle(color: Col.primary, fontWeight: FontWeight.w500),
                )
              else
                InkWell(
                  onTap: () {
                    context.read<CommentActionCubit>().setEditingComment(
                      widget.comment,
                      MessageActionType.reply,
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.reply,
                        style: TextStyle(fontWeight: FontWeight.w500, color: Col.primary),
                      ),
                      Box(w: 6),
                      Svvg.asset('reply', size: 16),
                    ],
                  ),
                ),
            ],
          ),
          Box(h: 6),
          Text(widget.comment.comment_text, style: TextStyle(fontSize: 16)),
          if ((widget.comment.reply_count ?? 0) > 0)
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Box(h: 4),
                InkWell(
                  onTap: () {
                    showChildren = !showChildren;
                    if (showChildren) {
                      context.read<CommentByIdCubit>().getComment(widget.comment.id);
                    }
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      SizedBox(width: 20, child: Divider()),
                      Box(w: 2),
                      Text(
                        "${showChildren ? AppLocalizations.of(context)!.hide : AppLocalizations.of(context)!.view} ${widget.comment.reply_count} ${AppLocalizations.of(context)!.answers}",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          if (showChildren)
            BlocBuilder<CommentByIdCubit, CommentByIdState>(
              builder: (context, state) {
                if (state is CommentByIdLoading) {
                  return Center(
                    child: SizedBox(
                      height: 10,
                      width: 10,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }
                return Container();
              },
            ),
          if (showChildren)
            BlocBuilder<CommentByIdCubit, CommentByIdState>(
              builder: (context, state) {
                if (state is CommentByIdSuccess) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.25,
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      // physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Svvg.asset('reply'),
                              Box(w: 14),
                              Expanded(
                                child: Text(
                                  state.comment.children?[index].comment_text ?? '',
                                  style: TextStyle(color: Col.primary),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Box(h: 4),
                      itemCount: state.comment.children?.length ?? 0,
                    ),
                  );
                }
                return Container();
              },
            ),
        ],
      ),
    );
  }
}
