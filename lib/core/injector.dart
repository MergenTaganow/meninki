import 'package:get_it/get_it.dart';
import 'package:meninki/features/auth/bloc/otp_cubit/otp_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/auth/bloc/aut_bloc/auth_bloc.dart';
import '../features/auth/bloc/register_cubit/register_cubit.dart';
import '../features/auth/data/auth_remote_data_source.dart';
import '../features/auth/data/employee_local_data_source.dart';
import 'api.dart';

GetIt sl = GetIt.instance;
Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton<Api>(() => Api()..initApiClient());
  sl.registerLazySingleton<EmployeeLocalDataSource>(() => EmployeeLocalDataSourceImpl(pref: sl()));

  //auth
  sl.registerLazySingleton<AuthBloc>(() => AuthBloc(sl(), sl()));
  sl.registerLazySingleton<OtpCubit>(() => OtpCubit(sl()));
  sl.registerLazySingleton<RegisterCubit>(() => RegisterCubit(sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataImpl(sl(), sl()));

}
