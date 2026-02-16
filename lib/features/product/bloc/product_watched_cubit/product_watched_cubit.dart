import 'package:bloc/bloc.dart';
import 'package:meninki/features/product/data/product_remote_data_source.dart';
import 'package:meninki/features/reels/data/reels_remote_data_source.dart';
import 'package:meta/meta.dart';

part 'product_watched_state.dart';

class WatchersCubit extends Cubit<WatchersState> {
  final ProductRemoteDataSource productDS;
  final ReelsRemoteDataSource reelDS;
  WatchersCubit(this.productDS, this.reelDS) : super(WatchersInitial());

  productWatched(int productId) async {
    await productDS.watchProduct(productId);
  }

  reelsWatched(int reelId) async {
    await reelDS.watchReel(reelId);
  }
}
