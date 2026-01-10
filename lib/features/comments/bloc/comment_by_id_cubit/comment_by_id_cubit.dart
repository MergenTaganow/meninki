import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/comments/models/comment.dart';
import 'package:meninki/features/reels/data/reels_remote_data_source.dart';
import 'package:meta/meta.dart';

part 'comment_by_id_state.dart';

class CommentByIdCubit extends Cubit<CommentByIdState> {
  ReelsRemoteDataSource ds;
  CommentByIdCubit(this.ds) : super(CommentByIdInitial());

  getComment(int id) async {
    emit(CommentByIdLoading());
    var failOrNot = await ds.commentById(id);
    failOrNot.fold((l) => emit.call(CommentByIdFailed(l)), (r) => emit.call(CommentByIdSuccess(r)));
  }
}
