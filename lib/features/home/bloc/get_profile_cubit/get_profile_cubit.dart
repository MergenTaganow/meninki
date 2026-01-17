import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/auth/data/auth_remote_data_source.dart';
import 'package:meninki/features/home/model/profile.dart';
import 'package:meta/meta.dart';
part 'get_profile_state.dart';

class GetProfileCubit extends Cubit<GetProfileState> {
  AuthRemoteDataSource ds;
  GetProfileCubit(this.ds) : super(GetProfileInitial());

  getMyProfile() async {
    emit.call(GetProfileLoading());
    var failOrNot = await ds.getMyProfile();
    failOrNot.fold((l) => emit.call(GetProfileFailed(l)), (r) => emit.call(GetProfileSuccess(r)));
  }
}
