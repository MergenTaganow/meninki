import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:meninki/features/reels/blocs/current_reel_cubit/current_reel_cubit.dart';
import 'package:meninki/features/reels/blocs/get_reel_markets/get_reel_markets_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
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
  final ScrollController realMarketsScrollController = ScrollController();
  final ScrollController reelsScrollController = ScrollController();

  @override
  void initState() {
    context.read<SortCubit>().selectSort(
      key: SortCubit.reelsSearchSort,
      newSort: Sort(orderBy: 'created_at', orderDirection: "desc", text: "По дате - сначала новые"),
    );
    context.read<GetReelMarketsBloc>().add(GetReelMarkets(type: 'reel'));
    context.read<GetVerifiedReelsBloc>().add(GetReel());

    realMarketsScrollController.addListener(() {
      if (realMarketsScrollController.position.pixels ==
          realMarketsScrollController.position.maxScrollExtent) {
        context.read<GetReelMarketsBloc>().add(PaginateReelMarkets(type: 'reel'));
      }
    });

    reelsScrollController.addListener(() {
      if (reelsScrollController.position.pixels == reelsScrollController.position.maxScrollExtent) {
        context.read<GetVerifiedReelsBloc>().add(ReelPag());
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var selectedSort = context.watch<SortCubit>().sortMap[SortCubit.reelsSearchSort];
    final lg = AppLocalizations.of(context)!;

    return MultiBlocListener(
      listeners: [
        BlocListener<CurrentReelCubit, CurrentReelState>(
          listener: (context, state) {
            print("paginaion listener $state");
            if (state is PaginateReels) {
              print("paginaion checker ${state.reelType}");
            }
            if (state is PaginateReels && state.reelType == ReelTypes.homeLenta) {
              context.read<GetVerifiedReelsBloc>().add(ReelPag());
            }
          },
        ),
        BlocListener<GetVerifiedReelsBloc, GetReelsState>(
          listener: (context, state) {
            if (state is GetReelSuccess) {
              context.read<CurrentReelCubit>().paginationCame(
                type: ReelTypes.homeLenta,
                reels: state.reels,
              );
            }
          },
        ),
      ],
      child: CustomScrollView(
        controller: reelsScrollController,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
                                controller: realMarketsScrollController,
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
                              lg.reels,
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

                      final itemCount = isLoading ? 8 : reels.length;
                      // final isLoading = state is GetReelLoading;
                      // final itemCount = isLoading ? 6 : reels.length;

                      return Skeletonizer(
                        enabled: isLoading,
                        child: Column(
                          children: [
                            MasonryGridView.count(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 8,
                              itemCount: itemCount,
                              itemBuilder: (context, index) {
                                // Use dummy reel when loading to avoid index errors
                                final reel = isLoading ? Reel() : reels[index];
                                return ReelCard(
                                  reel: reel,
                                  allReels: reels,
                                  playingReels: true,
                                  reelType: ReelTypes.homeLenta,
                                );
                              },
                            ),
                            if (state is ReelPagLoading)
                              Padd(
                                ver: 10,
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          ],
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
