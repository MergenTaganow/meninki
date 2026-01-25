import 'package:bloc/bloc.dart';
import 'package:meninki/features/adds/data/add_remote_data_source.dart';
import 'package:meta/meta.dart';

import '../../../../core/failure.dart';

part 'add_favorite_state.dart';

class AddFavoriteCubit extends Cubit<AddFavoriteState> {
  final AddRemoteDataSource ds;
  AddFavoriteCubit(this.ds) : super(AddFavoriteInitial());

  List<int> addIds = [];

  init() async {
    emit(AddFavoritesLoading());
    var failOrNot = await ds.getFavoriteIds();
    failOrNot.fold((l) => emit.call(AddFavoritesFailed(l)), (r) {
      addIds = r;
      emit.call(AddFavoritesSuccess(addIds));
    });

    emit.call(AddFavoritesSuccess(addIds));
  }

  toggleFavorite(int productId) async {
    emit(AddFavoritesLoading());
    if (addIds.contains(productId)) {
      addIds.remove(productId);
      await ds.removeFavoriteAdd(productId);
    } else {
      addIds.add(productId);
      await ds.addFavoriteAdd(productId);
    }
    emit.call(AddFavoritesSuccess(addIds));
  }
}
