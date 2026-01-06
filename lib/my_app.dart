import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/features/auth/pages/login_methods_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/go.dart';
import 'core/routes.dart';
import 'features/auth/bloc/aut_bloc/auth_bloc.dart';
import 'features/auth/pages/splash_screen.dart';

String version = '';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static Locale? appLocale = const Locale('tr');

  @override
  void initState() {
    // DynamicLocalization.init(appLocale);
    // getLang();
    checkForUpdate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Go.popUntil();
            Go.too(Routes.homePage);
          });
        }
      },
      child: MaterialApp(
        builder: (context, child) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: child!,
          );
        },
        theme: Theme.of(context).copyWith(
          scaffoldBackgroundColor: Color(0xFFFBFBFB),
          appBarTheme: AppBarTheme.of(context).copyWith(
            backgroundColor: Color(0xFFFBFBFB),
            titleTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,color: Colors.black),
          ),
        ),
        navigatorKey: Routes.mainNavKey,
        onGenerateRoute: Routes.onGenerateRoute,
        // supportedLocales: AppLocalizations.supportedLocales,
        // localizationsDelegates: AppLocalizations.localizationsDelegates,
        locale: appLocale,
        home: SafeArea(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return SplashScreen();
              }
              return LoginMethodsScreen();
            },
          ),
        ),
      ),
    );
  }

  setLocale(Locale locale) async {
    setState(() {
      appLocale = locale;
    });
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    final SharedPreferences prefes = await prefs;
    prefes.setString('lang', locale.languageCode);
    // DynamicLocalization.init(locale);
  }

  getLang() async {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    final SharedPreferences prefes = await prefs;
    if (prefes.containsKey('lang')) {
      var ll = prefes.getString('lang');
      if (ll != null) {
        setState(() {
          appLocale = Locale(ll);
        });
      }
    }
  }

  void checkForUpdate() async {
    // try {
    //   AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
    //
    //   if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
    //     if (updateInfo.immediateUpdateAllowed) {
    //       // Start an immediate update (forces update)
    //       InAppUpdate.performImmediateUpdate();
    //     } else if (updateInfo.flexibleUpdateAllowed) {
    //       // Start a flexible update (user can continue using the app)
    //       InAppUpdate.startFlexibleUpdate().then((_) {
    //         InAppUpdate.completeFlexibleUpdate();
    //       });
    //     }
    //   }
    // } catch (e) {}
  }
}

getVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  version = packageInfo.version;
}
