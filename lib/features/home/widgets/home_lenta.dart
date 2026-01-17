import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/routes.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/helpers.dart';
import '../../global/widgets/meninki_network_image.dart';
import '../../reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import '../../reels/model/meninki_file.dart';
import '../../reels/model/reels.dart';
import '../../reels/widgets/reel_card.dart';
import '../../store/bloc/get_market_by_id/get_market_by_id_cubit.dart';
import '../../store/bloc/get_stores_bloc/get_stores_bloc.dart';
import '../../store/models/market.dart';
import '../../store/widgets/store_card.dart';

class HomeLenta extends StatefulWidget {
  const HomeLenta({super.key});

  @override
  State<HomeLenta> createState() => _HomeLentaState();
}

class _HomeLentaState extends State<HomeLenta> with AutomaticKeepAliveClientMixin {
  List<Reel> reels = [];
  List<Market> stores = [];

  @override
  void initState() {
    context.read<GetVerifiedReelsBloc>().add(GetReel());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
      backgroundColor: Colors.white,
      onRefresh: () async {
        context.read<GetVerifiedReelsBloc>().add(GetReel());
        context.read<GetStoresBloc>().add(GetStores());
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Box(h: 20),
            BlocBuilder<GetStoresBloc, GetStoresState>(
              builder: (context, state) {
                if (state is GetStoresSuccess) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    if (mounted) {
                      setState(() {
                        stores = state.stores;
                      });
                    }
                  });
                }

                final isLoading = state is GetStoresLoading;
                final itemCount = isLoading ? 5 : stores.length;

                return Column(
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
                            return Padd(left: index == 0 ? 10 : 0, child: StoreCard(store: store));
                          },
                          separatorBuilder: (context, index) => Box(w: 8),
                          itemCount: itemCount,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            Box(h: 20),
            Padd(
              hor: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Обзоры", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                      Row(
                        children: [
                          Svvg.asset("sort", size: 20, color: Color(0xFF969696)),
                          Text(
                            "По дате - сначала новые",
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
            Box(h: 20),
            Padd(
              hor: 10,
              child: BlocBuilder<GetVerifiedReelsBloc, GetReelsState>(
                builder: (context, state) {
                  if (state is GetReelSuccess) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      if (mounted) {
                        setState(() {
                          reels = state.reels;
                        });
                      }
                    });
                  }
                  final isLoading = state is GetReelLoading;
                  final itemCount = isLoading ? 6 : reels.length;

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
                                  id: index,
                                  type: '',
                                  is_active: false,
                                  is_verified: false,
                                  user_id: 0,
                                  title: 'qwertyuiokjhgfds xhmhdtgsfad acsvdfhywqedsx  stgqd',
                                  file: MeninkiFile(id: 0, name: '', original_file: ''),
                                )
                                : reels[index];
                        return ReelCard(reel: reel, allReels: reels);
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
