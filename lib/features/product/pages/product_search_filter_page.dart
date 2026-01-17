import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/features/categories/bloc/category_selecting_cubit/category_selecting_cubit.dart';
import 'package:meninki/features/global/blocs/key_filter_cubit/key_filter_cubit.dart';
import '../../../core/colors.dart';
import '../../../core/injector.dart';
import '../../categories/widgets/category_selection.dart';
import '../../global/blocs/sort_cubit/sort_cubit.dart';
import '../../global/widgets/sort_selection.dart';

class ProductSearchFilterPage extends StatefulWidget {
  final void Function()? onFilter;
  const ProductSearchFilterPage({this.onFilter, super.key});

  @override
  State<ProductSearchFilterPage> createState() => _ProductSearchFilterPageState();
}

class _ProductSearchFilterPageState extends State<ProductSearchFilterPage> {
  TextEditingController maxPrice = TextEditingController();
  TextEditingController minPrice = TextEditingController();

  @override
  void initState() {
    var keyFilters = context.read<KeyFilterCubit>().selectedMap;
    maxPrice.text = keyFilters[KeyFilterCubit.product_search_max_price] ?? '';
    minPrice.text = keyFilters[KeyFilterCubit.product_search_min_price] ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var listSort = [
      Sort(text: "Sonky gosulanlar", orderBy: 'id', orderDirection: 'desc'),
      Sort(text: "Ilki gosulanlar", orderBy: 'id', orderDirection: 'asc'),
      Sort(text: "Bahasy Arzanlar", orderBy: 'price', orderDirection: 'asc'),
      Sort(text: "Bahasy gymmatlar", orderBy: 'price', orderDirection: 'desc'),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Фильтр и сортировка", style: TextStyle(fontWeight: FontWeight.w500)),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 100,
            maxHeight: MediaQuery.of(context).size.height - 100,
          ),
          child: Padd(
            pad: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SortSelection(listSort: listSort, sortKey: SortCubit.productSearchSort),
                // Box(h: 10),
                // ProvinceSelection(
                //   selectionKey: ProvinceSelectingCubit.product_searching_province,
                //   singleSelection: false,
                // ),
                Box(h: 10),
                CategorySelection(
                  selectionKey: CategorySelectingCubit.product_searching_category,
                  singleSelection: false,
                ),
                Box(h: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Минимальная цена"),
                    Box(h: 6),
                    TexField(
                      ctx: context,
                      cont: minPrice,
                      filCol: Color(0xFFF3F3F3),
                      borderRadius: 14,
                      hint: "Цена от",
                      hintCol: Color(0xFF969696),
                      onChange: (text) {
                        context.read<KeyFilterCubit>().select(
                          key: KeyFilterCubit.product_search_min_price,
                          value: minPrice.text,
                        );
                      },
                    ),
                  ],
                ),
                Box(h: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Максимальная цена"),
                    Box(h: 6),
                    TexField(
                      ctx: context,
                      cont: maxPrice,
                      filCol: Color(0xFFF3F3F3),
                      borderRadius: 14,
                      hint: "Цена до",
                      hintCol: Color(0xFF969696),
                      onChange: (text) {
                        context.read<KeyFilterCubit>().select(
                          key: KeyFilterCubit.product_search_max_price,
                          value: maxPrice.text,
                        );
                      },
                    ),
                  ],
                ),
                Spacer(),

                ///clear filter
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        clearProductSearchFilters();
                      },
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            "Очистить фильтр",
                            style: TextStyle(color: Color(0xFF474747)),
                          ),
                        ),
                      ),
                    ),
                    Box(h: 10),

                    ///save and go
                    InkWell(
                      onTap: () {
                        Go.pop();
                        if (widget.onFilter != null) {
                          widget.onFilter!();
                        }
                      },
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Col.primary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text("Сохранить", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

clearProductSearchFilters() {
  sl<KeyFilterCubit>().select(key: KeyFilterCubit.product_search_min_price, value: null);
  sl<KeyFilterCubit>().select(key: KeyFilterCubit.product_search_max_price, value: null);
  sl<SortCubit>().selectSort(key: SortCubit.productSearchSort, newSort: null);
  // context.read<ProvinceSelectingCubit>().emptySelections(
  //   ProvinceSelectingCubit.product_searching_province,
  // );
  sl<CategorySelectingCubit>().emptySelections(CategorySelectingCubit.product_searching_category);
}
