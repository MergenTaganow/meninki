import 'package:bloc/bloc.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/routes.dart';
import 'package:meta/meta.dart';

import '../../../../core/failure.dart';
import '../../data/auth_remote_data_source.dart';
import '../../data/employee_local_data_source.dart';
import '../../models/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRemoteDataSource ds;
  EmployeeLocalDataSource repo;
  AuthBloc(this.ds, this.repo) : super(AuthLoading()) {
    on<AuthEvent>((event, emit) async {
      if (event is LogoutEvent) {
        repo.saveUser(u: null);
        repo.signOut();
        emit(AuthFailed(const Failure()));
        Go.too(Routes.loginMethodsScreen);
      }

      if (event is GetLocalUser) {
        var user = repo.user;
        if (user != null) {
          // bool hasExpired = JwtDecoder.isExpired(user.token!);
          // if (!hasExpired) {
          emit.call(AuthSuccess(user));
          return;
          // }
        }
        emit.call(AuthInitial());
      }
      if (event is SetUser) {
        repo.saveUser(u: event.user);
        emit.call(AuthSuccess(event.user));
      }
    });
  }
}
