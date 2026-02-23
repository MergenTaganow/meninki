import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/product/data/product_remote_data_source.dart';
import 'package:meninki/features/reels/data/reels_remote_data_source.dart';
import 'package:meta/meta.dart';

part 'delete_items_state.dart';

class DeleteItemsCubit extends Cubit<DeleteItemsState> {
  final ProductRemoteDataSource productDs;
  final ReelsRemoteDataSource reelsDs;
  DeleteItemsCubit(this.productDs, this.reelsDs) : super(DeleteItemsInitial());

  deleteProduct(int productId) async {
    emit(DeleteItemsLoading());

    var failOrNot = await productDs.deleteProduct(productId);
    failOrNot.fold(
      (l) => emit(DeleteItemsFailed(l)),
      (r) => emit(DeleteItemsSuccess(deletedThing: DeleteItems.product, deletedId: productId)),
    );
  }

  deleteReel(int reelId) async {
    emit(DeleteItemsLoading());

    var failOrNot = await reelsDs.deleteReel(reelId);
    failOrNot.fold(
      (l) => emit(DeleteItemsFailed(l)),
      (r) => emit(DeleteItemsSuccess(deletedThing: DeleteItems.reel, deletedId: reelId)),
    );
  }
}

class DeleteItems {
  static String product = 'product';
  static String reel = 'reel';
}
