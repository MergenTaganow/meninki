import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/auth/bloc/aut_bloc/auth_bloc.dart';
import 'package:meninki/features/auth/data/auth_remote_data_source.dart';
import 'package:meta/meta.dart';

import '../../../../core/injector.dart';
import '../../models/user.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final AuthRemoteDataSource ds;
  OtpCubit(this.ds) : super(OtpInitial());
  int retrySeconds = 120;
  Timer? retryTimer;

  sendOtp(String phoneNumber) async {
    emit(OtpLoading());
    retrySeconds = 120;
    var failOrNot = await ds.sendOtp(phoneNumber: phoneNumber);
    failOrNot.fold((l) => emit(OtpFailed(l)), (r) {
      emit(OtpSend(retrySeconds, true));
      retryTimer = Timer.periodic(Duration(seconds: 1), (_) {
        retrySeconds--;
        emit(OtpSend(retrySeconds));
        if (retrySeconds == 0) {
          retryTimer?.cancel();
          retryTimer = null;
        }
      });
    });
  }

  checkOtp({required int otp, required String phoneNumber}) async {
    var failOrNot = await ds.checkOtp(phoneNumber: phoneNumber, otp: otp);

    failOrNot.fold((l) => emit.call(OtpFailed(l)), (r) {
      retryTimer?.cancel();
      retryTimer = null;

      if (r.temporaryToken != null) {
        emit.call(OtpSuccess(r.temporaryToken!));
      } else {
        sl<AuthBloc>().add(SetUser(r));
      }
    });
  }
}
