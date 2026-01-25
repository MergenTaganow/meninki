import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/basket/data/basket_remote_data_source.dart';
import 'package:meninki/features/basket/models/basket_product.dart';
import 'package:meta/meta.dart';

part 'get_basket_state.dart';

class GetBasketCubit extends Cubit<GetBasketState> {
  BasketRemoteDataSource ds;
  GetBasketCubit(this.ds) : super(GetBasketInitial());

  List<BasketProduct> myBasket = [];

  getMyBasket() async {
    // emit.call(GetBasketLoading());
    var failOrNot = await ds.getMyBasket();
    failOrNot.fold((l) => emit.call(GetBasketFailed(l)), (r) {
      print(r.length);
      myBasket = r;
      emit.call(GetBasketSuccess(r));
    });
  }

  updateElement(BasketProduct element) {
    var index = myBasket.indexWhere((e) => e.id == element.id);
    if (element.quantity == 0) {
      myBasket.removeAt(index);
    } else {
      myBasket[index] = element;
    }
    emit.call(GetBasketSuccess(myBasket));
  }
}
