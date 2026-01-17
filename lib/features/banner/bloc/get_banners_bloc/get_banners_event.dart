part of 'get_banners_bloc.dart';

@immutable
sealed class GetBannersEvent {}

class GetBanner extends GetBannersEvent {
  final Query? query;
  GetBanner([this.query]);
}

class BannerPag extends GetBannersEvent {
  final Query? query;
  BannerPag([this.query]);
}

class ClearBanners extends GetBannersEvent {}