import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/features/comments/models/comment.dart';
import 'package:meninki/features/reels/model/reels.dart';
import '../bloc/get_comments_bloc/get_comments_bloc.dart';
import '../widgets/comment_text_field.dart';
import '../widgets/message_card.dart';

class CommentsPage extends StatefulWidget {
  final Reel reel;
  final ScrollController scrollController;

  const CommentsPage({required this.reel, required this.scrollController, super.key});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController commentController = TextEditingController();
  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    context.read<GetCommentsBloc>().add(GetComment(widget.reel.id));
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!widget.scrollController.hasClients) return;

    if (widget.scrollController.position.pixels >=
        widget.scrollController.position.maxScrollExtent - 50) {
      context.read<GetCommentsBloc>().add(CommentPag(widget.reel.id));
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// HEADER
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text('Комментарии', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),

        /// LIST (THIS controls the draggable sheet)
        Expanded(
          child: BlocBuilder<GetCommentsBloc, GetCommentsState>(
            builder: (context, state) {
              if (state is GetCommentsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is GetCommentsFailed) {
                return Center(child: Text(state.message ?? AppLocalizations.of(context)!.error));
              }

              if (state is GetCommentsSuccess) {
                comments = state.comments;
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<GetCommentsBloc>().add(GetComment(widget.reel.id));
                },
                child: ListView.separated(
                  controller: widget.scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(top: index == 0 ? 10 : 0),
                      child: MessageCard(comment: comments[index]),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                ),
              );
            },
          ),
        ),

        /// FIXED INPUT
        CommentTextField(controller: commentController, reelId: widget.reel.id),
      ],
    );
  }
}
