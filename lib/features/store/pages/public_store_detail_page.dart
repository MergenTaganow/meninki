import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:meninki/core/api.dart';
import 'package:meninki/core/colors.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/global/widgets/meninki_network_image.dart';
import 'package:meninki/features/reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import 'package:meninki/features/reels/model/query.dart';
import 'package:meninki/features/store/bloc/get_market_by_id/get_market_by_id_cubit.dart';

import '../../home/widgets/reels_list.dart';
import '../../home/widgets/store_reels_list.dart';
import '../../product/bloc/get_products_bloc/get_products_bloc.dart';
import '../../product/pages/product_search_filter_page.dart';
import '../../product/widgets/products_list.dart';

class PublicStoreDetail extends StatefulWidget {
  const PublicStoreDetail({super.key});

  @override
  State<PublicStoreDetail> createState() => _PublicStoreDetailState();
}

class _PublicStoreDetailState extends State<PublicStoreDetail> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    clearProductSearchFilters();
    tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBFBFB),
      body: BlocConsumer<GetMarketByIdCubit, GetMarketByIdState>(
        listener: (BuildContext context, GetMarketByIdState state) {
          if (state is GetMarketByIdSuccess) {
            context.read<GetOneStoresProducts>().add(
              GetProduct(Query(market_ids: [state.market.id])),
            );
            context.read<GetStoreReelsBloc>().add(GetReel(Query(market_ids: [state.market.id])));
          }
        },
        builder: (context, state) {
          if (state is GetMarketByIdLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is GetMarketByIdFailed) {
            return Center(child: Text(state.failure.message ?? 'error'));
          }
          if (state is GetMarketByIdSuccess) {
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  //store detail
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.market.cover_image != null)
                          Stack(
                            children: [
                              SizedBox(
                                height: 360,
                                width: double.infinity,
                                child: MeninkiNetworkImage(
                                  file: state.market.cover_image!,
                                  networkImageType: NetworkImageType.large,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padd(
                                  left: 30,
                                  top: 60,
                                  child: GestureDetector(
                                    onTap: () {
                                      Go.pop();
                                    },
                                    child: Icon(
                                      Icons.navigate_before,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(14),
                          child: Row(
                            children: [
                              if (state.market.cover_image != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: SizedBox(
                                    height: 45,
                                    width: 45,
                                    child: MeninkiNetworkImage(
                                      file: state.market.cover_image!,
                                      networkImageType: NetworkImageType.small,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              Box(w: 14),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.market.name,
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Go.to(
                                  //   Routes.productCreate,
                                  //   argument: {'storeId': state.market.id},
                                  // );
                                },
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Col.primary,
                                  ),
                                  child: Center(child: Svvg.asset('store_message')),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Box(h: 10),
                        Padd(
                          hor: 14,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              singleRow(title: "Телефон", value: "+993 62 66 66 66 "),
                              singleRow(title: "Описание", value: state.market.description ?? ''),
                              singleRow(title: "Юзернейм", value: state.market.username ?? ''),
                              Row(
                                children: [
                                  Expanded(
                                    child: card(
                                      child: Padd(
                                        ver: 10,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text("Подписчики"),
                                            Text(
                                              state.market.user_favorite_count.toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Box(w: 10),
                                  Expanded(
                                    child: card(
                                      child: Padd(
                                        ver: 10,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text("Место в рейтинге"),
                                            Text(
                                              state.market.rate_count.toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // reels-products tabs
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    snap: true, // optional but nice
                    automaticallyImplyLeading: false,
                    titleSpacing: 0,
                    title: Padd(
                      hor: 10,
                      child: Row(
                        children: List.generate(2, (index) {
                          return GestureDetector(
                            onTap: () {
                              tabController.animateTo(index);
                              setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    tabController.index == index ? Col.primary : Color(0xFFF3F3F3),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                              margin: EdgeInsets.only(right: 6),
                              child: Text(
                                "${index == 0 ? "Обзоры" : "Товары"} • ${index == 0 ? state.market.reel_verified_count : state.market.product_verified_count}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      tabController.index == index ? Col.white : Color(0xFF474747),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ];
              },
              body: Padd(
                hor: 10,
                child: TabBarView(
                  controller: tabController,
                  children: [
                    StoreReelsList(query: Query(market_ids: [state.market.id])),
                    StoreProductsList(query: Query(market_ids: [state.market.id])),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Column singleRow({required String title, required String value}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 12, color: Color(0xFF969696))),
        Text(value),
        Box(h: 12),
      ],
    );
  }

  Widget card({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFFF3F3F3)),
      ),
      child: child,
    );
  }
}
