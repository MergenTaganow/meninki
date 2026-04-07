import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/data/deep_link.dart';
import 'package:meninki/features/auth/pages/login_methods_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/go.dart';
import 'core/routes.dart';
import 'data/dynamic_localization.dart';
import 'features/auth/bloc/aut_bloc/auth_bloc.dart';
import 'features/auth/pages/splash_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'features/firebase_messaging/bloc/notification_tap/notification_tap_cubit.dart';
import 'features/firebase_messaging/notif_helper.dart';

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
  final appLinks = AppLinks();

  @override
  void initState() {
    DynamicLocalization.init(appLocale);
    getLang();
    initDeepLink();
    final sub = appLinks.uriLinkStream.listen((uri) {
      DeepLink().handleNavigation(uri);
    });
    // checkForUpdate();
    super.initState();
  }

  initDeepLink() async {
    final initialUri = await appLinks.getInitialLink();
    if (initialUri == null) return;
    DeepLink().handleNavigation(initialUri);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Go.popUntil();
                Go.too(Routes.homePage);
              });
            }
          },
        ),
        // this is for: notification on tap
        BlocListener<NotificationTapCubit, NotificationTapState>(
          listener: (context, state) {
            if (state is NotificationTapSuccess) {
              NotifHelper.onTap(context: context, notif: state.notification);
            }

            if (state is NotificationOnMessage) {
              // NotifHelper.actionOnMessage(
              //   context: context,
              //   messData: state.messageData,
              // );
            }
          },
        ),
      ],
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
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            titleTextStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        navigatorKey: Routes.mainNavKey,
        onGenerateRoute: Routes.onGenerateRoute,
        supportedLocales: [Locale('tr'), Locale('ru'), Locale('en')],
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        // scrollBehavior: MyScrollBehavior(),
        locale: appLocale,
        home: SafeArea(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthFailed) {
                return LoginMethodsScreen();
              }
              return SplashScreen();
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
    DynamicLocalization.init(locale);
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

class MyScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}
