import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/features/home/widgets/searched_reels_list.dart';

import '../../../core/go.dart';
import '../../../core/helpers.dart';
import '../../../core/routes.dart';
import '../../categories/bloc/category_selecting_cubit/category_selecting_cubit.dart';
import '../../global/blocs/sort_cubit/sort_cubit.dart';
import '../../global/widgets/filter_widget.dart';
import '../../reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import '../../reels/model/query.dart';
import '../../reels/pages/reels_filter_page.dart';

class ReelsSearch extends StatelessWidget {
  final String? text;
  const ReelsSearch({super.key, required this.text});

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
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            await context.read<GetSearchedReelsBloc>().refresh();
          },
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              FilterWidget(
                filterList: filterList,
                onFilter: () {
                  Go.to(
                    Routes.reelsFilterPage,
                    argument: {
                      "onFilter": () {
                        context.read<GetSearchedReelsBloc>().add(
                          GetReel(Query(keyword: text, filtered: true)),
                        );
                      },
                    },
                  );
                },
                onClear: () {
                  clearReelsSearchFilters();
                  context.read<GetSearchedReelsBloc>().add(
                    GetReel(Query(keyword: text, filtered: true)),
                  );
                },
              ),
              Box(h: 10),

              SearchedReelsList(),
            ],
          ),
        ),
      ],
    );
  }
}
