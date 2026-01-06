import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/reels/data/reels_remote_data_source.dart';
import 'package:meta/meta.dart';

import '../../../../core/injector.dart';
import '../file_upl_cover_image_bloc/file_upl_cover_image_bloc.dart';

part 'reel_create_state.dart';

class ReelCreateCubit extends Cubit<ReelCreateState> {
  ReelsRemoteDataSource ds;
  ReelCreateCubit(this.ds) : super(ReelCreateInitial());

  Map<String, dynamic>? laterCreateReel;

  createReel(Map<String, dynamic> map) async {
    emit.call(ReelCreateLoading());
    var failOrNot = await ds.createReel(map);
    failOrNot.fold((l) => emit.call(ReelCreateFailed(l)), (r) => emit.call(ReelCreateSuccess()));
    sl<FileUplCoverImageBloc>().add(Clear());
  }

  setReel(Map<String, dynamic> map) {
    laterCreateReel = map;
    emit.call(LaterCreateReel(laterCreateReel!));
  }

  sendLaterReel(int fileId) async {
    if (laterCreateReel == null) return;
    laterCreateReel!['file_id'] = fileId;
    var failOrNot = await ds.createReel(laterCreateReel!);
    failOrNot.fold((l) => emit.call(ReelCreateFailed(l)), (r) => emit.call(ReelCreateSuccess()));
    laterCreateReel = null;
    sl<FileUplCoverImageBloc>().add(Clear());
  }
}
