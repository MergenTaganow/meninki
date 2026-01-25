import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/store/data/store_remote_data_source.dart';
import 'package:meta/meta.dart';

part 'market_favorites_state.dart';

class MarketFavoritesCubit extends Cubit<MarketFavoritesState> {
  final StoreRemoteDataSource ds;
  MarketFavoritesCubit(this.ds) : super(MarketFavoritesInitial());

  List<int> favoriteMarkets = [];

  init() async {
    emit.call(MarketFavoritesLoading());
    var failOrNot = await ds.getFavoriteMarkets();
    failOrNot.fold((l) => emit.call(MarketFavoritesFailed(l)), (r) {
      favoriteMarkets = r;
      emit.call(MarketFavoritesSuccess(r));
    });

    print("object ${favoriteMarkets}");
  }

  favoriteTapped(int marketId) async {
    var index = favoriteMarkets.indexWhere((e) => e == marketId);
    print(index);
    if (index == -1) {
      favoriteMarkets.add(marketId);
      var failOrNot = await ds.addFavoriteMarket(marketId);
      failOrNot.fold(
        (l) => emit.call(MarketFavoritesFailed(l)),
        (r) => emit.call(MarketFavoritesSuccess(favoriteMarkets)),
      );
    } else {
      favoriteMarkets.removeAt(index);
      var failOrNot = await ds.removeFavoriteMarket(marketId);
      failOrNot.fold(
        (l) => emit.call(MarketFavoritesFailed(l)),
        (r) => emit.call(MarketFavoritesSuccess(favoriteMarkets)),
      );
    }
    emit.call(MarketFavoritesSuccess(favoriteMarkets));
  }
}
