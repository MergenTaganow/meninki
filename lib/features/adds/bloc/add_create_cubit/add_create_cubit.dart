import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/failure.dart';
import '../../data/add_remote_data_source.dart';
import '../../models/add.dart';

part 'add_create_state.dart';

class AddCreateCubit extends Cubit<AddCreateState> {
  AddRemoteDataSource ds;

  AddCreateCubit(this.ds) : super(AddCreateInitial());

  createAdd(Map<String, dynamic> data) async {
    var failOrNot = await ds.createAdd(data);
    failOrNot.fold(
          (l) => emit.call(AddCreateFailed(l)),
          (r) => emit.call(AddCreateSuccess(r)),
    );
  }
}