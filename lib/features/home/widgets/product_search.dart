import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:meninki/features/global/model/name.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/go.dart';
import '../../../core/helpers.dart';
import '../../../core/routes.dart';
import '../../categories/bloc/category_selecting_cubit/category_selecting_cubit.dart';
import '../../global/blocs/key_filter_cubit/key_filter_cubit.dart';
import '../../global/blocs/sort_cubit/sort_cubit.dart';
import '../../global/widgets/filter_widget.dart';
import '../../product/bloc/get_products_bloc/get_products_bloc.dart';
import '../../product/models/product.dart';
import '../../product/pages/product_search_filter_page.dart';
import '../../product/widgets/product_card.dart';
import '../../reels/model/query.dart';

class ProductSearch extends StatelessWidget {
  final String? text;
  const ProductSearch({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    var filteredCategories =
        context.watch<CategorySelectingCubit>().selectedMap[CategorySelectingCubit
            .product_searching_category];
    // var filteredProvinces =
    //     context.watch<ProvinceSelectingCubit>().selectedMap[ProvinceSelectingCubit
    //         .product_searching_province];
    var keyFilters = context.watch<KeyFilterCubit>().selectedMap;
    var maxPrice = keyFilters[KeyFilterCubit.product_search_max_price];
    var minPrice = keyFilters[KeyFilterCubit.product_search_min_price];
    var filteredSort = context.watch<SortCubit>().sortMap[SortCubit.productSearchSort];

    var filterList = [
      if (filteredSort != null) filteredSort.text ?? '',
      if (filteredCategories?.isNotEmpty ?? false)
        filteredCategories!.map((e) => e.name?.tk).toList().join(', '),
      // if (filteredProvinces?.isNotEmpty ?? false)
      //   filteredProvinces!.map((e) => e.name.tk).toList().join(', '),
      if (minPrice != null) 'от $minPrice',
      if (maxPrice != null) 'до $maxPrice',
    ];
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            await context.read<GetProductsBloc>().refresh();
          },
        ),
        SliverToBoxAdapter(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilterWidget(
                filterList: filterList,
                onFilter: () {
                  Go.to(
                    Routes.productSearchFilterPage,
                    argument: {
                      "onFilter": () {
                        context.read<GetProductsBloc>().add(GetProduct(Query(keyword: text)));
                      },
                    },
                  );
                },
                onClear: () {
                  clearProductSearchFilters();
                  context.read<GetProductsBloc>().add(GetProduct(Query(keyword: text)));
                },
              ),
              Box(h: 10),
              BlocBuilder<GetProductsBloc, GetProductsState>(
                builder: (context, state) {
                  final isLoading = state is GetProductLoading;
                  final products = state is GetProductSuccess ? state.products : <Product>[];

                  final itemCount = isLoading ? 6 : products.length;
                  return Skeletonizer(
                    enabled: isLoading,
                    child: MasonryGridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final product =
                            isLoading ? Product(id: 9999, name: Name()) : products[index];
                        return ProductCard(
                          product: product,
                          height: 340,
                          width: MediaQuery.of(context).size.width / 2,
                        );
                      },
                      itemCount: itemCount,
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 8,
                      // separatorBuilder: (BuildContext context, int index) => Box(w: 8),
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
