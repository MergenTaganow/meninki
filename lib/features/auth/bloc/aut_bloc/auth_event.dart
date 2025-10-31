part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class LogoutEvent extends AuthEvent {}

class GetLocalUser extends AuthEvent {}

class SetUser extends AuthEvent {
  final User user;
  SetUser(this.user);
}
