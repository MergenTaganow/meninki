import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/auth/bloc/aut_bloc/auth_bloc.dart';
import 'package:meninki/features/auth/data/auth_remote_data_source.dart';
import 'package:meta/meta.dart';
import '../../../../core/injector.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final AuthRemoteDataSource ds;
  OtpCubit(this.ds) : super(OtpInitial());
  int retrySeconds = 120;
  Timer? retryTimer;
  bool checkLoading = false;

  sendOtp(String phoneNumber) async {
    checkLoading = false;
    emit(OtpLoading());
    retrySeconds = 120;
    var failOrNot = await ds.sendOtp(phoneNumber: phoneNumber);
    failOrNot.fold((l) => emit(OtpFailed(l)), (r) {
      emit(OtpSend(retrySeconds: retrySeconds, navigate: true, checkLoading: checkLoading));
      retryTimer = Timer.periodic(Duration(seconds: 1), (_) {
        retrySeconds--;
        emit(OtpSend(retrySeconds: retrySeconds, checkLoading: checkLoading));
        if (retrySeconds == 0) {
          retryTimer?.cancel();
          retryTimer = null;
        }
      });
    });
  }

  checkOtp({required int otp, required String phoneNumber}) async {
    checkLoading = true;
    var failOrNot = await ds.checkOtp(phoneNumber: phoneNumber, otp: otp);

    checkLoading = false;
    failOrNot.fold(
      (l) {
        emit.call(OtpFailed(l));
        emit(OtpSend(retrySeconds: retrySeconds, checkLoading: checkLoading));
      },
      (r) {
        retryTimer?.cancel();
        retryTimer = null;

        if (r.temporaryToken != null) {
          emit.call(OtpSuccess(r.temporaryToken!));
        } else {
          sl<AuthBloc>().add(SetUser(r));
        }
      },
    );
  }
}
