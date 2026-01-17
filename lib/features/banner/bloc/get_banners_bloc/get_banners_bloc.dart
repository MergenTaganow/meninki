import 'package:bloc/bloc.dart';
import 'package:meninki/features/product/data/product_remote_data_source.dart';
import 'package:meta/meta.dart';

import '../../../reels/model/query.dart';
import '../../models/banner.dart';

part 'get_banners_event.dart';
part 'get_banners_state.dart';

class BannerPageTypes {
  static String home_main = 'home_main';
  static String home_reels = 'home_reels';
  static String view_reels = 'view_reels';
  static String view_products = 'view_products';
  static String view_adds = 'view_adds';
  static String view_market = 'view_market';
  static String basket = 'basket';
  static String user_profile = 'user_profile';
  static String market_profile = 'market_profile';
  static String product = 'product';
}

class GetBannersBloc extends Bloc<GetBannersEvent, GetBannersState> {
  final ProductRemoteDataSource ds;

  /// priority -> banners
  Map<int, List<Banner>> bannersByPriority = {};

  int priority = 1;
  int limit = 15;
  int page = 1;

  GetBannersBloc(this.ds) : super(GetBannerInitial()) {
    on<GetBannersEvent>((event, emit) async {
      if (event is GetBanner) {
        priority = 1;
        bannersByPriority.clear();

        emit(GetBannerLoading());
        emit(await _getBanners(event));
      }

      if (event is BannerPag) {
        emit(BannerPagLoading(bannersByPriority));
        emit(await _paginate(event));
      }

      if (event is ClearBanners) {
        priority = 1;
        bannersByPriority.clear();
        emit(GetBannerInitial());
      }
    });
  }

  Future<GetBannersState> _getBanners(GetBanner event) async {
    final failOrNot = await ds.getBanners(
      (event.query ?? Query()).copyWith(
        priority: priority,
        limit: limit,
        offset: page,
        orderBy: 'priority',
        orderDirection: 'asc',
      ),
    );

    return failOrNot.fold((l) => GetBannerFailed(message: l.message, statusCode: l.statusCode), (
      r,
    ) {
      if (r.isEmpty) {
        return GetBannerSuccess(bannersByPriority, false);
      }

      bannersByPriority[priority] = r;

      return GetBannerSuccess(bannersByPriority, true);
    });
  }

  Future<GetBannersState> _paginate(BannerPag event) async {
    priority += 1;

    final failOrNot = await ds.getBanners(
      (event.query ?? Query()).copyWith(
        priority: priority,
        limit: limit,
        offset: page,
        orderBy: 'priority',
        orderDirection: 'asc',
      ),
    );

    return failOrNot.fold((l) => GetBannerFailed(message: l.message, statusCode: l.statusCode), (
      r,
    ) {
      if (r.isEmpty) {
        return GetBannerSuccess(bannersByPriority, false);
      }

      bannersByPriority[priority] = r;

      return GetBannerSuccess(bannersByPriority, true);
    });
  }
}
