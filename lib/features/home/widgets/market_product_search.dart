import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/colors.dart';
import '../../../core/go.dart';
import '../../../core/helpers.dart';
import '../../../core/routes.dart';
import '../../global/model/name.dart';
import '../../global/widgets/filter_widget.dart';
import '../../global/widgets/meninki_network_image.dart';
import '../../product/models/product.dart';
import '../../product/widgets/product_card.dart';
import '../../province/blocks/province_selecting_cubit/province_selecting_cubit.dart';
import '../../store/bloc/get_market_by_id/get_market_by_id_cubit.dart';
import '../../store/bloc/get_store_products/get_store_products_bloc.dart';
import '../../store/models/market.dart';
import '../../store/pages/stores_search_filter_page.dart';

class MarketProductsSearch extends StatefulWidget {
  final String? text;
  const MarketProductsSearch({super.key, this.text});

  @override
  State<MarketProductsSearch> createState() => _MarketProductsSearchState();
}

class _MarketProductsSearchState extends State<MarketProductsSearch> {
  final ScrollController marketsScrollController = ScrollController();
  List<Market> storesProducts = [];

  @override
  void initState() {
    marketsScrollController.addListener(() {
      if (marketsScrollController.position.pixels ==
          marketsScrollController.position.maxScrollExtent) {
        context.read<GetStoreProductsSearch>().add(PaginateProductStores());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var filteredProvinces =
        context.watch<ProvinceSelectingCubit>().selectedMap[ProvinceSelectingCubit
            .storesSearchFilterProvince];

    var filterList = [
      if (filteredProvinces?.isNotEmpty ?? false)
        filteredProvinces!.map((e) => e.name.trans(context)).toList().join(', '),
    ];
    return CustomScrollView(
      controller: marketsScrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            await context.read<GetStoreProductsSearch>().refresh();
          },
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              FilterWidget(
                filterList: filterList,
                onFilter: () {
                  Go.to(
                    Routes.storesSearchFilterPage,
                    argument: {
                      "onFilter": () {
                        context.read<GetStoreProductsSearch>().add(
                          GetProductStores(search: widget.text),
                        );
                      },
                    },
                  );
                },
                onClear: () {
                  clearStoresSearchFilters();
                  context.read<GetStoreProductsSearch>().add(GetProductStores(search: widget.text));
                },
              ),

              BlocBuilder<GetStoreProductsSearch, GetStoreProductsState>(
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
                    child: Column(
                      children: [
                        ListView.separated(
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
                                      context.read<GetMarketByIdCubit>().getStoreById(
                                        storesProducts[index].id,
                                      );
                                      Go.to(
                                        Routes.publicStoreDetail,
                                        argument: {'navigatedTab': 'product'},
                                      );
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
                                                              borderRadius: 100,
                                                              file:
                                                                  storesProducts[index]
                                                                      .cover_image!,
                                                              networkImageType:
                                                                  NetworkImageType.small,
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
                                                    : storesProducts[index].name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
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
                                      itemCount:
                                          isLoading
                                              ? 3
                                              : storesProducts[index].products?.length ?? 0,
                                      itemBuilder: (context, productIndex) {
                                        return Padd(
                                          left: productIndex == 0 ? 10 : 0,
                                          right:
                                              productIndex ==
                                                      (storesProducts[index].products?.length ??
                                                              1) -
                                                          1
                                                  ? 10
                                                  : 0,
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
                          separatorBuilder: (context, index) => Box(h: 20),
                        ),
                        if (state is GetProductStoresPaginating)
                          Padd(
                            ver: 10,
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        Box(h: 80),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
