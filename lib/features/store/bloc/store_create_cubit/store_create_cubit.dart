import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/reels/model/meninki_file.dart';
import 'package:meta/meta.dart';

import '../../data/store_remote_data_source.dart';

part 'store_create_state.dart';

class StoreCreateCubit extends Cubit<StoreCreateState> {
  final StoreRemoteDataSource ds;
  StoreCreateCubit(this.ds) : super(StoreCreateInitial());

  createStore(Map map) async {
    emit.call(StoreCreateLoading());
    var failOrNot = await ds.storeCreate(map);
    failOrNot.fold((l) => emit.call(StoreCreateFailed(l)), (r) => emit.call(StoreCreateSuccess()));
  }

  editStore(int marketId, Map map) async {
    emit.call(StoreCreateLoading());
    var failOrNot = await ds.storeEdit(marketId, map);
    failOrNot.fold((l) => emit.call(StoreCreateFailed(l)), (r) => emit.call(StoreEditSuccess()));
  }

  editStoreFiles(int marketId, List<MeninkiFile> files) async {
    emit.call(StoreCreateLoading());
    var failOrNot = await ds.storeEdit(marketId, {"file_ids": files.map((e) => e.id).toList()});
    failOrNot.fold((l) => emit.call(StoreCreateFailed(l)), (r) => emit.call(StoreEditSuccess()));
  }
}
