import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/colors.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/global/widgets/images_back_button.dart';
import 'package:meninki/features/global/widgets/meninki_network_image.dart';
import 'package:meninki/features/reels/model/query.dart';
import 'package:meninki/features/store/bloc/get_market_by_id/get_market_by_id_cubit.dart';
import 'package:meninki/features/store/widgets/store_background_color_selection.dart';
import '../../home/widgets/store_reels_list.dart';
import '../../product/bloc/get_products_bloc/get_products_bloc.dart';
import '../../product/pages/product_search_filter_page.dart';
import '../../product/widgets/products_list.dart';
import '../../reels/blocs/get_reels_bloc/get_reels_bloc.dart';

class MyStoreDetail extends StatefulWidget {
  const MyStoreDetail({super.key});

  @override
  State<MyStoreDetail> createState() => _MyStoreDetailState();
}

class _MyStoreDetailState extends State<MyStoreDetail> with SingleTickerProviderStateMixin {
  late TabController tabController;
  MarketColorScheme scheme = MarketColorScheme.fromBackground(Colors.white);

  @override
  void initState() {
    clearProductSearchFilters();
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void deactivate() {
    context.read<GetMarketByIdCubit>().clear();
    context.read<GetOneStoresProducts>().add(ClearProducts());
    context.read<GetStoreReelsBloc>().add(ClearReels());
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scheme.bgMain,
      body: BlocConsumer<GetMarketByIdCubit, GetMarketByIdState>(
        listener: (BuildContext context, GetMarketByIdState state) {
          if (state is GetMarketByIdSuccess) {
            context.read<GetOneStoresProducts>().add(
              GetProduct(Query(market_ids: [state.market.id])),
            );
            context.read<GetStoreReelsBloc>().add(GetReel(Query(market_id: state.market.id)));
            scheme = MarketColorScheme.fromBackground(
              state.market.profile_color ?? Color(0xFFAFA8B4),
            );
            setState(() {});
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
            return RefreshIndicator(
              notificationPredicate: (notification) {
                // with NestedScrollView local(depth == 2) OverscrollNotification are not sent
                return notification.depth == 2;
              },
              onRefresh: () async {
                context.read<GetMarketByIdCubit>().getStoreById(state.market.id);
              },
              child: NestedScrollView(
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
                                ImagesBackButton(),
                              ],
                            ),
                          Container(
                            color: scheme.bgSecondary,
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
                                        state.market.name.trans(context),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: scheme.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(14),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(14),
                                    splashColor: Colors.white.withOpacity(0.22),
                                    highlightColor: Colors.white.withOpacity(0.10),
                                    onTap: () {
                                      HapticFeedback.mediumImpact();
                                      Future.delayed(const Duration(milliseconds: 120), () {
                                        Go.to(
                                          Routes.productCreate,
                                          argument: {'storeId': state.market.id},
                                        );
                                      });
                                    },
                                    child: Ink(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: scheme.button,
                                      ),
                                      child: const Center(
                                        child: Icon(Icons.add_circle, color: Colors.white),
                                      ),
                                    ),
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
                                              Text(
                                                "Подписчики",
                                                style: TextStyle(color: scheme.textSecondary),
                                              ),
                                              Text(
                                                state.market.user_favorite_count.toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                  color: scheme.textPrimary,
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
                                              Text(
                                                "Место в рейтинге",
                                                style: TextStyle(color: scheme.textSecondary),
                                              ),
                                              Text(
                                                state.market.rate_count.toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                  color: scheme.textPrimary,
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
                      backgroundColor: scheme.bgMain,
                      titleSpacing: 0,
                      title: Row(
                        children: [
                          Padd(
                            hor: 10,
                            child: ButtonsTabBar(
                              // Customize the appearance and behavior of the tab bar
                              controller: tabController,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: scheme.button,
                              ),
                              unselectedDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: scheme.cardBackground,
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                              buttonMargin: EdgeInsets.only(right: 8),
                              labelStyle: TextStyle(
                                color: scheme.buttonText,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                              unselectedLabelStyle: TextStyle(
                                color: scheme.textPrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                              // Add your tabs here
                              tabs:
                                  ["Обзоры", "Товары"]
                                      .map(
                                        (e) => Tab(
                                          text:
                                              "$e • ${e == 'Обзоры' ? state.market.reel_verified_count : state.market.product_verified_count}",
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
                body: Padd(
                  hor: 10,
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      StoreReelsList(query: Query(market_id: state.market.id), scheme: scheme),
                      StoreProductsList(
                        query: Query(market_ids: [state.market.id]),
                        scheme: scheme,
                      ),
                    ],
                  ),
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
        Text(title, style: TextStyle(fontSize: 12, color: scheme.textSecondary)),
        Text(value, style: TextStyle(color: scheme.textPrimary)),
        Box(h: 12),
      ],
    );
  }

  Widget card({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: scheme.cardBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
