import 'package:flutter/material.dart';

import '../../../core/colors.dart';
import '../../../core/go.dart';
import '../../../core/helpers.dart';
import '../../../core/injector.dart';
import '../../categories/bloc/category_selecting_cubit/category_selecting_cubit.dart';
import '../../categories/widgets/category_selection.dart';
import '../../global/blocs/sort_cubit/sort_cubit.dart';
import '../../global/widgets/sort_selection.dart';

class ReelsFilterPage extends StatelessWidget {
  final void Function()? onFilter;
  const ReelsFilterPage({super.key, this.onFilter});

  @override
  Widget build(BuildContext context) {
    var listSort = [
      Sort(text: "Sonky gosulanlar", orderBy: 'created_at', orderDirection: 'desc'),
      Sort(text: "Ilki gosulanlar", orderBy: 'created_at', orderDirection: 'asc'),
      Sort(text: "Like sany kopler", orderBy: 'user_favorite_count', orderDirection: 'desc'),
      Sort(text: "Like sany azlar", orderBy: 'user_favorite_count', orderDirection: 'asc'),
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
                SortSelection(listSort: listSort, sortKey: SortCubit.reelsSearchSort),

                Box(h: 10),
                CategorySelection(
                  selectionKey: CategorySelectingCubit.reels_searching_category,
                  singleSelection: false,
                  rootCategorySelection: false,
                ),
                Spacer(),

                ///clear filter
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        clearReelsSearchFilters();
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
                        if (onFilter != null) {
                          onFilter!();
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

clearReelsSearchFilters() {
  sl<SortCubit>().selectSort(key: SortCubit.reelsSearchSort, newSort: null);
  // context.read<ProvinceSelectingCubit>().emptySelections(
  //   ProvinceSelectingCubit.product_searching_province,
  // );
  sl<CategorySelectingCubit>().emptySelections(CategorySelectingCubit.reels_searching_category);
}
