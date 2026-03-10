import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/basket/data/basket_remote_data_source.dart';
import 'package:meninki/features/orders/model/order.dart';
import 'package:meta/meta.dart';

part 'order_id_state.dart';

class OrderIdCubit extends Cubit<OrderIdState> {
  final BasketRemoteDataSource ds;
  OrderIdCubit(this.ds) : super(OrderIdInitial());

  getOrder(int id, {bool clientOrder = false}) async {
    emit(OrderIdLoading());
    var failOrNot = await ds.getOrderId(id, clientOrder);
    failOrNot.fold((l) => emit(OrderIdFailed(l)), (r) => emit(OrderIdSuccess(r)));
  }
}
