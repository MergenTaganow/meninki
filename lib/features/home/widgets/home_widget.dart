import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/features/store/bloc/get_stores_bloc/get_stores_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/helpers.dart';
import '../../banner/bloc/get_banners_bloc/get_banners_bloc.dart';
import '../../global/widgets/meninki_network_image.dart';
import '../../product/bloc/get_products_bloc/get_products_bloc.dart';
import '../../product/widgets/product_card.dart';
import '../../reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import '../../reels/blocs/reels_controllers_bloc/reels_controllers_bloc.dart';
import '../../reels/model/query.dart';
import '../../store/models/market.dart';
import 'home_adds.dart';
import 'home_lenta.dart';
import 'home_main.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
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
    super.build(context);
    return BlocListener<GetVerifiedReelsBloc, GetReelsState>(
      listener: (context, state) {
        if (state is GetReelSuccess) {
          context.read<ReelsControllersBloc>().add(NewReels(state.reels));
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customTabBar(),
          Expanded(
            child: TabBarView(
              // physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [HomeLenta(), HomeMain(), HomeAdd()],
            ),
          ),
        ],
      ),
    );
  }

  Container customTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = _tabController.index == index;

          return Expanded(
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                splashColor: Colors.black.withOpacity(0.15),
                highlightColor: Colors.black.withOpacity(0.05),
                onTap: () {
                  HapticFeedback.selectionClick();
                  _tabController.animateTo(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                  );
                },
                onLongPress: () {
                  if (index == 1) {
                    context.read<GetBannersBloc>().add(
                      BannerPag(Query(current_page: BannerPageTypes.home_main)),
                    );
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF0A0A0A) : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF8E8E8E),
                        fontWeight: FontWeight.w600,
                      ),
                      child: Text(tabs[index]),
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

  @override
  bool get wantKeepAlive => true;
}
