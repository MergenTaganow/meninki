part of 'get_market_by_id_cubit.dart';

@immutable
sealed class GetMarketByIdState {}

final class GetMarketByIdInitial extends GetMarketByIdState {}

final class GetMarketByIdLoading extends GetMarketByIdState {}

final class GetMarketByIdFailed extends GetMarketByIdState {
  final Failure failure;
  GetMarketByIdFailed(this.failure);
}

final class GetMarketByIdSuccess extends GetMarketByIdState {
  final Market market;
  GetMarketByIdSuccess(this.market);
}
