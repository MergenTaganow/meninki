import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:meninki/core/go.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/helpers.dart';
import '../../global/widgets/meninki_network_image.dart';
import '../../reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import '../../reels/model/meninki_file.dart';
import '../../reels/model/reels.dart';
import '../../reels/widgets/reel_card.dart';
import '../../store/bloc/get_stores_bloc/get_stores_bloc.dart';
import '../../store/models/market.dart';

class HomeLenta extends StatefulWidget {
  const HomeLenta({super.key});

  @override
  State<HomeLenta> createState() => _HomeLentaState();
}

class _HomeLentaState extends State<HomeLenta> {
  List<Reel> reels = [];
  List<Market> stores = [];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Colors.white,
      onRefresh: () async {
        context.read<GetReelsBloc>().add(GetReel());
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
                            return InkWell(
                              onTap: (){
                                // Go.to(store)
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 120,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child:
                                          (store?.cover_image != null)
                                              ? IgnorePointer(
                                                ignoring: true,
                                                child: MeninkiNetworkImage(
                                                  file: store!.cover_image!,
                                                  networkImageType: NetworkImageType.small,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                              : null,
                                    ),
                                    // image
                                    if (store?.cover_image != null)
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        // alignment: Alignment.topRight,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(40),
                                            color: Colors.white,
                                          ),
                                          margin: EdgeInsets.only(right: 6, top: 6),
                                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          child: Text(
                                            (store?.user_rate_count ?? 0).toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Обзоры", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    Row(
                      children: [
                        Svvg.asset("sort", size: 20, color: Color(0xFF969696)),
                        Text("По дате - сначала новые", style: TextStyle(color: Color(0xFF969696))),
                      ],
                    ),
                  ],
                ),
                Svvg.asset("sort"),
              ],
            ),
            Box(h: 20),
            BlocBuilder<GetReelsBloc, GetReelsState>(
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

                if (state is GetReelFailed) {
                  // return ErrorPage(
                  //   fl: state.fl,
                  //   onRefresh: () {
                  //     context.read<GetOrdersBloc>().add(RefreshLastOrders());
                  //   },
                  // );
                  return Text("error");
                }

                // if (reels.isEmpty) {
                //   return Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Svvg.asset('_emptyy'),
                //       const Box(h: 16),
                //       ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //           backgroundColor: Col.primary,
                //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                //         ),
                //         onPressed: () {
                //           context.read<GetReelsBloc>().add(GetReel());
                //         },
                //         child: SizedBox(
                //           height: 45,
                //           child: Center(
                //             child: Padd(
                //               hor: 10,
                //               child: Text(
                //                 "Повторить",
                //                 style: const TextStyle(color: Colors.white, fontSize: 13),
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   );
                // }

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
                      return ReelCard(reel: reel);
                    },
                  ),
                );
                // if (state is ReelPagLoading) const CircularProgressIndicator(),
              },
            ),
            Box(h: 100),
          ],
        ),
      ),
    );
  }
}
