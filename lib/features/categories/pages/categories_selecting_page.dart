import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/categories/bloc/get_categories_cubit/get_categories_cubit.dart';
import 'package:meninki/features/categories/models/category.dart';

class CategoriesSelectingPage extends StatefulWidget {
  final String selectionKey;
  final bool? singleSelection;

  const CategoriesSelectingPage({
    super.key,
    this.singleSelection = false,
    required this.selectionKey,
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
    return Scaffold(
      appBar: AppBar(title: Text("Категория", style: TextStyle(fontWeight: FontWeight.w500))),
      body: Padd(
        pad: 10,
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
                  return Center(child: Text(state.failure.message ?? "error"));
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
          ],
        ),
      ),
    );
  }

  Widget categoryCard(Category category) {
    return InkWell(
      onTap: () {
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
            if (category.children?.isNotEmpty ?? false)
              Icon(Icons.navigate_next, color: Color(0xFF969696)),
          ],
        ),
      ),
    );
  }
}
