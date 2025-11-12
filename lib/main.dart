import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/features/reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import 'core/api.dart';
import 'core/injector.dart';
import 'features/auth/bloc/aut_bloc/auth_bloc.dart';
import 'features/auth/bloc/otp_cubit/otp_cubit.dart';
import 'features/auth/bloc/register_cubit/register_cubit.dart';
import 'features/home/bloc/get_profile_cubit/get_profile_cubit.dart';
import 'features/reels/blocs/current_reel_cubit/current_reel_cubit.dart';
import 'features/reels/blocs/file_upl_bloc/file_upl_bloc.dart';
import 'features/reels/blocs/reel_playin_queue_cubit/reel_playing_queue_cubit.dart';
import 'features/reels/blocs/reels_controllers_bloc/reels_controllers_bloc.dart';
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
        BlocProvider<FileUplBloc>(create: (context) => sl<FileUplBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}
