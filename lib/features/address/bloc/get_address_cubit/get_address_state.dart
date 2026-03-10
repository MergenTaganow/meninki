part of 'get_address_cubit.dart';

@immutable
sealed class GetAddressState {}

final class GetAddressInitial extends GetAddressState {}

final class GetAddressLoading extends GetAddressState {}

final class GetAddressFailed extends GetAddressState {
  final Failure failure;
  GetAddressFailed({required this.failure});
}

final class GetAddressSuccess extends GetAddressState {
  final List<Address> addresses;
  GetAddressSuccess(this.addresses);
}
