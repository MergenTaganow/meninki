import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/features/reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import 'core/injector.dart';
import 'features/auth/bloc/aut_bloc/auth_bloc.dart';
import 'features/auth/bloc/otp_cubit/otp_cubit.dart';
import 'features/auth/bloc/register_cubit/register_cubit.dart';
import 'features/categories/bloc/brand_selecting_cubit/brand_selecting_cubit.dart';
import 'features/categories/bloc/category_selecting_cubit/category_selecting_cubit.dart';
import 'features/categories/bloc/get_brands_bloc/get_brands_bloc.dart';
import 'features/categories/bloc/get_categories_cubit/get_categories_cubit.dart';
import 'features/global/blocs/key_filter_cubit/key_filter_cubit.dart';
import 'features/global/blocs/sort_cubit/sort_cubit.dart';
import 'features/home/bloc/get_profile_cubit/get_profile_cubit.dart';
import 'features/product/bloc/compositions_creating_cubit/compositions_creat_cubit.dart';
import 'features/product/bloc/compositions_send_cubit/compositions_send_cubit.dart';
import 'features/product/bloc/get_attributes_bloc/get_product_attributes_bloc.dart';
import 'features/product/bloc/get_parameters_bloc/get_product_parameters_bloc.dart';
import 'features/product/bloc/get_product_by_id/get_product_by_id_cubit.dart';
import 'features/product/bloc/get_products_bloc/get_products_bloc.dart';
import 'features/product/bloc/product_create_cubit/product_create_cubit.dart';
import 'features/province/blocks/get_provinces_bloc/get_provinces_cubit.dart';
import 'features/province/blocks/province_selecting_cubit/province_selecting_cubit.dart';
import 'features/reels/blocs/current_reel_cubit/current_reel_cubit.dart';
import 'features/reels/blocs/file_upl_bloc/file_upl_bloc.dart';
import 'features/reels/blocs/file_upl_cover_image_bloc/file_upl_cover_image_bloc.dart';
import 'features/reels/blocs/like_reels_cubit/liked_reels_cubit.dart';
import 'features/reels/blocs/reel_create_cubit/reel_create_cubit.dart';
import 'features/reels/blocs/reel_playin_queue_cubit/reel_playing_queue_cubit.dart';
import 'features/reels/blocs/reels_controllers_bloc/reels_controllers_bloc.dart';
import 'features/store/bloc/get_market_by_id/get_market_by_id_cubit.dart';
import 'features/store/bloc/get_store_products/get_store_products_bloc.dart';
import 'features/store/bloc/get_stores_bloc/get_stores_bloc.dart';
import 'features/store/bloc/store_create_cubit/store_create_cubit.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  await getVersion();
  // initBaseUrl();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => sl<AuthBloc>()..add(GetLocalUser())),
        BlocProvider<OtpCubit>(create: (context) => sl<OtpCubit>()),
        BlocProvider<RegisterCubit>(create: (context) => sl<RegisterCubit>()),
        BlocProvider<GetReelsBloc>(create: (context) => sl<GetReelsBloc>()),
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
      ],
      child: const MyApp(),
    ),
  );
}
