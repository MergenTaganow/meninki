import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/features/auth/data/employee_local_data_source.dart';
import 'package:meninki/features/comments/models/comment.dart';
import 'package:meninki/features/reels/model/reels.dart';
import '../../../core/injector.dart';
import '../bloc/get_comments_bloc/get_comments_bloc.dart';
import '../bloc/send_comment_cubit/send_comment_cubit.dart';
import '../widgets/comment_text_field.dart';
import '../widgets/message_card.dart';

class CommentsPage extends StatefulWidget {
  final Reel reel;

  const CommentsPage({required this.reel, super.key});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  TextEditingController commentController = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<Comment> comments = [];

  @override
  void initState() {
    context.read<GetCommentsBloc>().add(GetComment(widget.reel.id));
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        context.read<GetCommentsBloc>().add(CommentPag(widget.reel.id));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var me = sl<EmployeeLocalDataSource>().user;
    return BlocListener<SendCommentCubit, SendCommentState>(
      listener: (context, state) {
        if (state is SendCommentSuccess) {
          commentController.clear();
          if (state.comment.reply_to_comment_id == null) {
            context.read<GetCommentsBloc>().add(
              AddSentComment(state.comment.copyWith(creator: me)),
            );
          } else {
            var index = comments.indexWhere((e) => e.id == state.comment.reply_to_comment_id);
            if (index != -1) {
              comments[index] = comments[index].copyWith(
                reply_count: (comments[index].reply_count ?? 0) + 1,
              );
            }
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Комментарии")),
        body: Column(
          children: [
            Expanded(
              child: Padd(
                hor: 10,
                child: BlocBuilder<GetCommentsBloc, GetCommentsState>(
                  builder: (context, state) {
                    if (state is GetCommentsLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is GetCommentsFailed) {
                      return Center(child: Text(state.message ?? 'error'));
                    }
                    if (state is GetCommentsSuccess) {
                      comments = state.comments;
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<GetCommentsBloc>().add(GetComment(widget.reel.id));
                      },
                      child: ListView.separated(
                        controller: scrollController,
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          return Padd(
                            top: index == 0 ? 10 : 0,
                            child: MessageCard(comment: comments[index]),
                          );
                        },
                        separatorBuilder: (context, index) => Box(h: 10),
                      ),
                    );
                  },
                ),
              ),
            ),
            CommentTextField(controller: commentController, reelId: widget.reel.id),
          ],
        ),
      ),
    );
  }
}
