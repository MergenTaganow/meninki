part of 'otp_cubit.dart';

@immutable
sealed class OtpState {}

final class OtpInitial extends OtpState {}

final class OtpLoading extends OtpState {}

final class OtpFailed extends OtpState {
  final Failure failure;
  OtpFailed(this.failure);
}

final class OtpSend extends OtpState {
  final int retrySeconds;
  final bool navigate;
  final bool checkLoading;
  OtpSend({required this.retrySeconds, this.navigate = false, required this.checkLoading});
}

final class OtpSuccess extends OtpState {
  final String temporaryToken;
  OtpSuccess(this.temporaryToken);
}
