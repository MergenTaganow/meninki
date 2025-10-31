import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/api.dart';
import 'core/injector.dart';
import 'features/auth/bloc/aut_bloc/auth_bloc.dart';
import 'features/auth/bloc/otp_cubit/otp_cubit.dart';
import 'features/auth/bloc/register_cubit/register_cubit.dart';
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
      ],
      child: const MyApp(),
    ),
  );
}
