import 'package:get_it/get_it.dart';
import 'package:meninki/features/auth/bloc/otp_cubit/otp_cubit.dart';
import 'package:meninki/features/reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import 'package:meninki/features/store/bloc/store_create_cubit/store_create_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/auth/bloc/aut_bloc/auth_bloc.dart';
import '../features/auth/bloc/register_cubit/register_cubit.dart';
import '../features/auth/data/auth_remote_data_source.dart';
import '../features/auth/data/employee_local_data_source.dart';
import '../features/home/bloc/get_profile_cubit/get_profile_cubit.dart';
import '../features/reels/blocs/current_reel_cubit/current_reel_cubit.dart';
import '../features/reels/blocs/file_upl_bloc/file_upl_bloc.dart';
import '../features/reels/blocs/reel_playin_queue_cubit/reel_playing_queue_cubit.dart';
import '../features/reels/blocs/reels_controllers_bloc/reels_controllers_bloc.dart';
import '../features/reels/data/reels_remote_data_source.dart';
import '../features/store/data/store_remote_data_source.dart';
import 'api.dart';

GetIt sl = GetIt.instance;
Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton<EmployeeLocalDataSource>(() => EmployeeLocalDataSourceImpl(pref: sl()));
  sl.registerLazySingleton<Api>(() => Api(sl())..initApiClient());

  //auth
  sl.registerLazySingleton<AuthBloc>(() => AuthBloc(sl(), sl()));
  sl.registerLazySingleton<OtpCubit>(() => OtpCubit(sl()));
  sl.registerLazySingleton<RegisterCubit>(() => RegisterCubit(sl()));
  sl.registerLazySingleton<GetProfileCubit>(() => GetProfileCubit(sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataImpl(sl(), sl()));

  //reels
  sl.registerLazySingleton<ReelsRemoteDataSource>(() => ReelsRemoteDataImpl(sl()));
  sl.registerLazySingleton<GetReelsBloc>(() => GetReelsBloc(sl()));
  sl.registerLazySingleton<ReelPlayingQueueCubit>(() => ReelPlayingQueueCubit());
  sl.registerLazySingleton<ReelsControllersBloc>(() => ReelsControllersBloc());
  sl.registerLazySingleton<CurrentReelCubit>(() => CurrentReelCubit());

  //store
  sl.registerLazySingleton<StoreRemoteDataSource>(() => StoreRemoteDataImpl(sl()));
  sl.registerLazySingleton<StoreCreateCubit>(() => StoreCreateCubit(sl()));

  //file
  sl.registerLazySingleton<FileUplBloc>(() => FileUplBloc(sl()));
}
