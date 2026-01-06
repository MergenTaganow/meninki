import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/features/store/bloc/get_stores_bloc/get_stores_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/helpers.dart';
import '../../global/widgets/meninki_network_image.dart';
import '../../product/bloc/get_products_bloc/get_products_bloc.dart';
import '../../product/widgets/product_card.dart';
import '../../reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import '../../reels/blocs/reels_controllers_bloc/reels_controllers_bloc.dart';
import '../../store/models/market.dart';
import 'home_adds.dart';
import 'home_lenta.dart';
import 'home_main.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> tabs = ['Лента', 'Главная', 'Объявления'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetReelsBloc, GetReelsState>(
      listener: (context, state) {
        if (state is GetReelSuccess) {
          context.read<ReelsControllersBloc>().add(NewReels(state.reels));
        }
      },
      child: Padd(
        pad: 10,
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<GetReelsBloc>().add(GetReel());
            context.read<GetStoresBloc>().add(GetStores());
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customTabBar(),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [HomeLenta(), HomeMain(), HomeAdd()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container customTabBar() {
    return Container(
      decoration: BoxDecoration(color: Color(0xFFF3F3F3), borderRadius: BorderRadius.circular(24)),
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(tabs.length, (index) {
          final isSelected = _tabController.index == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => _tabController.animateTo(index),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFF0A0A0A) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Color(0xFF8E8E8E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
