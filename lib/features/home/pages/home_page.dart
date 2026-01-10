import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/features/home/widgets/home_widget.dart';
import 'package:meninki/features/product/bloc/get_products_bloc/get_products_bloc.dart';
import 'package:meninki/features/store/bloc/get_stores_bloc/get_stores_bloc.dart';
import '../../reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/products_search.dart';
import '../widgets/profile_page_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    context.read<GetStoresBloc>().add(GetStores());
    context.read<GetProductsBloc>().add(GetProduct());
    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBFBFB),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: tabController,
              children: [HomeWidget(), ProductsSearch(), Container(), ProfilePageWidget()],
            ),
            BottomNavBar(tabController),
          ],
        ),
      ),
    );
  }
}
