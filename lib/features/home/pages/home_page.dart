import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/features/global/widgets/custom_snack_bar.dart';
import 'package:meninki/features/home/widgets/home_widget.dart';
import 'package:meninki/features/reels/blocs/reel_create_cubit/reel_create_cubit.dart';
import 'package:meninki/features/store/bloc/get_stores_bloc/get_stores_bloc.dart';
import '../../../core/helpers.dart';
import '../../adds/bloc/add_favorite_cubit/add_favorite_cubit.dart';
import '../../basket/bloc/my_basket_cubit/my_basket_cubit.dart';
import '../../basket/pages/basket_page.dart';
import '../../product/bloc/product_favorites_cubit/product_favorites_cubit.dart';
import '../../store/bloc/market_favorites_cubit/market_favorites_cubit.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/profile_page_widget.dart';
import '../widgets/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController tabController;
  DateTime? _lastBackPress;

  @override
  void initState() {
    context.read<GetStoresBloc>().add(GetStores());
    context.read<MyBasketCubit>().getMyBasketProductIds();
    context.read<MarketFavoritesCubit>().init();
    context.read<ProductFavoritesCubit>().init();
    context.read<AddFavoriteCubit>().init();
    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<ReelCreateCubit, ReelCreateState>(
      listener: (context, state) {
        if (state is ReelRepostSuccess) {
          CustomSnackBar.showSnackBar(
            context: context,
            title: AppLocalizations.of(context)!.success,
            isError: false,
          );
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          if (tabController.index != 0) {
            setState(() {
              tabController.animateTo(0);
            });
            return false; // DO NOT pop route
          }
          final now = DateTime.now();
          if (_lastBackPress == null ||
              now.difference(_lastBackPress!) > const Duration(seconds: 2)) {
            _lastBackPress = now;
            showExitSnackbar(context);
            return false;
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: Color(0xFFFBFBFB),
          body: SafeArea(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: [HomeWidget(), SearchPage(), BasketPage(), ProfilePageWidget()],
                ),
                BottomNavBar(tabController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showExitSnackbar(BuildContext context) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: Colors.black87.withOpacity(0.8),
      elevation: 4,
      duration: const Duration(seconds: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Text(
        AppLocalizations.of(context)!.pressBackAgain,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white70, fontSize: 14),
      ),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar() // hide previous if showing
      ..showSnackBar(snackBar);
  }

  @override
  bool get wantKeepAlive => true;
}
