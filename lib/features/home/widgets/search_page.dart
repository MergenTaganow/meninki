import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/cupertino.dart';
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
    var state = context.read<TabNavigationCubit>().state;

    tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: (state is NavigateTab && state.page == TabPages.search) ? state.index : 0,
    );
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
          tabController.index = state.index;
        }
      },
      child: Padd(
        ver: 20,
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
                    BlocBuilder<TabNavigationCubit, TabNavigationState>(
                      builder: (context, state) {
                        if (state is NavigateTab) {
                          return Container();
                        }
                        return SizedBox(
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
                        );
                      },
                    ),
                    Box(h: 16),
                  ],
                ),
              ),
            ];
          },
          body: BlocBuilder<TabNavigationCubit, TabNavigationState>(
            builder: (context, state) {
              if (state is NavigateTab) {
                return Container();
              }
              return Padd(
                hor: 10,
                child: TabBarView(
                  controller: tabController,
                  children: [
                    ReelsSearch(text: search.text.trim()),
                    ProductSearch(text: search.text.trim()),
                    CustomScrollView(
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
                              FilterWidget(filterList: [], onFilter: () {}, onClear: () {}),
                              Box(h: 10),
                              PublicAddsList(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    MarketProductsSearch(text: search.text.trim()),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void fetchList() {
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
