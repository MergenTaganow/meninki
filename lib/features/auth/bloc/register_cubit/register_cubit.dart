import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/auth/data/auth_remote_data_source.dart';
import 'package:meninki/features/auth/models/user.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRemoteDataSource ds;
  RegisterCubit(this.ds) : super(RegisterInitial());

  register(Map<String, dynamic> data) async {
    emit.call(RegisterLoading());
    var failOrNot = await ds.register(data);

    failOrNot.fold((l) => emit.call(RegisterFailed(l)), (r) => emit.call(RegisterSuccess(r)));
  }
}
