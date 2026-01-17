import 'package:bloc/bloc.dart';
import 'package:meninki/features/reels/data/reels_remote_data_source.dart';
import 'package:meta/meta.dart';

import '../../../reels/model/query.dart';
import '../../models/comment.dart';

part 'get_comments_event.dart';
part 'get_comments_state.dart';

class GetCommentsBloc extends Bloc<GetCommentsEvent, GetCommentsState> {
  final ReelsRemoteDataSource ds;
  List<Comment> comments = [];

  int page = 1;
  int limit = 150;
  bool canPag = false;

  GetCommentsBloc(this.ds) : super(GetCommentsInitial()) {
    on<GetCommentsEvent>((event, emit) async {
      if (event is GetComment) {
        canPag = false;

        emit.call(GetCommentsLoading());
        emit.call(await _getComments(event));
      }

      if (event is CommentPag) {
        if (!canPag) return;

        canPag = false;
        emit.call(CommentPagLoading(comments));
        emit.call(await _paginate(event));
      }
      if (event is AddSentComment) {
        comments.add(event.comment);
        emit.call(GetCommentsSuccess(comments, true));
      }
    });
  }

  Future<GetCommentsState> _paginate(CommentPag event) async {
    page += 1;

    final failOrNot = await ds.getComments(
      reelId: event.reelId,
      query: (event.query ?? Query()).copyWith(offset: page, limit: limit, orderDirection: "asc"),
    );

    return failOrNot.fold((l) => GetCommentsFailed(message: l.message, statusCode: l.statusCode), (
      r,
    ) {
      comments.addAll(r);
      if (r.length == limit) canPag = true;
      return GetCommentsSuccess(comments, r.length == limit);
    });
  }

  Future<GetCommentsState> _getComments(GetComment event) async {
    page = 1;

    final failOrNot = await ds.getComments(
      reelId: event.reelId,
      query: (event.query ?? Query()).copyWith(offset: page, limit: limit, orderDirection: "asc"),
    );

    return failOrNot.fold((l) => GetCommentsFailed(message: l.message, statusCode: l.statusCode), (
      r,
    ) {
      if (r.length == limit) canPag = true;
      comments = r;
      return GetCommentsSuccess(r, r.length == limit);
    });
  }
}
