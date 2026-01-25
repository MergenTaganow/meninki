import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:meninki/features/reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import 'core/injector.dart';
import 'features/adds/bloc/add_create_cubit/add_create_cubit.dart';
import 'features/adds/bloc/add_favorite_cubit/add_favorite_cubit.dart';
import 'features/adds/bloc/add_uuid_cubit/add_uuid_cubit.dart';
import 'features/adds/bloc/get_public_adds_bloc/get_adds_bloc.dart';
import 'features/auth/bloc/aut_bloc/auth_bloc.dart';
import 'features/auth/bloc/otp_cubit/otp_cubit.dart';
import 'features/auth/bloc/register_cubit/register_cubit.dart';
import 'features/banner/bloc/get_banners_bloc/get_banners_bloc.dart';
import 'features/basket/bloc/get_basket_cubit/get_basket_cubit.dart';
import 'features/basket/bloc/my_basket_cubit/my_basket_cubit.dart';
import 'features/categories/bloc/brand_selecting_cubit/brand_selecting_cubit.dart';
import 'features/categories/bloc/category_selecting_cubit/category_selecting_cubit.dart';
import 'features/categories/bloc/get_brands_bloc/get_brands_bloc.dart';
import 'features/categories/bloc/get_categories_cubit/get_categories_cubit.dart';
import 'features/comments/bloc/comment_action/comment_action_cubit.dart';
import 'features/comments/bloc/comment_by_id_cubit/comment_by_id_cubit.dart';
import 'features/comments/bloc/get_comments_bloc/get_comments_bloc.dart';
import 'features/comments/bloc/send_comment_cubit/send_comment_cubit.dart';
import 'features/file_download/bloc/file_download_bloc/file_download_bloc.dart';
import 'features/global/blocs/key_filter_cubit/key_filter_cubit.dart';
import 'features/global/blocs/sort_cubit/sort_cubit.dart';
import 'features/home/bloc/get_profile_cubit/get_profile_cubit.dart';
import 'features/product/bloc/compositions_creating_cubit/compositions_creat_cubit.dart';
import 'features/product/bloc/compositions_send_cubit/compositions_send_cubit.dart';
import 'features/product/bloc/get_attributes_bloc/get_product_attributes_bloc.dart';
import 'features/product/bloc/get_parameters_bloc/get_product_parameters_bloc.dart';
import 'features/product/bloc/get_product_by_id/get_product_by_id_cubit.dart';
import 'features/product/bloc/get_products_bloc/get_products_bloc.dart';
import 'features/product/bloc/product_compositions_cubit/product_compositions_cubit.dart';
import 'features/product/bloc/product_create_cubit/product_create_cubit.dart';
import 'features/product/bloc/product_favorites_cubit/product_favorites_cubit.dart';
import 'features/province/blocks/get_provinces_bloc/get_provinces_cubit.dart';
import 'features/province/blocks/province_selecting_cubit/province_selecting_cubit.dart';
import 'features/reels/blocs/current_reel_cubit/current_reel_cubit.dart';
import 'features/reels/blocs/file_processing_cubit/file_processing_cubit.dart';
import 'features/reels/blocs/file_upl_bloc/file_upl_bloc.dart';
import 'features/reels/blocs/file_upl_cover_image_bloc/file_upl_cover_image_bloc.dart';
import 'features/reels/blocs/get_my_reels_bloc/get_my_reels_bloc.dart';
import 'features/reels/blocs/get_reel_markets/get_reel_markets_bloc.dart';
import 'features/reels/blocs/like_reels_cubit/liked_reels_cubit.dart';
import 'features/reels/blocs/reel_create_cubit/reel_create_cubit.dart';
import 'features/reels/blocs/reel_playin_queue_cubit/reel_playing_queue_cubit.dart';
import 'features/reels/blocs/reels_controllers_bloc/reels_controllers_bloc.dart';
import 'features/store/bloc/get_market_by_id/get_market_by_id_cubit.dart';
import 'features/store/bloc/get_my_stores_bloc/get_my_stores_bloc.dart';
import 'features/store/bloc/get_store_products/get_store_products_bloc.dart';
import 'features/store/bloc/get_stores_bloc/get_stores_bloc.dart';
import 'features/store/bloc/market_favorites_cubit/market_favorites_cubit.dart';
import 'features/store/bloc/store_create_cubit/store_create_cubit.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize(
    debug: true, // optional: set to false to disable printing logs to console (default: true)
    ignoreSsl: true, // option: set to false to disable working with http links (default: false)
  );

  await init();
  await getVersion();
  // initBaseUrl();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => sl<AuthBloc>()..add(GetLocalUser())),
        BlocProvider<OtpCubit>(create: (context) => sl<OtpCubit>()),
        BlocProvider<RegisterCubit>(create: (context) => sl<RegisterCubit>()),
        BlocProvider<GetVerifiedReelsBloc>(create: (context) => sl<GetVerifiedReelsBloc>()),
        BlocProvider<ReelPlayingQueueCubit>(create: (context) => sl<ReelPlayingQueueCubit>()),
        BlocProvider<ReelsControllersBloc>(create: (context) => sl<ReelsControllersBloc>()),
        BlocProvider<GetProfileCubit>(create: (context) => sl<GetProfileCubit>()),
        BlocProvider<CurrentReelCubit>(create: (context) => sl<CurrentReelCubit>()),
        BlocProvider<StoreCreateCubit>(create: (context) => sl<StoreCreateCubit>()),
        BlocProvider<FileUplCoverImageBloc>(create: (context) => sl<FileUplCoverImageBloc>()),
        BlocProvider<GetMarketByIdCubit>(create: (context) => sl<GetMarketByIdCubit>()),
        BlocProvider<GetStoresBloc>(create: (context) => sl<GetStoresBloc>()),
        BlocProvider<LikedReelsCubit>(create: (context) => sl<LikedReelsCubit>()),
        BlocProvider<FileUplBloc>(create: (context) => sl<FileUplBloc>()),
        BlocProvider<GetCategoriesCubit>(create: (context) => sl<GetCategoriesCubit>()),
        BlocProvider<CategorySelectingCubit>(create: (context) => sl<CategorySelectingCubit>()),
        BlocProvider<ProductCreateCubit>(create: (context) => sl<ProductCreateCubit>()),
        BlocProvider<GetBrandsBloc>(create: (context) => sl<GetBrandsBloc>()),
        BlocProvider<BrandSelectingCubit>(create: (context) => sl<BrandSelectingCubit>()),
        BlocProvider<GetProductByIdCubit>(create: (context) => sl<GetProductByIdCubit>()),
        BlocProvider<GetProductParametersBloc>(create: (context) => sl<GetProductParametersBloc>()),
        BlocProvider<CompositionsCreatCubit>(create: (context) => sl<CompositionsCreatCubit>()),
        BlocProvider<GetProductAttributesBloc>(create: (context) => sl<GetProductAttributesBloc>()),
        BlocProvider<CompositionsSendCubit>(create: (context) => sl<CompositionsSendCubit>()),
        BlocProvider<ReelCreateCubit>(create: (context) => sl<ReelCreateCubit>()),
        BlocProvider<GetProductsBloc>(create: (context) => sl<GetProductsBloc>()),
        BlocProvider<GetStoreProductsBloc>(create: (context) => sl<GetStoreProductsBloc>()),
        BlocProvider<SortCubit>(create: (context) => sl<SortCubit>()),
        BlocProvider<GetProvincesCubit>(create: (context) => sl<GetProvincesCubit>()),
        BlocProvider<ProvinceSelectingCubit>(create: (context) => sl<ProvinceSelectingCubit>()),
        BlocProvider<KeyFilterCubit>(create: (context) => sl<KeyFilterCubit>()),
        BlocProvider<GetCommentsBloc>(create: (context) => sl<GetCommentsBloc>()),
        BlocProvider<SendCommentCubit>(create: (context) => sl<SendCommentCubit>()),
        BlocProvider<CommentActionCubit>(create: (context) => sl<CommentActionCubit>()),
        BlocProvider<CommentByIdCubit>(create: (context) => sl<CommentByIdCubit>()),
        BlocProvider<GetMyReelsBloc>(create: (context) => sl<GetMyReelsBloc>()),
        BlocProvider<GetProductReelsBloc>(create: (context) => sl<GetProductReelsBloc>()),
        BlocProvider<GetStoreReelsBloc>(create: (context) => sl<GetStoreReelsBloc>()),
        BlocProvider<GetOneStoresProducts>(create: (context) => sl<GetOneStoresProducts>()),
        BlocProvider<GetDiscountProducts>(create: (context) => sl<GetDiscountProducts>()),
        BlocProvider<GetBannersBloc>(create: (context) => sl<GetBannersBloc>()),
        BlocProvider<GetSearchedReelsBloc>(create: (context) => sl<GetSearchedReelsBloc>()),
        BlocProvider<FileProcessingCubit>(create: (context) => sl<FileProcessingCubit>()),
        BlocProvider<AddCreateCubit>(create: (context) => sl<AddCreateCubit>()),
        BlocProvider<GetAddsBloc>(create: (context) => sl<GetAddsBloc>()),
        BlocProvider<GetReelMarketsBloc>(create: (context) => sl<GetReelMarketsBloc>()),
        BlocProvider<GetRaitedProducts>(create: (context) => sl<GetRaitedProducts>()),
        BlocProvider<GetNewProducts>(create: (context) => sl<GetNewProducts>()),
        BlocProvider<ProductCompositionsCubit>(create: (context) => sl<ProductCompositionsCubit>()),
        BlocProvider<MyBasketCubit>(create: (context) => sl<MyBasketCubit>()),
        BlocProvider<GetBasketCubit>(create: (context) => sl<GetBasketCubit>()),
        BlocProvider<AddUuidCubit>(create: (context) => sl<AddUuidCubit>()),
        BlocProvider<GetMyStoresBloc>(create: (context) => sl<GetMyStoresBloc>()),
        BlocProvider<MarketFavoritesCubit>(create: (context) => sl<MarketFavoritesCubit>()),
        BlocProvider<FileDownloadBloc>(create: (context) => sl<FileDownloadBloc>()),
        BlocProvider<GetStoreProductsSearch>(create: (context) => sl<GetStoreProductsSearch>()),
        BlocProvider<ProductFavoritesCubit>(create: (context) => sl<ProductFavoritesCubit>()),
        BlocProvider<AddFavoriteCubit>(create: (context) => sl<AddFavoriteCubit>()),
        BlocProvider<GetMyAddsBloc>(create: (context) => sl<GetMyAddsBloc>()),
        BlocProvider<GetFavoriteProductsBloc>(create: (context) => sl<GetFavoriteProductsBloc>()),
        BlocProvider<GetFavoriteAddsBloc>(create: (context) => sl<GetFavoriteAddsBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}
