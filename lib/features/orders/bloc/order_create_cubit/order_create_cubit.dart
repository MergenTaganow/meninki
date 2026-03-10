import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/basket/data/basket_remote_data_source.dart';
import 'package:meta/meta.dart';

part 'order_create_state.dart';

class OrderCreateCubit extends Cubit<OrderCreateState> {
  final BasketRemoteDataSource ds;
  OrderCreateCubit(this.ds) : super(OrderCreateInitial());

  createOrder(Map<String, dynamic> data) async {
    emit(OrderCreateLoading());
    var failOrNot = await ds.orderCreate(data);

    failOrNot.fold((l) => emit(OrderCreateFailed(failure: l)), (r) => emit(OrderCreateSuccess()));
  }
}
