import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/go.dart';
import '../../../core/helpers.dart';
import '../../../core/routes.dart';
import '../../categories/bloc/category_selecting_cubit/category_selecting_cubit.dart';
import '../../global/blocs/key_filter_cubit/key_filter_cubit.dart';
import '../../global/widgets/filter_widget.dart';
import '../../home/widgets/home_adds.dart';
import '../../province/blocks/province_selecting_cubit/province_selecting_cubit.dart';
import '../bloc/get_public_adds_bloc/get_adds_bloc.dart';
import 'adds_filter_page.dart';

class AddsSearchPage extends StatelessWidget {
  const AddsSearchPage({super.key, required this.addsScrollController});

  final ScrollController addsScrollController;

  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;

    var filteredCategories =
        context.watch<CategorySelectingCubit>().selectedMap[CategorySelectingCubit
            .adds_page_category];
    var filteredProvinces =
        context.watch<ProvinceSelectingCubit>().selectedMap[ProvinceSelectingCubit
            .add_filter_province];
    var keyFilters = context.watch<KeyFilterCubit>().selectedMap;
    var maxPrice = keyFilters[KeyFilterCubit.adds_search_max_price];
    var minPrice = keyFilters[KeyFilterCubit.adds_search_min_price];

    var filterList = [
      if (filteredCategories?.isNotEmpty ?? false)
        filteredCategories!.map((e) => e.name?.tk).toList().join(', '),
      if (filteredProvinces?.isNotEmpty ?? false)
        filteredProvinces!.map((e) => e.name.tk).toList().join(', '),
      if (minPrice != null) '${lg.from} $minPrice',
      if (maxPrice != null) '${lg.to} $maxPrice',
    ];
    return CustomScrollView(
      controller: addsScrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            await context.read<GetAddsBloc>().refresh();
          },
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              FilterWidget(
                filterList: filterList,
                onFilter: () {
                  Go.to(
                    Routes.addsFilterPage,
                    argument: {
                      "onFilter": () {
                        context.read<GetAddsBloc>().add(GetAdd());
                      },
                    },
                  );
                },
                onClear: () {
                  clearAddsSearchFilters();
                  context.read<GetAddsBloc>().add(GetAdd());
                },
              ),
              Box(h: 10),
              PublicAddsList(),
            ],
          ),
        ),
      ],
    );
  }
}
