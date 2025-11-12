import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meta/meta.dart';

import '../../data/store_remote_data_source.dart';

part 'store_create_state.dart';

class StoreCreateCubit extends Cubit<StoreCreateState> {
  final StoreRemoteDataSource ds;
  StoreCreateCubit(this.ds) : super(StoreCreateInitial());

  createStore(Map map) async {
    var failOrNot = await ds.storeCreate(map);
    failOrNot.fold((l) => emit.call(StoreCreateFailed(l)), (r) => emit.call(StoreCreateSuccess()));
  }
}
