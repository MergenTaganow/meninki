part of 'register_cubit.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterFailed extends RegisterState {
  final Failure failure;
  RegisterFailed(this.failure);
}

final class RegisterSuccess extends RegisterState {
  final User user;
  RegisterSuccess(this.user);
}
