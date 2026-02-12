import 'package:get_it/get_it.dart';
import 'package:meninki/features/adds/data/add_remote_data_source.dart';
import 'package:meninki/features/auth/bloc/otp_cubit/otp_cubit.dart';
import 'package:meninki/features/global/blocs/sort_cubit/sort_cubit.dart';
import 'package:meninki/features/reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import 'package:meninki/features/store/bloc/store_create_cubit/store_create_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/adds/bloc/add_create_cubit/add_create_cubit.dart';
import '../features/adds/bloc/add_favorite_cubit/add_favorite_cubit.dart';
import '../features/adds/bloc/add_uuid_cubit/add_uuid_cubit.dart';
import '../features/adds/bloc/get_public_adds_bloc/get_adds_bloc.dart';
import '../features/auth/bloc/aut_bloc/auth_bloc.dart';
import '../features/auth/bloc/register_cubit/register_cubit.dart';
import '../features/auth/data/auth_remote_data_source.dart';
import '../features/auth/data/employee_local_data_source.dart';
import '../features/banner/bloc/get_banners_bloc/get_banners_bloc.dart';
import '../features/basket/bloc/get_basket_cubit/get_basket_cubit.dart';
import '../features/basket/bloc/my_basket_cubit/my_basket_cubit.dart';
import '../features/basket/data/basket_remote_data_source.dart';
import '../features/categories/bloc/brand_selecting_cubit/brand_selecting_cubit.dart';
import '../features/categories/bloc/category_selecting_cubit/category_selecting_cubit.dart';
import '../features/categories/bloc/get_brands_bloc/get_brands_bloc.dart';
import '../features/categories/bloc/get_categories_cubit/get_categories_cubit.dart';
import '../features/comments/bloc/comment_action/comment_action_cubit.dart';
import '../features/comments/bloc/comment_by_id_cubit/comment_by_id_cubit.dart';
import '../features/comments/bloc/get_comments_bloc/get_comments_bloc.dart';
import '../features/comments/bloc/send_comment_cubit/send_comment_cubit.dart';
import '../features/file_download/bloc/file_download_bloc/file_download_bloc.dart';
import '../features/file_download/data/download_service.dart';
import '../features/global/blocs/key_filter_cubit/key_filter_cubit.dart';
import '../features/home/bloc/get_profile_cubit/get_profile_cubit.dart';
import '../features/home/bloc/tab_navigation_cubit/tab_navigation_cubit.dart';
import '../features/product/bloc/compositions_creating_cubit/compositions_creat_cubit.dart';
import '../features/product/bloc/compositions_send_cubit/compositions_send_cubit.dart';
import '../features/product/bloc/get_attributes_bloc/get_product_attributes_bloc.dart';
import '../features/product/bloc/get_parameters_bloc/get_product_parameters_bloc.dart';
import '../features/product/bloc/get_product_by_id/get_product_by_id_cubit.dart';
import '../features/product/bloc/get_products_bloc/get_products_bloc.dart';
import '../features/product/bloc/product_compositions_cubit/product_compositions_cubit.dart';
import '../features/product/bloc/product_create_cubit/product_create_cubit.dart';
import '../features/product/bloc/product_favorites_cubit/product_favorites_cubit.dart';
import '../features/product/data/product_remote_data_source.dart';
import '../features/province/blocks/get_provinces_bloc/get_provinces_cubit.dart';
import '../features/province/blocks/province_selecting_cubit/province_selecting_cubit.dart';
import '../features/reels/blocs/current_reel_cubit/current_reel_cubit.dart';
import '../features/reels/blocs/file_processing_cubit/file_processing_cubit.dart';
import '../features/reels/blocs/file_upl_bloc/file_upl_bloc.dart';
import '../features/reels/blocs/file_upl_cover_image_bloc/file_upl_cover_image_bloc.dart';
import '../features/reels/blocs/get_my_reels_bloc/get_my_reels_bloc.dart';
import '../features/reels/blocs/get_reel_markets/get_reel_markets_bloc.dart';
import '../features/reels/blocs/like_reels_cubit/liked_reels_cubit.dart';
import '../features/reels/blocs/reel_create_cubit/reel_create_cubit.dart';
import '../features/reels/blocs/reel_playin_queue_cubit/reel_playing_queue_cubit.dart';
import '../features/reels/blocs/reels_controllers_bloc/reels_controllers_bloc.dart';
import '../features/reels/data/reels_remote_data_source.dart';
import '../features/store/bloc/get_market_by_id/get_market_by_id_cubit.dart';
import '../features/store/bloc/get_my_stores_bloc/get_my_stores_bloc.dart';
import '../features/store/bloc/get_store_products/get_store_products_bloc.dart';
import '../features/store/bloc/get_stores_bloc/get_stores_bloc.dart';
import '../features/store/bloc/market_favorites_cubit/market_favorites_cubit.dart';
import '../features/store/data/store_remote_data_source.dart';
import 'api.dart';

GetIt sl = GetIt.instance;
Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton<EmployeeLocalDataSource>(() => EmployeeLocalDataSourceImpl(pref: sl()));
  sl.registerLazySingleton<Api>(() => Api(sl())..initApiClient());

  //global
  sl.registerLazySingleton<SortCubit>(() => SortCubit());
  sl.registerLazySingleton<KeyFilterCubit>(() => KeyFilterCubit());
  sl.registerLazySingleton<TabNavigationCubit>(() => TabNavigationCubit());

  //auth
  sl.registerLazySingleton<AuthBloc>(() => AuthBloc(sl(), sl()));
  sl.registerLazySingleton<OtpCubit>(() => OtpCubit(sl()));
  sl.registerLazySingleton<RegisterCubit>(() => RegisterCubit(sl()));
  sl.registerLazySingleton<GetProfileCubit>(() => GetProfileCubit(sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataImpl(sl(), sl()));

  //reels
  sl.registerLazySingleton<ReelsRemoteDataSource>(() => ReelsRemoteDataImpl(sl()));
  sl.registerLazySingleton<GetVerifiedReelsBloc>(() => GetVerifiedReelsBloc(sl()));
  sl.registerLazySingleton<GetMyReelsBloc>(() => GetMyReelsBloc(sl()));
  sl.registerLazySingleton<ReelPlayingQueueCubit>(() => ReelPlayingQueueCubit());
  sl.registerLazySingleton<ReelsControllersBloc>(() => ReelsControllersBloc());
  sl.registerLazySingleton<CurrentReelCubit>(() => CurrentReelCubit());
  sl.registerLazySingleton<LikedReelsCubit>(() => LikedReelsCubit(sl())..init());
  sl.registerLazySingleton<ReelCreateCubit>(() => ReelCreateCubit(sl()));
  sl.registerLazySingleton<GetProductReelsBloc>(() => GetProductReelsBloc(sl()));
  sl.registerLazySingleton<GetStoreReelsBloc>(() => GetStoreReelsBloc(sl()));
  sl.registerLazySingleton<GetSearchedReelsBloc>(() => GetSearchedReelsBloc(sl()));
  sl.registerLazySingleton<FileProcessingCubit>(() => FileProcessingCubit(sl()));
  sl.registerLazySingleton<GetReelMarketsBloc>(() => GetReelMarketsBloc(sl()));

  //store
  sl.registerLazySingleton<StoreRemoteDataSource>(() => StoreRemoteDataImpl(sl()));
  sl.registerLazySingleton<StoreCreateCubit>(() => StoreCreateCubit(sl()));
  sl.registerLazySingleton<GetMarketByIdCubit>(() => GetMarketByIdCubit(sl()));
  sl.registerLazySingleton<GetStoresBloc>(() => GetStoresBloc(sl()));
  sl.registerLazySingleton<GetMyStoresBloc>(() => GetMyStoresBloc(sl()));
  sl.registerLazySingleton<MarketFavoritesCubit>(() => MarketFavoritesCubit(sl()));
  sl.registerLazySingleton<GetStoreProductsSearch>(() => GetStoreProductsSearch(sl()));

  //file
  sl.registerLazySingleton<FileUplCoverImageBloc>(() => FileUplCoverImageBloc(sl()));
  sl.registerLazySingleton<FileUplBloc>(() => FileUplBloc(sl()));
  sl.registerLazySingleton<DownloadService>(() => DownloadService());
  sl.registerLazySingleton<FileDownloadBloc>(() => FileDownloadBloc(sl()));

  //product
  sl.registerLazySingleton<GetProductsBloc>(() => GetProductsBloc(sl()));
  sl.registerLazySingleton<GetCategoriesCubit>(() => GetCategoriesCubit(sl()));
  sl.registerLazySingleton<GetBrandsBloc>(() => GetBrandsBloc(sl()));
  sl.registerLazySingleton<CategorySelectingCubit>(() => CategorySelectingCubit());
  sl.registerLazySingleton<BrandSelectingCubit>(() => BrandSelectingCubit());
  sl.registerLazySingleton<ProductRemoteDataSource>(() => ProductRemoteDataImpl(sl()));
  sl.registerLazySingleton<ProductCreateCubit>(() => ProductCreateCubit(sl()));
  sl.registerLazySingleton<GetProductByIdCubit>(() => GetProductByIdCubit(sl()));
  sl.registerLazySingleton<GetProductParametersBloc>(() => GetProductParametersBloc(sl()));
  sl.registerLazySingleton<CompositionsCreatCubit>(() => CompositionsCreatCubit());
  sl.registerLazySingleton<GetProductAttributesBloc>(() => GetProductAttributesBloc(sl()));
  sl.registerLazySingleton<CompositionsSendCubit>(() => CompositionsSendCubit(sl()));
  sl.registerLazySingleton<GetStoreProductsBloc>(() => GetStoreProductsBloc(sl()));
  sl.registerLazySingleton<GetOneStoresProducts>(() => GetOneStoresProducts(sl()));
  sl.registerLazySingleton<GetDiscountProducts>(() => GetDiscountProducts(sl()));
  sl.registerLazySingleton<GetBannersBloc>(() => GetBannersBloc(sl()));
  sl.registerLazySingleton<GetNewProducts>(() => GetNewProducts(sl()));
  sl.registerLazySingleton<GetRaitedProducts>(() => GetRaitedProducts(sl()));
  sl.registerLazySingleton<ProductCompositionsCubit>(() => ProductCompositionsCubit());
  sl.registerLazySingleton<ProductFavoritesCubit>(() => ProductFavoritesCubit(sl()));
  sl.registerLazySingleton<GetFavoriteProductsBloc>(() => GetFavoriteProductsBloc(sl()));

  //province
  sl.registerLazySingleton<GetProvincesCubit>(() => GetProvincesCubit(sl()));
  sl.registerLazySingleton<ProvinceSelectingCubit>(() => ProvinceSelectingCubit());

  //comments
  sl.registerLazySingleton<GetCommentsBloc>(() => GetCommentsBloc(sl()));
  sl.registerLazySingleton<SendCommentCubit>(() => SendCommentCubit(sl()));
  sl.registerLazySingleton<CommentActionCubit>(() => CommentActionCubit());
  sl.registerLazySingleton<CommentByIdCubit>(() => CommentByIdCubit(sl()));

  // add
  sl.registerLazySingleton<AddRemoteDataSource>(() => AddRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AddCreateCubit>(() => AddCreateCubit(sl()));
  sl.registerLazySingleton<GetAddsBloc>(() => GetAddsBloc(sl()));
  sl.registerLazySingleton<AddUuidCubit>(() => AddUuidCubit(sl()));
  sl.registerLazySingleton<AddFavoriteCubit>(() => AddFavoriteCubit(sl()));
  sl.registerLazySingleton<GetMyAddsBloc>(() => GetMyAddsBloc(sl()));
  sl.registerLazySingleton<GetFavoriteAddsBloc>(() => GetFavoriteAddsBloc(sl()));

  //basket
  sl.registerLazySingleton<GetBasketCubit>(() => GetBasketCubit(sl()));
  sl.registerLazySingleton<MyBasketCubit>(() => MyBasketCubit(sl()));
  sl.registerLazySingleton<BasketRemoteDataSource>(() => BasketRemoteDataImpl(sl()));
}
