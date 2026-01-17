import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/features/home/widgets/home_widget.dart';
import 'package:meninki/features/product/bloc/get_products_bloc/get_products_bloc.dart';
import 'package:meninki/features/store/bloc/get_stores_bloc/get_stores_bloc.dart';
import '../../reels/blocs/get_reels_bloc/get_reels_bloc.dart';
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
    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
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
                children: [HomeWidget(), SearchPage(), Container(), ProfilePageWidget()],
              ),
              BottomNavBar(tabController),
            ],
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
      content: const Text(
        "Press back again to exit",
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
