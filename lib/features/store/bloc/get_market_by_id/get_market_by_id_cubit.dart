import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/store/data/store_remote_data_source.dart';
import 'package:meninki/features/store/models/market.dart';
import 'package:meta/meta.dart';

part 'get_market_by_id_state.dart';

class GetMarketByIdCubit extends Cubit<GetMarketByIdState> {
  final StoreRemoteDataSource ds;
  GetMarketByIdCubit(this.ds) : super(GetMarketByIdInitial());

  getStoreById(int id) async {
    emit.call(GetMarketByIdLoading());
    var failOrNot = await ds.getStoreByID(id);
    failOrNot.fold(
      (l) => emit.call(GetMarketByIdFailed(l)),
      (r) => emit.call(GetMarketByIdSuccess(r)),
    );
  }

  Future<void> refresh(int id) async {
    var failOrNot = await ds.getStoreByID(id);
    failOrNot.fold(
      (l) => emit.call(GetMarketByIdFailed(l)),
      (r) => emit.call(GetMarketByIdSuccess(r)),
    );
  }

  clear() {
    emit(GetMarketByIdInitial());
  }
}
