import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/failure.dart';
import '../../data/address_remote_data_source.dart';
import '../../models/address.dart';

part 'address_create_state.dart';

class AddressCreateCubit extends Cubit<AddressCreateState> {
  final AddressRemoteDataSource ds;

  AddressCreateCubit(this.ds) : super(AddressCreateInitial());

  createAddress(Map<String, dynamic> data) async {
    emit(AddressCreateLoading());

    final failOrNot = await ds.createAddress(data);

    failOrNot.fold((l) => emit(AddressCreateFailed(l)), (r) => emit(AddressCreateSuccess(r)));
  }

  deleteAddress(int id) async {
    emit(AddressCreateLoading());

    final failOrNot = await ds.deleteAddress(id);

    failOrNot.fold(
          (l) => emit(AddressCreateFailed(l)),
          (r) => emit(AddressEditSuccess()),
    );
  }
}
