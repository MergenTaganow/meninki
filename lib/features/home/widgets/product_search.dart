import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../core/go.dart';
import '../../../core/helpers.dart';
import '../../../core/routes.dart';
import '../../categories/bloc/category_selecting_cubit/category_selecting_cubit.dart';
import '../../global/blocs/key_filter_cubit/key_filter_cubit.dart';
import '../../global/blocs/sort_cubit/sort_cubit.dart';
import '../../global/widgets/filter_widget.dart';
import '../../product/bloc/get_products_bloc/get_products_bloc.dart';
import '../../product/pages/product_search_filter_page.dart';
import '../../product/widgets/product_card.dart';

class ProductSearch extends StatelessWidget {
  const ProductSearch({super.key});

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
    return BlocBuilder<GetProductsBloc, GetProductsState>(
      builder: (context, state) {
        if (state is GetProductLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is GetProductFailed) {
          return Text(state.message ?? 'error');
        }
        if (state is GetProductSuccess) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilterWidget(
                filterList: filterList,
                onFilter: () {
                  Go.to(
                    Routes.productSearchFilterPage,
                    argument: {
                      "onFilter": () {
                        context.read<GetProductsBloc>().add(GetProduct());
                      },
                    },
                  );
                },
                onClear: () {
                  clearProductSearchFilters();
                  context.read<GetProductsBloc>().add(GetProduct());
                },
              ),
              Box(h: 20),
              Expanded(
                child: MasonryGridView.count(
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: state.products[index],
                      height: 340,
                      width: MediaQuery.of(context).size.width / 2,
                    );
                  },
                  itemCount: state.products.length,
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 8,
                  // separatorBuilder: (BuildContext context, int index) => Box(w: 8),
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
