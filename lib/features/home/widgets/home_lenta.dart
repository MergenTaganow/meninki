import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:meninki/features/reels/blocs/get_reel_markets/get_reel_markets_bloc.dart';
import 'package:meninki/features/reels/blocs/reels_controllers_bloc/reels_controllers_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../core/go.dart';
import '../../../core/helpers.dart';
import '../../../core/routes.dart';
import '../../global/blocs/sort_cubit/sort_cubit.dart';
import '../../reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import '../../reels/model/meninki_file.dart';
import '../../reels/model/reels.dart';
import '../../reels/widgets/reel_card.dart';
import '../../store/widgets/store_card.dart';

class HomeLenta extends StatefulWidget {
  const HomeLenta({super.key});

  @override
  State<HomeLenta> createState() => _HomeLentaState();
}

class _HomeLentaState extends State<HomeLenta> with AutomaticKeepAliveClientMixin {
  // final visibilityKey = Key('reel_visibility_for_home_lenta_page');
  // bool reelsPlaying = true;

  @override
  void initState() {
    context.read<SortCubit>().selectSort(
      key: SortCubit.reelsSearchSort,
      newSort: Sort(orderBy: 'id', orderDirection: "desc", text: "По дате - сначала новые"),
    );
    context.read<GetReelMarketsBloc>().add(GetReelMarkets(type: 'reel'));
    context.read<GetVerifiedReelsBloc>().add(GetReel());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var selectedSort = context.watch<SortCubit>().sortMap[SortCubit.reelsSearchSort];

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            context.read<GetReelMarketsBloc>().refresh();
            await context.read<GetVerifiedReelsBloc>().refresh();
          },
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              Box(h: 20),
              BlocBuilder<GetReelMarketsBloc, GetReelMarketsState>(
                builder: (context, state) {
                  final isLoading = state is GetReelMarketsLoading;
                  final stores = state is GetReelMarketsSuccess ? state.reelMarkets : [];

                  final itemCount = isLoading ? 5 : stores.length;

                  return AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    firstCurve: Curves.easeOut,
                    secondCurve: Curves.easeIn,
                    sizeCurve: Curves.easeInOut,
                    crossFadeState:
                        (itemCount == 0) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                    secondChild: Container(),
                    firstChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 120,
                          child: Skeletonizer(
                            enabled: isLoading,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                // Use dummy store when loading to avoid index errors
                                final store = isLoading ? null : stores[index];
                                return Padd(
                                  left: index == 0 ? 10 : 0,
                                  child: ReelMarketCard(store: store),
                                );
                              },
                              separatorBuilder: (context, index) => Box(w: 8),
                              itemCount: itemCount,
                            ),
                          ),
                        ),
                        Box(h: 20),
                      ],
                    ),
                  );
                },
              ),

              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  Go.to(
                    Routes.reelsFilterPage,
                    argument: {
                      "onFilter": () {
                        context.read<GetVerifiedReelsBloc>().add(GetReel());
                      },
                    },
                  );
                },
                child: Padd(
                  hor: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Обзоры",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                          Row(
                            children: [
                              Svvg.asset("sort", size: 20, color: Color(0xFF969696)),
                              Text(
                                "${selectedSort?.text}",
                                style: TextStyle(color: Color(0xFF969696)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Svvg.asset("sort"),
                    ],
                  ),
                ),
              ),
              Box(h: 20),
              Padd(
                hor: 10,
                child: BlocBuilder<GetVerifiedReelsBloc, GetReelsState>(
                  builder: (context, state) {
                    final isLoading = state is GetReelLoading;
                    final reels = state is GetReelSuccess ? state.reels : <Reel>[];

                    final itemCount = isLoading ? 6 : reels.length;
                    // final isLoading = state is GetReelLoading;
                    // final itemCount = isLoading ? 6 : reels.length;

                    return Skeletonizer(
                      enabled: isLoading,
                      child: MasonryGridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 8,
                        itemCount: itemCount,
                        itemBuilder: (context, index) {
                          // Use dummy reel when loading to avoid index errors
                          final reel =
                              isLoading
                                  ? Reel(
                                    id: 999999999999999999,
                                    type: '',
                                    is_active: false,
                                    is_verified: false,
                                    user_id: 0,
                                    title: 'qwertyuiokjhgfds xhmhdtgsfad acsvdfhywqedsx  stgqd',
                                    file: MeninkiFile(id: 0, name: '', original_file: ''),
                                  )
                                  : reels[index];
                          return ReelCard(reel: reel, allReels: reels, playingReels: true);
                        },
                      ),
                    );
                  },
                ),
              ),
              Box(h: 100),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
