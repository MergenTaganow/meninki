import 'package:bloc/bloc.dart';
import 'package:meninki/features/reels/data/reels_remote_data_source.dart';
import 'package:meta/meta.dart';

part 'liked_reels_state.dart';

class LikedReelsCubit extends Cubit<LikedReelsState> {
  final ReelsRemoteDataSource ds;
  LikedReelsCubit(this.ds) : super(LikedReelsSuccess([]));
  List<int> likedReels = [];

  init() async {
    var failOrNot = await ds.getLikedReels();
    failOrNot.fold((l) {}, (r) {
      likedReels = r;
      emit.call(LikedReelsSuccess(likedReels));
    });
  }

  likeTapped(int reelId) async {
    var index = likedReels.indexWhere((e) => e == reelId);
    if (index == -1) {
      likedReels.add(reelId);
    } else {
      likedReels.removeAt(index);
    }
    emit.call(LikedReelsSuccess(likedReels));
    await ds.likeReel(reelId);
  }
}
