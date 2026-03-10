import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/address/data/address_remote_data_source.dart';
import 'package:meninki/features/address/models/address.dart';
import 'package:meta/meta.dart';

part 'get_address_state.dart';

class GetAddressCubit extends Cubit<GetAddressState> {
  final AddressRemoteDataSource ds;
  GetAddressCubit(this.ds) : super(GetAddressInitial());

  getMyAddresses() async {
    emit(GetAddressLoading());
    var failOrNot = await ds.getAddresses();
    failOrNot.fold((l) => emit(GetAddressFailed(failure: l)), (r) => emit(GetAddressSuccess(r)));
  }
}
