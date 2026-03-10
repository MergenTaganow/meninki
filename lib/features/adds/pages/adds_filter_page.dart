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
import '../../province/blocks/province_selecting_cubit/province_selecting_cubit.dart';
import '../../province/widgets/province_selection.dart';

class AddsFilterPage extends StatefulWidget {
  final void Function()? onFilter;
  const AddsFilterPage({this.onFilter, super.key});

  @override
  State<AddsFilterPage> createState() => _AddsFilterPageState();
}

class _AddsFilterPageState extends State<AddsFilterPage> {
  TextEditingController maxPrice = TextEditingController();
  TextEditingController minPrice = TextEditingController();

  @override
  void initState() {
    var keyFilters = context.read<KeyFilterCubit>().selectedMap;
    maxPrice.text = keyFilters[KeyFilterCubit.adds_search_max_price] ?? '';
    minPrice.text = keyFilters[KeyFilterCubit.adds_search_min_price] ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(lg.filter, style: TextStyle(fontWeight: FontWeight.w500))),
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
                Box(h: 10),
                ProvinceSelection(
                  selectionKey: ProvinceSelectingCubit.add_filter_province,
                  singleSelection: false,
                ),
                Box(h: 10),
                CategorySelection(
                  selectionKey: CategorySelectingCubit.adds_page_category,
                  singleSelection: false,
                  rootCategorySelection: false,
                ),
                Box(h: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lg.minPrice),
                    Box(h: 6),
                    TexField(
                      ctx: context,
                      cont: minPrice,
                      filCol: Color(0xFFF3F3F3),
                      borderRadius: 14,
                      hint: lg.priceFrom,
                      hintCol: Color(0xFF969696),
                      onChange: (text) {
                        context.read<KeyFilterCubit>().select(
                          key: KeyFilterCubit.adds_search_min_price,
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
                    Text(lg.maxPrice),
                    Box(h: 6),
                    TexField(
                      ctx: context,
                      cont: maxPrice,
                      filCol: Color(0xFFF3F3F3),
                      borderRadius: 14,
                      hint: lg.priceTo,
                      hintCol: Color(0xFF969696),
                      onChange: (text) {
                        context.read<KeyFilterCubit>().select(
                          key: KeyFilterCubit.adds_search_max_price,
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
                        clearAddsSearchFilters();
                      },
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(lg.clearFilter, style: TextStyle(color: Color(0xFF474747))),
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
                        child: Center(child: Text(lg.save, style: TextStyle(color: Colors.white))),
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

clearAddsSearchFilters() {
  sl<KeyFilterCubit>().select(key: KeyFilterCubit.adds_search_min_price, value: null);
  sl<KeyFilterCubit>().select(key: KeyFilterCubit.adds_search_max_price, value: null);
  sl<ProvinceSelectingCubit>().emptySelections(ProvinceSelectingCubit.add_filter_province);
  sl<CategorySelectingCubit>().emptySelections(CategorySelectingCubit.adds_page_category);
}
