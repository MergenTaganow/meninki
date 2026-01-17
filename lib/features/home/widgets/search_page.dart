import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:meninki/core/colors.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/global/widgets/filter_widget.dart';
import 'package:meninki/features/home/widgets/product_search.dart';
import 'package:meninki/features/home/widgets/searched_reels_list.dart';
import 'package:meninki/features/reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import 'package:meninki/features/reels/model/query.dart';
import '../../../core/helpers.dart';
import '../../categories/bloc/category_selecting_cubit/category_selecting_cubit.dart';
import '../../global/blocs/key_filter_cubit/key_filter_cubit.dart';
import '../../global/blocs/sort_cubit/sort_cubit.dart';
import '../../product/bloc/get_products_bloc/get_products_bloc.dart';
import '../../product/pages/product_search_filter_page.dart';
import '../../product/widgets/product_card.dart';
import '../../reels/pages/reels_filter_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController tabController;
  TextEditingController search = TextEditingController();
  List<String> searchTypes = ['Обзоры', 'Товары', 'Объявления', 'Магазины'];
  String selectedType = 'Обзоры';
  List<String> filterList = [];

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    fetchList();
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
    clearProductSearchFilters();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padd(
      hor: 10,
      ver: 20,
      child: RefreshIndicator(
        onRefresh: () async {
          fetchList();
        },
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
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
                                      fetchList();
                                    },
                                    child: Icon(
                                      Icons.highlight_remove_rounded,
                                      color: Color(0xFF474747),
                                    ),
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
                        onSubmitted: (text) {},
                      ),
                    ),
                    Box(h: 10),

                    ///searchTypes
                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        itemCount: searchTypes.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 6),
                        itemBuilder: (context, index) {
                          final isSelected = selectedType == searchTypes[index];

                          return Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              splashColor: Colors.black.withOpacity(0.2),
                              highlightColor: Colors.black.withOpacity(0.08),
                              onTap: () {
                                HapticFeedback.selectionClick();
                                selectedType = searchTypes[index];
                                setState(() {});
                                tabController.animateTo(index);
                                fetchList();
                              },
                              child: Ink(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Col.primary
                                      : const Color(0xFFF3F3F3),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOut,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? Col.white
                                        : const Color(0xFF474747),
                                  ),
                                  child: Text(searchTypes[index]),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Box(h: 16),
                  ],
                ),
              ),
            ];
          },
          body: Padd(
            child: TabBarView(
              controller: tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [ReelsSearch(fetch: fetchList), ProductSearch(), Container(), Container()],
            ),
          ),
        ),
      ),
    );
  }

  fetchList() {
    var text = search.text.trim();
    switch (tabController.index) {
      case 0:
        context.read<GetSearchedReelsBloc>().add(GetReel(Query(keyword: text, filtered: true)));
      case 1:
        context.read<GetProductsBloc>().add(GetProduct(Query(keyword: text)));
      case 2:
      case 3:
    }
  }

  @override
  bool get wantKeepAlive => true;
}

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

        SearchedReelsList(),
      ],
    );
  }
}
