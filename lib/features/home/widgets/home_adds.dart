import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:meninki/core/colors.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/adds/bloc/add_uuid_cubit/add_uuid_cubit.dart';
import 'package:meninki/features/adds/bloc/get_public_adds_bloc/get_adds_bloc.dart';
import 'package:meninki/features/adds/models/add.dart';
import 'package:meninki/features/categories/bloc/category_selecting_cubit/category_selecting_cubit.dart';
import 'package:meninki/features/categories/bloc/get_categories_cubit/get_categories_cubit.dart';
import 'package:meninki/features/categories/models/category.dart';
import 'package:meninki/features/global/widgets/meninki_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/helpers.dart';
import '../../global/model/name.dart';

class HomeAdd extends StatefulWidget {
  const HomeAdd({super.key});

  @override
  State<HomeAdd> createState() => _HomeAddState();
}

class _HomeAddState extends State<HomeAdd> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    context.read<GetCategoriesCubit>().getCategories();
    context.read<GetAddsBloc>().add(GetAdd());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
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
              Box(h: 20),

              ///filter
              Padd(
                hor: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Обзоры", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                        Row(
                          children: [
                            Svvg.asset("sort", size: 20, color: Color(0xFF969696)),
                            Text(
                              "По дате - сначала новые",
                              style: TextStyle(color: Color(0xFF969696)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Go.to(Routes.addCreatePage);
                      },
                      onLongPress: () {
                        context.read<GetAddsBloc>().add(GetAdd());
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Col.primary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(child: Icon(Icons.add_circle, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
              Box(h: 10),

              ///categories
              categories(),

              Box(h: 20),

              Padd(hor: 10, child: PublicAddsList()),
            ],
          ),
        ),
      ],
    );
  }

  SizedBox categories() {
    return SizedBox(
      height: 40,
      child: BlocBuilder<GetCategoriesCubit, GetCategoriesState>(
        builder: (context, state) {
          List<Category> categories = [];
          if (state is GetCategoriesSuccess) {
            categories = state.categories;
          }
          if (state is GetCategoriesLoading) {
            // +1 because index 0 is "home"
            categories = List.generate(6, (index) => Category(name: Name(tk: 'loading')));
          }
          return Skeletonizer(
            enabled: state is GetCategoriesLoading,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padd(left: 10, child: Svvg.asset('home', color: Colors.black));
                }
                return BlocBuilder<CategorySelectingCubit, CategorySelectingState>(
                  builder: (context, state) {
                    var selecteds = <Category>[];
                    if (state is CategorySelectingSuccess) {
                      selecteds =
                          state.selectedMap[CategorySelectingCubit.adds_page_category] ?? [];
                    }
                    var selectedIndex = selecteds.indexWhere((e) => e.id == categories[index].id);
                    var isSelected = selectedIndex != -1;

                    return Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        splashColor: Colors.white.withOpacity(isSelected ? 0.25 : 0.15),
                        highlightColor: Colors.white.withOpacity(isSelected ? 0.15 : 0.08),
                        onTap: () {
                          HapticFeedback.selectionClick();

                          context.read<CategorySelectingCubit>().selectCategory(
                            key: CategorySelectingCubit.adds_page_category,
                            category: categories[index],
                            singleSelection: true,
                          );
                          context.read<GetAddsBloc>().add(GetAdd());
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: isSelected ? Col.primary : const Color(0xFFF3F3F3),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Center(
                            child: Text(
                              categories[index].name?.trans(context) ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.white : const Color(0xFF474747),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) => Box(w: 6),
              itemCount: categories.length,
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class PublicAddsList extends StatelessWidget {
  const PublicAddsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAddsBloc, GetAddsState>(
      builder: (context, state) {
        final isLoading = state is GetAddLoading;

        final adds =
            isLoading
                ? List.generate(6, (_) => Add())
                : state is GetAddSuccess
                ? state.adds
                : <Add>[];

        return Skeletonizer(
          enabled: isLoading,
          effect: ShimmerEffect(
            baseColor: const Color(0xFFEAEAEA),
            highlightColor: const Color(0xFFF5F5F5),
          ),
          child: MasonryGridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 8,
            itemCount: adds.length,
            itemBuilder: (context, index) {
              final add = adds[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      context.read<AddUuidCubit>().getAdd(add.id ?? 0);
                      Go.to(Routes.addDetailPage, argument: {'add': add});
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 168,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAEAEA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:
                            add.cover_image != null
                                ? IgnorePointer(
                                  ignoring: true,
                                  child: MeninkiNetworkImage(
                                    file: add.cover_image!,
                                    networkImageType: NetworkImageType.medium,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                : null,
                      ),
                    ),
                  ),
                  const Box(h: 6),
                  Text(
                    add.title ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Box(h: 4),
                  Text("${add.price} TMT", style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
