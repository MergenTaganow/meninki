import 'package:meninki/core/api.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/reels/blocs/current_reel_cubit/current_reel_cubit.dart';
import 'package:meninki/features/reels/blocs/reel_by_id/reel_by_id_cubit.dart';

import '../core/injector.dart';
import '../features/home/bloc/get_profile_cubit/get_profile_cubit.dart';
import '../features/reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import '../features/reels/data/reels_remote_data_source.dart';
import '../features/store/bloc/get_market_by_id/get_market_by_id_cubit.dart';

class DeepLink {
  static String reel = 'reel';
  static String product = 'product';
  static String market = 'market';
  static String profile = 'profile';

  createDeepLink({required int id, required String type}) {
    return "$baseUrl/deepLink/$type/$id";
  }

  handleNavigation(Uri uri) async {
    final segments = uri.pathSegments;

    if (segments.length < 3) return null;
    if (segments[0] != 'deepLink') return null;

    final typeString = segments[1];
    final id = segments[2];

    switch (typeString) {
      case 'reel':
        var request = await sl<ReelsRemoteDataSource>().reelById(int.parse(id));
        request.fold((l) {}, (r) {
          sl<GetVerifiedReelsBloc>().add(SetAndGetReel(r));
          print("object {reel != null}");
          sl<CurrentReelCubit>().setCurrentReel(type: ReelTypes.homeLenta, reels: [r]);
          Go.to(
            Routes.reelScreen,
            argument: {"initialPosition": 0, "reelType": ReelTypes.homeLenta},
          );
        });
        break;

      case 'product':
        Go.to(Routes.publicProductDetailPage, argument: {"productId": int.parse(id)});

      case 'market':
        sl<GetMarketByIdCubit>().getStoreById(int.parse(id));
        Go.to(Routes.publicStoreDetail);

      case 'profile':
        sl<GetProfileCubit>().getPublicProfile(int.parse(id));
        Go.to(Routes.publicProfilePage);

      default:
        return;
    }
  }
}
