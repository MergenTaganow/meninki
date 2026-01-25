import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/basket/data/basket_remote_data_source.dart';
import 'package:meta/meta.dart';

import '../../../../core/injector.dart';
import '../../models/basket_product.dart';
import '../get_basket_cubit/get_basket_cubit.dart';

part 'my_basket_state.dart';

class MyBasketCubit extends Cubit<MyBasketState> {
  BasketRemoteDataSource ds;
  MyBasketCubit(this.ds) : super(MyBasketInitial());

  List<int> compositionIds = [];

  getMyBasketProductIds() async {
    emit(MyBasketLoading(loadingId: 0, loadingAction: ''));
    final failOrNot = await ds.getMyBasketProductIds();
    failOrNot.fold((l) => emit(MyBasketFailed(l)), (r) {
      compositionIds = r;
      emit.call(MyBasketSuccess(compositionIds));
    });
  }

  updateProduct({required BasketProduct product, required bool isAdding}) async {
    emit(
      MyBasketLoading(
        loadingId: product.composition?.id ?? 0,
        loadingAction: isAdding ? 'add' : 'remove',
      ),
    );
    final failOrNot = await ds.updateProduct(
      product.composition?.id ?? 0,
      (isAdding ? (product.quantity ?? 0) + 1 : (product.quantity ?? 1) - 1).toInt(),
    );
    failOrNot.fold((l) => emit(MyBasketFailed(l)), (r) {
      if (isAdding) {
        sl<GetBasketCubit>().updateElement(product.copyWith(quantity: (product.quantity ?? 0) + 1));
        emit(ProductAdded());
      } else {
        emit(ProductRemoved());
        sl<GetBasketCubit>().updateElement(product.copyWith(quantity: (product.quantity ?? 1) - 1));
        if ((product.quantity ?? 1) - 1 == 0) {
          compositionIds.remove(product.composition?.id);
        }
      }
    });
    emit(MyBasketSuccess(compositionIds));
  }

  clearBasket() async {
    var failOrNot = await ds.clearBasket();
    failOrNot.fold((l) => emit.call(MyBasketFailed(l)), (r) {
      compositionIds = [];
      sl<GetBasketCubit>().getMyBasket();
      emit.call(MyBasketSuccess(compositionIds));
    });
    emit.call(MyBasketSuccess(compositionIds));
  }

  addProduct(int productId, int compositionId) async {
    emit.call(MyBasketLoading(loadingId: compositionId, loadingAction: 'add'));
    final failOrNot = await ds.addProduct(compositionId);
    failOrNot.fold((l) => emit.call(MyBasketFailed(l)), (r) {
      emit.call(ProductAdded());
      compositionIds.add(compositionId);
    });
    emit.call(MyBasketSuccess(compositionIds));
  }

  removeProduct(int productId, int compositionId) async {
    emit.call(MyBasketLoading(loadingId: compositionId, loadingAction: 'remove'));
    final failOrNot = await ds.removeProduct(compositionId);
    failOrNot.fold((l) => emit.call(MyBasketFailed(l)), (r) {
      emit.call(ProductRemoved());
      compositionIds.remove(compositionId);
      sl<GetBasketCubit>().getMyBasket();
      emit.call(MyBasketSuccess(compositionIds));
    });
    emit.call(MyBasketSuccess(compositionIds));
  }
}
