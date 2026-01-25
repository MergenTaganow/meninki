import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/features/home/widgets/favorite_adds_list.dart';
import 'package:meninki/features/product/bloc/get_products_bloc/get_products_bloc.dart';
import 'package:meninki/features/reels/model/query.dart';

import '../../../core/colors.dart';
import '../../adds/bloc/get_public_adds_bloc/get_adds_bloc.dart';
import '../../product/widgets/favorite_products_list.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    context.read<GetFavoriteProductsBloc>().add(GetProduct(Query(extraUrl: 'product-favorites')));
    // context.read<GetFavoriteProductsBloc>().add(GetProduct(Query()));
    context.read<GetFavoriteAddsBloc>().add(GetAdd(Query(extraUrl: 'saved-adds')));
    // context.read<GetFavoriteAddsBloc>().add(GetAdd(Query()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(lg.favorites)),
      body: Padd(
        hor: 8,
        ver: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ButtonsTabBar(
              // Customize the appearance and behavior of the tab bar
              controller: tabController,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Col.primary,
              ),
              unselectedDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Color(0xFFF3F3F3),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              buttonMargin: EdgeInsets.only(right: 8),
              labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
              unselectedLabelStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              // Add your tabs here
              tabs: [lg.products, lg.ads].map((e) => Tab(text: e)).toList(),
            ),
            Box(h: 10),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [FavoriteProductsList(), FavoriteAddsList()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
