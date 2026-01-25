import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/adds/data/add_remote_data_source.dart';
import 'package:meninki/features/adds/models/add.dart';
import 'package:meta/meta.dart';

part 'add_uuid_state.dart';

class AddUuidCubit extends Cubit<AddUuidState> {
  final AddRemoteDataSource ds;
  AddUuidCubit(this.ds) : super(AddUuidInitial());

  getAdd(int id) async {
    emit(AddUuidLoading());
    var failOrNot = await ds.addByUUid(id);

    failOrNot.fold((l) => emit(AddUuidFailed(l)), (r) => emit(AddUuidSuccess(r)));
  }
}
