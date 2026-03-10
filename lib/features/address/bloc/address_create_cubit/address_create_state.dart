part of 'address_create_cubit.dart';

@immutable
sealed class AddressCreateState {}

final class AddressCreateInitial extends AddressCreateState {}

final class AddressCreateLoading extends AddressCreateState {}

final class AddressCreateFailed extends AddressCreateState {
  final Failure failure;
  AddressCreateFailed(this.failure);
}

final class AddressCreateSuccess extends AddressCreateState {
  final Address address;
  AddressCreateSuccess(this.address);
}

final class AddressEditSuccess extends AddressCreateState {
  AddressEditSuccess();
}
