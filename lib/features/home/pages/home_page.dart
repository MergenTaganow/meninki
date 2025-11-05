import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:meninki/core/api.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/features/reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import 'package:meninki/features/reels/blocs/reel_playin_queue_cubit/reel_playing_queue_cubit.dart';
import 'package:meninki/features/reels/blocs/reels_controllers_bloc/reels_controllers_bloc.dart';
import 'package:meninki/features/reels/model/reels.dart';
import 'package:video_player/video_player.dart';

import '../../../core/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Reel> reels = [];

  final List<String> tabs = ['Лента', 'Главная', 'Объявления'];

  @override
  void initState() {
    super.initState();
    context.read<GetReelsBloc>().add(GetReel());
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
      child: Scaffold(
        bottomNavigationBar: Container(
          height: 65,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Color(0xFFEAEAEA), width: 2),
          ),
          padding: EdgeInsets.all(10),
          child: Row(
            children: List.generate(4, (index) {
              var icons = ['home', 'search', 'add_card', 'profile'];
              return Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF3F3F3)),
                child: Center(child: Svvg.asset(icons[index])),
              );
            }),
          ),
        ),
        body: SafeArea(
          child: Padd(
            pad: 10,
            child: Column(
              children: [
                customTabBar(),
                Expanded(
                  child: BlocBuilder<GetReelsBloc, GetReelsState>(
                    builder: (context, state) {
                      if (state is GetReelLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is GetReelSuccess) {
                        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                          setState(() {
                            reels = state.reels;
                          });
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
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

class ReelCard extends StatelessWidget {
  const ReelCard({super.key, required this.reel});

  final Reel reel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<ReelPlayingQueueCubit, ReelPlayingQueueState>(
          builder: (context, state) {
            if (state is ReelPlaying) {
              final controller = state.controllers[reel.id];
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 240,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey,
                  ),
                  child:
                      (controller?.value.isInitialized ?? false)
                          ? VideoPlayer(controller!)
                          : Center(child: CircularProgressIndicator()),
                ),
              );
            }
            return Container();
          },
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                reel.title ?? '',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Box(w: 10),
            Icon(Icons.more_horiz, color: Color(0xFF969696)),
          ],
        ),
      ],
    );
  }
}
