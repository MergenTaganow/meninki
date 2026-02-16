import 'dart:async';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/colors.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/features/global/widgets/images_back_button.dart';
import 'package:meninki/features/global/widgets/meninki_network_image.dart';
import 'package:meninki/features/reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import 'package:meninki/features/reels/model/query.dart';
import 'package:meninki/features/store/bloc/get_market_by_id/get_market_by_id_cubit.dart';
import 'package:meninki/features/store/models/market.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../home/widgets/store_reels_list.dart';
import '../../product/bloc/get_products_bloc/get_products_bloc.dart';
import '../../product/pages/product_search_filter_page.dart';
import '../../product/widgets/products_list.dart';
import '../bloc/market_favorites_cubit/market_favorites_cubit.dart';
import '../widgets/store_background_color_selection.dart';

class PublicStoreDetail extends StatefulWidget {
  final String? navigatedTab;

  const PublicStoreDetail({this.navigatedTab, super.key});

  @override
  State<PublicStoreDetail> createState() => _PublicStoreDetailState();
}

class _PublicStoreDetailState extends State<PublicStoreDetail> with SingleTickerProviderStateMixin {
  late TabController tabController;
  MarketColorScheme scheme = MarketColorScheme.fromBackground(Colors.white);
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    clearProductSearchFilters();
    tabController = TabController(length: 2, vsync: this);
    if (widget.navigatedTab == 'product') {
      tabController.animateTo(1, duration: Duration.zero);
    }
    _pageController = PageController();

    super.initState();
  }

  startTimer(Market market) {
    _timer?.cancel();
    _timer = null;

    if ((market.files?.length ?? 0) > 1) {
      _timer = Timer.periodic(const Duration(seconds: 5), (_) {
        if (!mounted) return;

        _currentPage = (_currentPage + 1) % market.files!.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    tabController.dispose();
    super.dispose();
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
            startTimer(state.market);
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
            var isFavorite = context.watch<MarketFavoritesCubit>().favoriteMarkets.contains(
              state.market.id,
            );

            return RefreshIndicator(
              onRefresh: () async {
                context.read<GetMarketByIdCubit>().getStoreById(state.market.id);
              },
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
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
                                child:
                                    (state.market.files?.isNotEmpty ?? false)
                                        ? PageView.builder(
                                          controller: _pageController,
                                          itemCount: state.market.files!.length,
                                          onPageChanged: (index) {
                                            _currentPage = index;
                                          },
                                          itemBuilder: (_, index) {
                                            return MeninkiNetworkImage(
                                              file: state.market.files![index],
                                              networkImageType: NetworkImageType.large,
                                              otherFiles: state.market.files,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        )
                                        : MeninkiNetworkImage(
                                          file: state.market.cover_image!,
                                          networkImageType: NetworkImageType.large,
                                          fit: BoxFit.cover,
                                        ),
                              ),
                              ImagesBackButton(),
                              favoriteMarket(state.market, isFavorite),

                              /// Page indicator
                              if (state.market.files?.isNotEmpty ?? false)
                                Positioned(
                                  bottom: 16,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: SmoothPageIndicator(
                                      controller: _pageController,
                                      count: state.market.files!.length,
                                      effect: SlideEffect(
                                        spacing: 6,
                                        radius: 4,
                                        dotWidth: 32,
                                        dotHeight: 3,
                                        paintStyle: PaintingStyle.fill,
                                        dotColor: Colors.white.withOpacity(0.35),
                                        activeDotColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
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
                                      state.market.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: scheme.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: scheme.button,
                                ),
                                child: Center(child: Svvg.asset('store_message')),
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
                              singleRow(
                                title: AppLocalizations.of(context)!.phone,
                                value: "+993 62 66 66 66 ",
                              ),
                              singleRow(
                                title: AppLocalizations.of(context)!.description,
                                value: state.market.description?.trans(context) ?? '',
                              ),
                              singleRow(
                                title: AppLocalizations.of(context)!.username,
                                value: state.market.username ?? '',
                              ),
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
                                              AppLocalizations.of(context)!.followers,
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
                                              AppLocalizations.of(context)!.rankPlace,
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
                    snap: true,
                    // optional but nice
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
                                            "${e == 'Обзоры' ? AppLocalizations.of(context)!.reviews : AppLocalizations.of(context)!.products} • ${e == 'Обзоры' ? state.market.reel_verified_count : state.market.product_verified_count}",
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SliverFillRemaining(
                    hasScrollBody: true,
                    child: Padd(
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
                ],
              ),
            );

            // return RefreshIndicator(
            //   notificationPredicate: (notification) {
            //     // with NestedScrollView local(depth == 2) OverscrollNotification are not sent
            //     return notification.depth == 2;
            //   },
            //   onRefresh: () async {
            //   },
            //   child: NestedScrollView(
            //     headerSliverBuilder: (context, innerBoxIsScrolled) {
            //       return [
            //       ];
            //     },
            //     body: ,
            //   ),
            // );
          }
          return Container();
        },
      ),
    );
  }

  Positioned favoriteMarket(Market market, bool isFavorite) {
    return Positioned(
      right: 16,
      top: 16,
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            context.read<MarketFavoritesCubit>().favoriteTapped(market.id);
          },
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isFavorite ? Col.primary : Color(0xFF000000).withOpacity(.6),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                child: Row(
                  children: [
                    Svvg.asset(isFavorite ? 'subcribed' : 'not_subcribed'),
                    Box(w: 4),
                    Text(
                      isFavorite
                          ? AppLocalizations.of(context)!.subscribed
                          : AppLocalizations.of(context)!.subscribe,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Box(w: 8),
              Icon(Icons.more_vert_outlined, color: Colors.white),
            ],
          ),
        ),
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
