import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/colors.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/features/categories/bloc/category_selecting_cubit/category_selecting_cubit.dart';
import 'package:meninki/features/categories/models/category.dart';

import '../../../core/helpers.dart';

class SubCategorySelectingPage extends StatelessWidget {
  final List<Category> categories;
  final String selectionKey;
  final bool? singleSelection;

  const SubCategorySelectingPage({
    super.key,
    this.singleSelection = false,
    required this.selectionKey,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(lg.category, style: TextStyle(fontWeight: FontWeight.w500))),
      body: Padd(
        pad: 10,
        child: BlocBuilder<CategorySelectingCubit, CategorySelectingState>(
          builder: (context, state) {
            List<Category>? selecteds;
            if (state is CategorySelectingSuccess) {
              selecteds = state.selectedMap[selectionKey] ?? [];
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    // itemCount: categories.length + 1,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      // if (index == 0) {
                      //   return InkWell(
                      //     onTap: () {
                      //       context.read<CategorySelectingCubit>().selectList(
                      //         key: selectionKey,
                      //         categories: categories,
                      //       );
                      //     },
                      //     child: Container(
                      //       padding: EdgeInsets.all(14),
                      //       child: Text('все', style: TextStyle(fontWeight: FontWeight.w500)),
                      //     ),
                      //   );
                      // }
                      // var category = categories[index - 1];
                      var category = categories[index];
                      var selectedIndex = selecteds?.indexWhere((e) => e.id == category.id);
                      return InkWell(
                        onTap: () {
                          context.read<CategorySelectingCubit>().selectCategory(
                            key: selectionKey,
                            category: category,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                category.name?.tk ?? '',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Box(w: 14),
                              if (selectedIndex != -1)
                                Icon(Icons.check, color: Color(0xFF969696), size: 20),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Box(h: 6),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    splashColor: Colors.white.withOpacity(0.22),
                    highlightColor: Colors.white.withOpacity(0.10),
                    onTap: () {
                      Go.pop();
                      Go.pop();
                    },
                    child: Ink(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Col.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(lg.save, style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
