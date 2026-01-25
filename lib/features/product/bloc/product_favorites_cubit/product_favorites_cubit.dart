import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/product/data/product_remote_data_source.dart';
import 'package:meta/meta.dart';

part 'product_favorites_state.dart';

class ProductFavoritesCubit extends Cubit<ProductFavoritesState> {
  final ProductRemoteDataSource ds;
  ProductFavoritesCubit(this.ds) : super(ProductFavoritesInitial());
  List<int> productIds = [];

  init() async {
    emit(ProductFavoritesLoading());
    var failOrNot = await ds.getFavoriteIds();
    failOrNot.fold((l) => emit.call(ProductFavoritesFailed(l)), (r) {
      productIds = r;
      emit.call(ProductFavoritesSuccess(productIds));
    });

    emit.call(ProductFavoritesSuccess(productIds));
  }

  toggleFavorite(int productId) async {
    emit(ProductFavoritesLoading());
    if (productIds.contains(productId)) {
      productIds.remove(productId);
      await ds.removeFavoriteProduct(productId);
    } else {
      productIds.add(productId);
      await ds.addFavoriteProduct(productId);
    }
    emit.call(ProductFavoritesSuccess(productIds));
  }
}
