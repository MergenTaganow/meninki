import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/reels/data/reels_remote_data_source.dart';
import 'package:meta/meta.dart';

part 'reel_create_state.dart';

class ReelCreateCubit extends Cubit<ReelCreateState> {
  ReelsRemoteDataSource ds;
  ReelCreateCubit(this.ds) : super(ReelCreateInitial());

  createReel(Map<String, dynamic> map) async {
    emit.call(ReelCreateLoading());
    var failOrNot = await ds.createReel(map);
    failOrNot.fold((l) => emit.call(ReelCreateFailed(l)), (r) => emit.call(ReelCreateSuccess()));
  }
}
