part of 'get_banners_bloc.dart';

@immutable
sealed class GetBannersState {}

class GetBannerInitial extends GetBannersState {}

class GetBannerLoading extends GetBannersState {}

class BannerPagLoading extends GetBannersState {
  final Map<int, List<Banner>> banners;
  BannerPagLoading(this.banners);
}

class GetBannerSuccess extends GetBannersState {
  final Map<int, List<Banner>> banners;
  final bool canPag;

  GetBannerSuccess(this.banners, this.canPag);
}

class GetBannerFailed extends GetBannersState {
  final String? message;
  final int? statusCode;
  GetBannerFailed({this.message, this.statusCode});
}