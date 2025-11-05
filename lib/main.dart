import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/features/reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import 'core/api.dart';
import 'core/injector.dart';
import 'features/auth/bloc/aut_bloc/auth_bloc.dart';
import 'features/auth/bloc/otp_cubit/otp_cubit.dart';
import 'features/auth/bloc/register_cubit/register_cubit.dart';
import 'features/reels/blocs/reel_playin_queue_cubit/reel_playing_queue_cubit.dart';
import 'features/reels/blocs/reels_controllers_bloc/reels_controllers_bloc.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  await getVersion();
  initBaseUrl();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => sl<AuthBloc>()..add(GetLocalUser())),
        BlocProvider<OtpCubit>(create: (context) => sl<OtpCubit>()),
        BlocProvider<RegisterCubit>(create: (context) => sl<RegisterCubit>()),
        BlocProvider<GetReelsBloc>(create: (context) => sl<GetReelsBloc>()),
        BlocProvider<ReelPlayingQueueCubit>(create: (context) => sl<ReelPlayingQueueCubit>()),
        BlocProvider<ReelsControllersBloc>(create: (context) => sl<ReelsControllersBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}
