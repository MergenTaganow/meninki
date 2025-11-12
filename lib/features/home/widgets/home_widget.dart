import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../core/colors.dart';
import '../../../core/helpers.dart';
import '../../reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import '../../reels/blocs/reels_controllers_bloc/reels_controllers_bloc.dart';
import '../../reels/model/reels.dart';
import '../../reels/widgets/reel_card.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Reel> reels = [];

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
        child: Column(
          children: [
            customTabBar(),
            Box(h: 20),
            Expanded(
              child: BlocBuilder<GetReelsBloc, GetReelsState>(
                builder: (context, state) {
                  if (state is GetReelLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is GetReelSuccess) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      if (mounted) {
                        setState(() {
                          reels = state.reels;
                        });
                      }
                    });
                  }

                  if (state is GetReelFailed) {
                    // return ErrorPage(
                    //   fl: state.fl,
                    //   onRefresh: () {
                    //     context.read<GetOrdersBloc>().add(RefreshLastOrders());
                    //   },
                    // );
                    return Text("error");
                  }

                  if (reels.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Svvg.asset('_emptyy'),
                        const Box(h: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Col.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                          onPressed: () {
                            context.read<GetReelsBloc>().add(GetReel());
                          },
                          child: SizedBox(
                            height: 45,
                            child: Center(
                              child: Padd(
                                hor: 10,
                                child: Text(
                                  "lg.tryAgain",
                                  style: const TextStyle(color: Colors.white, fontSize: 13),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return RefreshIndicator(
                    backgroundColor: Colors.white,
                    onRefresh: () async {
                      context.read<GetReelsBloc>().add(GetReel());
                    },
                    child: MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 8,
                      itemCount: reels.length,
                      itemBuilder: (context, index) {
                        return ReelCard(reel: reels[index]);
                      },
                    ),
                  );
                  // if (state is ReelPagLoading) const CircularProgressIndicator(),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container customTabBar() {
    return Container(
      decoration: BoxDecoration(color: Color(0xFFF0ECE1), borderRadius: BorderRadius.circular(24)),
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
                  color: isSelected ? Color(0xFF3B353F) : Colors.transparent,
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
