import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/reels/data/reels_remote_data_source.dart';
import 'package:meninki/features/reels/model/reels.dart';
import 'package:meta/meta.dart';

part 'reel_by_id_state.dart';

class ReelByIdCubit extends Cubit<ReelByIdState> {
  final ReelsRemoteDataSource ds;
  ReelByIdCubit(this.ds) : super(ReelByIdInitial());

  Future<Reel?> getReel(int id) async {
    emit(ReelByIdLoading());
    var failOrNot = await ds.reelById(id);

    failOrNot.fold(
      (l) {
        // emit(ReelByIdFailed(l));
        return null;
      },
      (r) {
        // emit(ReelByIdSuccess(r));
        print("will return r");
        return r;
      },
    );
    // return null;
  }
}
