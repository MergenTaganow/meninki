import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/auth/data/employee_local_data_source.dart';
import 'package:meninki/features/comments/bloc/get_comments_bloc/get_comments_bloc.dart';
import 'package:meninki/features/comments/models/comment.dart';
import 'package:meninki/features/reels/data/reels_remote_data_source.dart';
import 'package:meta/meta.dart';

import '../../../../core/injector.dart';

part 'send_comment_state.dart';

class SendCommentCubit extends Cubit<SendCommentState> {
  final ReelsRemoteDataSource ds;
  SendCommentCubit(this.ds) : super(SendCommentInitial());

  sendComment(Map<String, dynamic> data) async {
    emit(SendCommentLoading());
    final failOrNot = await ds.sendComment(data);
    failOrNot.fold((l) => emit.call(SendCommentFailed(l)), (r) {
      r.creator = sl<EmployeeLocalDataSource>().user;
      sl<GetCommentsBloc>().add(AddSentComment(r));
      emit.call(SendCommentSuccess(r));
    });
  }

  clear() {
    emit(SendCommentInitial());
  }
}
