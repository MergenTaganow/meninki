import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/colors.dart';
import 'package:meninki/features/global/widgets/filter_widget.dart';
import 'package:meninki/features/home/widgets/home_adds.dart';
import 'package:meninki/features/home/widgets/product_search.dart';
import 'package:meninki/features/home/widgets/reels_screen_search.dart';
import 'package:meninki/features/reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import 'package:meninki/features/reels/model/query.dart';
import '../../../core/helpers.dart';
import '../../adds/bloc/get_public_adds_bloc/get_adds_bloc.dart';
import '../../product/bloc/get_products_bloc/get_products_bloc.dart';
import '../../product/pages/product_search_filter_page.dart';
import '../../store/bloc/get_store_products/get_store_products_bloc.dart';
import '../bloc/tab_navigation_cubit/tab_navigation_cubit.dart';
import 'market_product_search.dart';

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

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      // setState(() {});
      fetchList();
    });
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
    return BlocListener<TabNavigationCubit, TabNavigationState>(
      listener: (context, state) {
        if (state is NavigateTab && state.page == TabPages.search) {
          tabController.animateTo(state.index, duration: Duration(milliseconds: 300));
        }
      },
      child: Padd(
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
                      Padd(
                        hor: 10,
                        child: SizedBox(
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
                      ),
                      Box(h: 10),

                      ///searchTypes
                      SizedBox(
                        height: 36,
                        child: ButtonsTabBar(
                          // Customize the appearance and behavior of the tab bar
                          controller: tabController,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Col.primary,
                          ),
                          unselectedDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Color(0xFFF3F3F3),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                          buttonMargin: EdgeInsets.symmetric(horizontal: 6),
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          unselectedLabelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          // Add your tabs here
                          tabs: searchTypes.map((e) => Tab(text: e)).toList(),
                        ),

                        // TabBar(
                        //   controller: tabController,
                        //   isScrollable: true,
                        //   padding: const EdgeInsets.symmetric(horizontal: 4),
                        //   labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                        //   tabAlignment: TabAlignment.start,
                        //   indicatorPadding: EdgeInsets.zero,
                        //
                        //   // 🔥 remove default line
                        //   dividerColor: Colors.transparent,
                        //
                        //   // we draw indicator ourselves
                        //   indicator: BoxDecoration(
                        //     color: Col.primary,
                        //     borderRadius: BorderRadius.circular(14),
                        //   ),
                        //
                        //   splashBorderRadius: BorderRadius.circular(14),
                        //   splashFactory: InkRipple.splashFactory,
                        //
                        //   labelColor: Col.white,
                        //   unselectedLabelColor: const Color(0xFF474747),
                        //
                        //   labelStyle: const TextStyle(fontWeight: FontWeight.w500),
                        //   unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
                        //
                        //   onTap: (index) {
                        //     HapticFeedback.selectionClick();
                        //     selectedType = searchTypes[index];
                        //     fetchList();
                        //   },
                        //
                        //   tabs: List.generate(
                        //     searchTypes.length,
                        //     (index) => AnimatedBuilder(
                        //       animation: tabController.animation!,
                        //       builder: (context, child) {
                        //         // Calculate how "selected" this tab is (0.0 to 1.0)
                        //         final animValue = tabController.animation!.value;
                        //         final diff = (index - animValue).abs();
                        //         final opacity = 1.0 - diff.clamp(0.0, 1.0);
                        //
                        //         // Interpolate background color based on selection
                        //         final backgroundColor = Color.lerp(
                        //           const , // unselected
                        //           Colors.transparent, // selected
                        //           opacity,
                        //         );
                        //
                        //         return Tab(
                        //           child: Container(
                        //             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        //             decoration: BoxDecoration(
                        //               color: backgroundColor,
                        //               borderRadius: BorderRadius.circular(14),
                        //             ),
                        //             child: Text(searchTypes[index]),
                        //           ),
                        //         );
                        //       },
                        //     ),
                        //   ),
                        // ),
                      ),
                      Box(h: 16),
                    ],
                  ),
                ),
              ];
            },
            body: Padd(
              hor: 10,
              child: TabBarView(
                controller: tabController,
                children: [
                  ReelsSearch(fetch: fetchList),
                  ProductSearch(),
                  Column(
                    children: [
                      FilterWidget(filterList: [], onFilter: () {}, onClear: () {}),
                      Expanded(child: PublicAddsList()),
                    ],
                  ),
                  MarketProductsSearch(fetchList),
                ],
              ),
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
        if (context.read<GetSearchedReelsBloc>().reels.isEmpty) {
          context.read<GetSearchedReelsBloc>().add(GetReel(Query(keyword: text, filtered: true)));
        }
      case 1:
        if (context.read<GetProductsBloc>().products.isEmpty) {
          context.read<GetProductsBloc>().add(GetProduct(Query(keyword: text)));
        }
      case 2:
        if (context.read<GetAddsBloc>().adds.isEmpty) {
          context.read<GetAddsBloc>().add(GetAdd(Query(keyword: text)));
        }
      case 3:
        if (context.read<GetStoreProductsSearch>().stores.isEmpty) {
          context.read<GetStoreProductsSearch>().add(GetProductStores(search: text));
        }
    }
  }

  @override
  bool get wantKeepAlive => true;
}
