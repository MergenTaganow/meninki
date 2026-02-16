import 'package:bloc/bloc.dart';
import 'package:meninki/features/reels/blocs/get_my_reels_bloc/get_my_reels_bloc.dart';
import 'package:meninki/features/reels/data/reels_remote_data_source.dart';
import 'package:meninki/features/reels/model/reels.dart';
import 'package:meta/meta.dart';

import '../../../../core/injector.dart';
import '../get_reels_bloc/get_reels_bloc.dart';

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

  likeTapped(Reel reel) async {
    var index = likedReels.indexWhere((e) => e == reel.id);
    if (index == -1) {
      likedReels.add(reel.id);
    } else {
      likedReels.removeAt(index);
    }
    emit.call(LikedReelsSuccess(likedReels));
    await ds.likeReel(reel.id);
    sl<GetMyReelsBloc>().add(UpdateMyReel(reel));
    sl<GetVerifiedReelsBloc>().add(UpdateReels(reel));
    sl<GetProductReelsBloc>().add(UpdateReels(reel));
    sl<GetStoreReelsBloc>().add(UpdateReels(reel));
    sl<GetSearchedReelsBloc>().add(UpdateReels(reel));
  }
}
