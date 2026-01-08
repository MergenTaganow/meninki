import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/colors.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/routes.dart';
import '../../../core/helpers.dart';
import '../../categories/bloc/category_selecting_cubit/category_selecting_cubit.dart';
import '../../global/blocs/key_filter_cubit/key_filter_cubit.dart';
import '../../global/blocs/sort_cubit/sort_cubit.dart';
import '../../product/bloc/get_products_bloc/get_products_bloc.dart';
import '../../product/widgets/product_card.dart';
import '../../province/blocks/province_selecting_cubit/province_selecting_cubit.dart';

class ProductsSearch extends StatefulWidget {
  const ProductsSearch({super.key});

  @override
  State<ProductsSearch> createState() => _ProductsSearchState();
}

class _ProductsSearchState extends State<ProductsSearch> {
  TextEditingController search = TextEditingController();
  List<String> searchTypes = ['Обзоры', 'Товары', 'Объявления', 'Магазины'];
  String selectedType = 'Обзоры';
  List<String> filterList = [];

  @override
  void initState() {
    search.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    clearFilters();
    super.deactivate();
  }

  clearFilters() {
    context.read<KeyFilterCubit>().select(
      key: KeyFilterCubit.product_search_min_price,
      value: null,
    );
    context.read<KeyFilterCubit>().select(
      key: KeyFilterCubit.product_search_max_price,
      value: null,
    );
    context.read<SortCubit>().selectSort(key: SortCubit.productSearchSort, newSort: null);
    // context.read<ProvinceSelectingCubit>().emptySelections(
    //   ProvinceSelectingCubit.product_searching_province,
    // );
    context.read<CategorySelectingCubit>().emptySelections(
      CategorySelectingCubit.product_searching_category,
    );
    filterList.clear();
  }

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

    filterList = [
      if (filteredSort != null) filteredSort.text ?? '',
      if (filteredCategories?.isNotEmpty ?? false)
        filteredCategories!.map((e) => e.name?.tk).toList().join(', '),
      // if (filteredProvinces?.isNotEmpty ?? false)
      //   filteredProvinces!.map((e) => e.name.tk).toList().join(', '),
      if (minPrice != null) 'от $minPrice',
      if (maxPrice != null) 'до $maxPrice',
    ];
    return Padd(
      hor: 10,
      ver: 20,
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<GetProductsBloc>().add(GetProduct());
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              ///search
              SizedBox(
                height: 55,
                child: TextField(
                  controller: search,
                  decoration: InputDecoration(
                    fillColor: Color(0xFFF3F3F3),
                    filled: true,
                    prefixIcon: Icon(Icons.search, color: Color(0xFF969696)),
                    suffixIcon:
                        search.text.isNotEmpty
                            ? GestureDetector(
                              onTap: () {
                                search.clear();
                              },
                              child: Icon(Icons.highlight_remove_rounded, color: Color(0xFF474747)),
                            )
                            : null,
                    hintText: "Поиск",
                    hintStyle: TextStyle(color: Color(0xFF969696)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.white, width: 0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.white, width: 0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Color(0xFF0A0A0A), width: 1),
                    ),
                  ),
                ),
              ),
              Box(h: 10),

              ///searchTypes
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        selectedType = searchTypes[index];
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              selectedType == searchTypes[index] ? Col.primary : Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        child: Text(
                          searchTypes[index],
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color:
                                selectedType == searchTypes[index] ? Col.white : Color(0xFF474747),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Box(w: 6),
                  itemCount: searchTypes.length,
                ),
              ),
              Box(h: 20),

              ///body
              BlocBuilder<GetProductsBloc, GetProductsState>(
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
                        GestureDetector(
                          onTap: () {
                            Go.to(
                              Routes.productSearchFilterPage,
                              argument: {
                                "onFilter": () {
                                  context.read<GetProductsBloc>().add(GetProduct());
                                },
                              },
                            );
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Svvg.asset('sort', size: 20),
                                  Box(w: 4),
                                  Text(
                                    "Фильтр и сортировка",
                                    style: TextStyle(color: Color(0xFF474747)),
                                  ),
                                ],
                              ),
                              if (filterList.isNotEmpty)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        filterList.join(", "),
                                        style: TextStyle(color: Color(0xFF969696)),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        clearFilters();
                                        context.read<GetProductsBloc>().add(GetProduct());
                                      },
                                      child: Icon(Icons.highlight_remove),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        Box(h: 20),
                        SizedBox(
                          height: 240,
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              return ProductCard(product: state.products[index]);
                            },
                            itemCount: state.products.length,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (BuildContext context, int index) => Box(w: 8),
                          ),
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
