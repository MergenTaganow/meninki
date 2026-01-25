import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/features/home/widgets/searched_reels_list.dart';

import '../../../core/go.dart';
import '../../../core/helpers.dart';
import '../../../core/routes.dart';
import '../../categories/bloc/category_selecting_cubit/category_selecting_cubit.dart';
import '../../global/blocs/sort_cubit/sort_cubit.dart';
import '../../global/widgets/filter_widget.dart';
import '../../reels/pages/reels_filter_page.dart';

class ReelsSearch extends StatelessWidget {
  final void Function()? fetch;
  const ReelsSearch({super.key, required this.fetch});

  @override
  Widget build(BuildContext context) {
    var filteredCategories =
    context.watch<CategorySelectingCubit>().selectedMap[CategorySelectingCubit
        .reels_searching_category];
    var filteredSort = context.watch<SortCubit>().sortMap[SortCubit.reelsSearchSort];

    var filterList = [
      if (filteredSort != null) filteredSort.text ?? '',
      if (filteredCategories?.isNotEmpty ?? false)
        filteredCategories!.map((e) => e.name?.tk).toList().join(', '),
    ];
    return Column(
      children: [
        FilterWidget(
          filterList: filterList,
          onFilter: () {
            Go.to(Routes.reelsFilterPage, argument: {"onFilter": fetch});
          },
          onClear: () {
            clearReelsSearchFilters();
            if (fetch != null) fetch!();
          },
        ),
        Box(h: 20),

        Expanded(child: SearchedReelsList()),
      ],
    );
  }
}
