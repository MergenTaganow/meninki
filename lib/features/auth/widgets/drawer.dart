import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/colors.dart';
import '../../../core/go.dart';
import '../../../core/helpers.dart';
import '../../../core/routes.dart';
import '../../../my_app.dart';
import '../bloc/aut_bloc/auth_bloc.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // AppLocalizations lg = AppLocalizations.of(context)!;
    var user = (context.read<AuthBloc>().state as AuthSuccess).user;
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        width: 287,
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
          bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
            // logout(),
            Divider(
              height: 1,
              color: Col.gray50,
              endIndent: 16,
              indent: 16,
            ),
            Padd(
              bot: 5,
              top: 2,
              right: 20,
              left: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "V $version",
                    style: TextStyle(
                      color: Col.gray50,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          ]),
          body: ListView(
            children: [
              SizedBox(
                height: 130,
                child: Padd(
                  hor: 24,
                  ver: 16,
                  child: Image.asset(
                    'assets/images/appLogo.png',
                    // fit: BoxFit.fill,
                  ),
                ),
              ),
              Divider(height: 2.5, color: Col.gray50),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Column(
                  children: [
                      drawerRo(
                        title: "lg.dashboard",
                        icon: '_scan',
                        onTap: () {
                          // if (Go.currentRoute == Routes.dashboard) {
                          //   Navigator.pop(context);
                          // } else {
                          //   context
                          //       .read<BooleanFilterCubit>()
                          //       .select(BooleanFilterCubit.dashboard_overDue, true);
                          //   Go.too(Routes.dashboard);
                          // }
                        },
                      ),
                    drawerRo(
                      title: "lg.orders",
                      icon: 'orders',
                      onTap: () {
                        // if (Go.currentRoute == Routes.ordersPage) {
                        //   Navigator.pop(context);
                        // } else {
                        //   context
                        //       .read<BooleanFilterCubit>()
                        //       .select(BooleanFilterCubit.dashboard_overDue, null);
                        //   Go.too(Routes.ordersPage);
                        // }
                      },
                    ),
                    drawerRo(
                      title: "lg.employee_kpi",
                      icon: 'employee_kpi',
                      onTap: () {
                        // if (Go.currentRoute == Routes.employeeKpiPage) {
                        //   Navigator.pop(context);
                        // } else {
                        //   Go.too(Routes.employeeKpiPage);
                        // }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget logout() {
  //   return BlocBuilder<AuthBloc, AuthState>(
  //     builder: (context, state) {
  //       if (state is AuthSuccess) {
  //         return Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Row(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: [
  //                       Padd(
  //                         right: 5,
  //                         child: Icon(
  //                           Icons.supervised_user_circle_rounded,
  //                           color: Col.black.withOpacity(.7),
  //                         ),
  //                       ),
  //                       if (state.user.fullName?.isNotEmpty ?? false)
  //                         Text(
  //                           (state.user.fullName?.length ?? 0) > 18
  //                               ? state.user.fullName?.split(' ').length == 2
  //                                   ? '${state.user.fullName?.split(' ')[0] ?? ''} ${state.user.fullName?.split(' ')[1][0] ?? ''}'
  //                                   : state.user.fullName?.split(' ')[0] ?? ''
  //                               : state.user.fullName ?? '',
  //                           style: const TextStyle(fontSize: 16),
  //                         ),
  //                     ],
  //                   ),
  //                   GestureDetector(
  //                     onTap: () {
  //                       context.read<AuthBloc>().add(LogoutEvent());
  //                       Navigator.of(context).pop();
  //                       //This is to clear the static tab controller state
  //                       Go.too(Routes.loginMethodsScreen);
  //                     },
  //                     child: Container(
  //                       padding: const EdgeInsets.all(10.0),
  //                       child: Svvg.asset('logut'),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         );
  //       }
  //       return Container();
  //     },
  //   );
  // }

  Widget drawerRo({required String title, required String icon, void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        decoration: const BoxDecoration(color: Col.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Box(
                w: 38,
                h: 20,
                child: Svvg.asset(
                  icon,
                  color: Col.black.withOpacity(.7),
                ),
              ),
              const Box(w: 14),
              Text(
                title,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
