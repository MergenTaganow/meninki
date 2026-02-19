import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/banner/bloc/get_banners_bloc/get_banners_bloc.dart';
import 'package:meninki/features/global/blocs/sort_cubit/sort_cubit.dart';
import 'package:meninki/features/global/model/name.dart';
import 'package:meninki/features/global/widgets/meninki_network_image.dart';
import 'package:meninki/features/home/bloc/tab_navigation_cubit/tab_navigation_cubit.dart';
import 'package:meninki/features/reels/model/query.dart';
import 'package:meninki/features/store/bloc/get_store_products/get_store_products_bloc.dart';
import 'package:meninki/features/store/widgets/store_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/colors.dart';
import '../../../core/helpers.dart';
import '../../banner/widgets/banner_list.dart';
import '../../product/bloc/get_products_bloc/get_products_bloc.dart';
import '../../product/models/product.dart';
import '../../product/widgets/product_card.dart';
import '../../reels/blocs/get_reel_markets/get_reel_markets_bloc.dart';
import '../../store/bloc/get_market_by_id/get_market_by_id_cubit.dart';
import '../../store/models/market.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> with AutomaticKeepAliveClientMixin {
  List<ReelMarket> stores = [];
  List<Market> storesProducts = [];
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    context.read<GetProductMarketsBloc>().add(GetReelMarkets(type: 'product'));
    context.read<GetBannersBloc>().add(GetBanner(Query(current_page: BannerPageTypes.home_main)));

    context.read<GetDiscountProducts>().add(
      GetProduct(Query(orderDirection: 'desc', orderBy: 'discount')),
    );
    context.read<GetNewProducts>().add(GetProduct(Query(orderBy: 'id', orderDirection: 'desc')));
    context.read<GetRaitedProducts>().add(
      GetProduct(Query(/*orderBy: 'rate', orderDirection: 'desc'*/)),
    );
    context.read<GetStoreProductsBloc>().add(GetProductStores());
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        context.read<GetStoreProductsBloc>().add(PaginateProductStores());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            context.read<GetProductMarketsBloc>().refresh();

            context.read<GetDiscountProducts>().refresh();

            context.read<GetRaitedProducts>().refresh();
            context.read<GetStoreProductsBloc>().refresh();
            context.read<GetBannersBloc>().refresh();
            await context.read<GetNewProducts>().refresh();
          },
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              Box(h: 20),

              ///markets
              markets(),

              ///reklama
              BannersList(priority: 1),
              Box(h: 20),

              /// discount products
              products(),
              Box(h: 20),

              ///marketProducts
              marketProducts(),
              Box(h: 80),
            ],
          ),
        ),
      ],
    );
  }

  BlocBuilder<GetStoreProductsBloc, GetStoreProductsState> marketProducts() {
    return BlocBuilder<GetStoreProductsBloc, GetStoreProductsState>(
      builder: (context, state) {
        if (state is GetProductStoresSuccess) {
          storesProducts = state.stores;
        }
        final isLoading = state is GetProductStoresLoading;

        storesProducts =
            isLoading
                ? List.generate(
                  3,
                  (_) => Market(id: 9999, name: ''), // lightweight model or mock
                )
                : storesProducts;
        return Skeletonizer(
          enabled: isLoading,
          effect: ShimmerEffect(
            baseColor: const Color(0xFFEAEAEA),
            highlightColor: const Color(0xFFF5F5F5),
          ),
          child: Padd(
            hor: 10,
            child: ListView.separated(
              itemCount: storesProducts.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  constraints: BoxConstraints(maxHeight: 292),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFFF3F3F3), width: 1),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.read<GetMarketByIdCubit>().getStoreById(storesProducts[index].id);
                          Go.to(Routes.publicStoreDetail, argument: {'navigatedTab': 'product'});
                        },
                        child: Padd(
                          hor: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Container(
                                      height: 28,
                                      width: 28,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Col.primary,
                                      ),
                                      child:
                                          storesProducts[index].cover_image != null
                                              ? IgnorePointer(
                                                ignoring: true,
                                                child: MeninkiNetworkImage(
                                                  file: storesProducts[index].cover_image!,
                                                  networkImageType: NetworkImageType.small,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                              : null,
                                    ),
                                  ),
                                  Box(w: 10),
                                  Text(
                                    isLoading ? 'Store name' : storesProducts[index].name,
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                  ),
                                ],
                              ),
                              Icon(Icons.navigate_next),
                            ],
                          ),
                        ),
                      ),
                      Box(h: 10),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 232),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: isLoading ? 3 : storesProducts[index].products?.length ?? 0,
                          itemBuilder: (context, productIndex) {
                            return Padd(
                              left: productIndex == 0 ? 10 : 0,
                              child: Skeletonizer(
                                enabled: isLoading,
                                child: ProductCard(
                                  product:
                                      storesProducts[index].products?[productIndex] ??
                                      Product(id: 9999, name: Name()),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => Box(w: 4),
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder:
                  (context, index) =>
                      index == 0 ? Padd(ver: 4, child: BannersList(priority: 3)) : Box(h: 20),
            ),
          ),
        );
      },
    );
  }

  Widget products() {
    AppLocalizations lg = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<GetNewProducts, GetProductsState>(
          builder: (context, state) {
            final isLoading = state is GetProductLoading;
            final products =
                state is GetProductSuccess
                    ? state.products
                    : List.generate(5, (_) => Product(id: 999, name: Name())); // 👈 fake model

            return AnimatedCrossFade(
              duration: const Duration(milliseconds: 380),
              firstCurve: Curves.easeOut,
              secondCurve: Curves.easeIn,
              sizeCurve: Curves.easeInOut,
              crossFadeState:
                  products.isNotEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              firstChild: Skeletonizer(
                enabled: isLoading,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.read<SortCubit>().selectSort(
                          key: SortCubit.productSearchSort,
                          newSort: Sort(orderBy: 'id', orderDirection: 'desc', text: lg.newItems),
                        );
                        context.read<GetProductsBloc>().add(GetProduct());
                        context.read<TabNavigationCubit>().homeToSearchProduct();
                      },
                      child: Padd(
                        hor: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              lg.newItems,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            Icon(Icons.navigate_next),
                          ],
                        ),
                      ),
                    ),
                    Box(h: 10),
                    SizedBox(
                      height: 240,
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return Padd(
                            left: index == 0 ? 10 : 0,
                            right: index == products.length - 1 ? 10 : 0,
                            child: ProductCard(product: products[index]),
                          );
                        },
                        itemCount: products.length,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (BuildContext context, int index) => Box(w: 4),
                      ),
                    ),
                  ],
                ),
              ),
              secondChild: Container(),
            );
          },
        ),
        BlocBuilder<GetRaitedProducts, GetProductsState>(
          builder: (context, state) {
            final isLoading = state is GetProductLoading;
            final products =
                state is GetProductSuccess
                    ? state.products
                    : List.generate(5, (_) => Product(id: 999, name: Name())); // 👈 fake model
            return AnimatedCrossFade(
              duration: const Duration(milliseconds: 380),
              firstCurve: Curves.easeOut,
              secondCurve: Curves.easeIn,
              sizeCurve: Curves.easeInOut,
              crossFadeState:
                  products.isNotEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              firstChild: Skeletonizer(
                enabled: isLoading,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.read<SortCubit>().selectSort(
                          key: SortCubit.productSearchSort,
                          newSort: Sort(orderBy: 'id', orderDirection: 'desc', text: lg.bestRated),
                        );
                        context.read<GetProductsBloc>().add(GetProduct());
                        context.read<TabNavigationCubit>().homeToSearchProduct();
                      },
                      child: Padd(
                        hor: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              lg.bestRated,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            Icon(Icons.navigate_next),
                          ],
                        ),
                      ),
                    ),

                    Box(h: 10),
                    SizedBox(
                      height: 240,
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return Padd(
                            left: index == 0 ? 10 : 0,
                            right: index == products.length - 1 ? 10 : 0,
                            child: ProductCard(product: products[index]),
                          );
                        },
                        itemCount: products.length,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (BuildContext context, int index) => Box(w: 4),
                      ),
                    ),
                  ],
                ),
              ),
              secondChild: Container(),
            );
          },
        ),
        BlocBuilder<GetDiscountProducts, GetProductsState>(
          builder: (context, state) {
            final isLoading = state is GetProductLoading;
            final products =
                state is GetProductSuccess
                    ? state.products
                    : List.generate(5, (_) => Product(id: 999, name: Name())); // 👈 fake model
            return AnimatedCrossFade(
              duration: const Duration(milliseconds: 380),
              firstCurve: Curves.easeOut,
              secondCurve: Curves.easeIn,
              sizeCurve: Curves.easeInOut,
              crossFadeState:
                  products.isNotEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              firstChild: Skeletonizer(
                enabled: isLoading,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.read<SortCubit>().selectSort(
                          key: SortCubit.productSearchSort,
                          newSort: Sort(
                            orderDirection: 'desc',
                            orderBy: 'discount',
                            text: lg.discounts,
                          ),
                        );
                        context.read<GetProductsBloc>().add(GetProduct(Query()));
                        context.read<TabNavigationCubit>().homeToSearchProduct();
                      },
                      child: Padd(
                        hor: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              lg.discounts,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            Icon(Icons.navigate_next),
                          ],
                        ),
                      ),
                    ),
                    Box(h: 10),
                    SizedBox(
                      height: 240,
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return Padd(
                            left: index == 0 ? 10 : 0,
                            right: index == products.length - 1 ? 10 : 0,
                            child: ProductCard(product: products[index]),
                          );
                        },
                        itemCount: products.length,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (BuildContext context, int index) => Box(w: 4),
                      ),
                    ),
                  ],
                ),
              ),
              secondChild: Container(),
            );
          },
        ),
      ],
    );
  }

  BlocBuilder<GetProductMarketsBloc, GetReelMarketsState> markets() {
    return BlocBuilder<GetProductMarketsBloc, GetReelMarketsState>(
      builder: (context, state) {
        if (state is GetReelMarketsSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            if (mounted) {
              setState(() {
                stores = state.reelMarkets;
              });
            }
          });
        }

        final isLoading = state is GetReelMarketsLoading;
        final itemCount = isLoading ? 5 : stores.length;
        return AnimatedCrossFade(
          duration: const Duration(milliseconds: 380),
          firstCurve: Curves.easeOut,
          secondCurve: Curves.easeIn,
          sizeCurve: Curves.easeInOut,
          crossFadeState: itemCount != 0 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
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
                      return Padd(left: index == 0 ? 10 : 0, child: ReelMarketCard(store: store));
                    },
                    separatorBuilder: (context, index) => Box(w: 8),
                    itemCount: itemCount,
                  ),
                ),
              ),
              Box(h: 20),
            ],
          ),
          secondChild: Container(),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
