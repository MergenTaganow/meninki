import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/categories/bloc/category_selecting_cubit/category_selecting_cubit.dart';
import 'package:meninki/features/categories/bloc/get_categories_cubit/get_categories_cubit.dart';
import 'package:meninki/features/categories/models/category.dart';

import '../../../core/colors.dart';

class CategoriesSelectingPage extends StatefulWidget {
  final String selectionKey;
  final bool? singleSelection;
  final bool rootCategorySelection;

  const CategoriesSelectingPage({
    super.key,
    this.singleSelection = false,
    required this.selectionKey,
    this.rootCategorySelection = false,
  });

  @override
  State<CategoriesSelectingPage> createState() => _CategoriesSelectingPageState();
}

class _CategoriesSelectingPageState extends State<CategoriesSelectingPage> {
  @override
  void initState() {
    context.read<GetCategoriesCubit>().getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(lg.category, style: TextStyle(fontWeight: FontWeight.w500))),
      body: Padd(
        left: 10,
        right: 10,
        bot: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocBuilder<GetCategoriesCubit, GetCategoriesState>(
              builder: (context, state) {
                if (state is GetCategoriesLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is GetCategoriesFailed) {
                  return Center(child: Text(state.failure.message ?? lg.error));
                }

                if (state is GetCategoriesSuccess) {
                  return Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return categoryCard(state.categories[index]);
                      },
                      separatorBuilder: (context, index) => Box(h: 6),
                      itemCount: state.categories.length,
                    ),
                  );
                }
                return Container();
              },
            ),
            if (widget.rootCategorySelection)
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  splashColor: Colors.white.withOpacity(0.22),
                  highlightColor: Colors.white.withOpacity(0.10),
                  onTap: () {
                    Go.pop();
                  },
                  child: Ink(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Col.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(child: Text(lg.save, style: TextStyle(color: Colors.white))),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget categoryCard(Category category) {
    return InkWell(
      onTap: () {
        if (widget.rootCategorySelection) {
          context.read<CategorySelectingCubit>().selectCategory(
            key: widget.selectionKey,
            category: category,
            singleSelection: widget.singleSelection ?? false,
          );
          return;
        }
        if (category.children?.isNotEmpty ?? false) {
          Go.to(
            Routes.subCategoriesSelectingPage,
            argument: {
              "categories": category.children,
              "selectionKey": widget.selectionKey,
              "singleSelection": widget.singleSelection,
            },
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(category.name?.tk ?? '', style: TextStyle(fontWeight: FontWeight.w500)),
            Box(w: 14),
            if (widget.rootCategorySelection)
              BlocBuilder<CategorySelectingCubit, CategorySelectingState>(
                builder: (context, state) {
                  if (state is CategorySelectingSuccess) {
                    List<Category> selecteds = state.selectedMap[widget.selectionKey] ?? [];
                    var selectedIndex = selecteds.indexWhere((e) => e.id == category.id);

                    if (selectedIndex != -1) {
                      return Icon(Icons.check, color: Color(0xFF969696), size: 20);
                    }
                  }
                  return Container();
                },
              )
            else if (category.children?.isNotEmpty ?? false)
              Icon(Icons.navigate_next, color: Color(0xFF969696)),
          ],
        ),
      ),
    );
  }
}
