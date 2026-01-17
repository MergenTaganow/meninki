import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/banner/bloc/get_banners_bloc/get_banners_bloc.dart';
import 'package:meninki/features/global/model/name.dart';
import 'package:meninki/features/global/widgets/meninki_network_image.dart';
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
import '../../store/bloc/get_market_by_id/get_market_by_id_cubit.dart';
import '../../store/bloc/get_stores_bloc/get_stores_bloc.dart';
import '../../store/models/market.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> with AutomaticKeepAliveClientMixin {
  List<Market> stores = [];
  List<Market> storesProducts = [];
  ScrollController scrollController = ScrollController();

  ///Todo later need to change to discount orderby
  Query discountProductsQuery = Query(orderDirection: 'desc', orderBy: /*'discount'*/ 'price');

  @override
  void initState() {
    context.read<GetBannersBloc>().add(GetBanner(Query(current_page: BannerPageTypes.home_main)));
    context.read<GetDiscountProducts>().add(GetProduct());
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
    return RefreshIndicator(
      backgroundColor: Colors.white,
      onRefresh: () async {
        context.read<GetStoresBloc>().add(GetStores());
        context.read<GetDiscountProducts>().add(GetProduct());
        context.read<GetStoreProductsBloc>().add(GetProductStores());
        context.read<GetBannersBloc>().add(
          GetBanner(Query(current_page: BannerPageTypes.home_main)),
        );
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Box(h: 20),

            ///markets
            markets(),
            Box(h: 20),

            ///reklama
            BannersList(priority: 1),
            Box(h: 20),

            /// discount products
            products(),
            BannersList(priority: 2),
            Box(h: 20),

            ///marketProducts
            marketProducts(),
            Box(h: 80),
          ],
        ),
      ),
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
                  (_) => Market(id: 9999, name: Name()), // lightweight model or mock
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
                          Go.to(Routes.publicStoreDetail);
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
                                    isLoading
                                        ? 'Store name'
                                        : storesProducts[index].name.trans(context),
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                  ),
                                ],
                              ),
                              Text('все', style: TextStyle(fontSize: 14, color: Colors.blueAccent)),
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

  BlocBuilder<GetDiscountProducts, GetProductsState> products() {
    return BlocBuilder<GetDiscountProducts, GetProductsState>(
      builder: (context, state) {
        final isLoading = state is GetProductLoading;
        final products =
            state is GetProductSuccess
                ? state.products
                : List.generate(5, (_) => Product(id: 999, name: Name())); // 👈 fake model
        return Skeletonizer(
          enabled: isLoading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Скитки", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              Box(h: 10),
              SizedBox(
                height: 240,
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Padd(
                      left: index == 0 ? 10 : 0,
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
        );
      },
    );
  }

  BlocBuilder<GetStoresBloc, GetStoresState> markets() {
    return BlocBuilder<GetStoresBloc, GetStoresState>(
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
