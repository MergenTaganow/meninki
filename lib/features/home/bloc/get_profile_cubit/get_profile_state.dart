part of 'get_profile_cubit.dart';

@immutable
sealed class GetProfileState {}

final class GetProfileInitial extends GetProfileState {}

final class GetProfileLoading extends GetProfileState {}

final class GetProfileFailed extends GetProfileState {
  late final Failure failure;
  GetProfileFailed(this.failure);
}

final class GetProfileSuccess extends GetProfileState {
  final Profile profile;
  GetProfileSuccess(this.profile);
}
