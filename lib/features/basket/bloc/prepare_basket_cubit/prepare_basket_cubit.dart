import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/basket/data/basket_remote_data_source.dart';
import 'package:meta/meta.dart';

import '../../models/prepared_basket.dart';

part 'prepare_basket_state.dart';

class PrepareBasketCubit extends Cubit<PrepareBasketState> {
  final BasketRemoteDataSource ds;
  PrepareBasketCubit(this.ds) : super(PrepareBasketInitial());

  prepareBasket(int addressId) async {
    emit(PrepareBasketLoading());
    var failOrNot = await ds.prepareBasket(addressId);
    failOrNot.fold((l) => emit(PrepareBasketFailed(l)), (r) => emit(PrepareBasketSuccess(r)));
  }
}
