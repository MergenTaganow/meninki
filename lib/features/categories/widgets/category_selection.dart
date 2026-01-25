import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/features/categories/bloc/category_selecting_cubit/category_selecting_cubit.dart';
import 'package:meninki/features/categories/models/category.dart';

import '../../../core/go.dart';
import '../../../core/helpers.dart';
import '../../../core/routes.dart';

class CategorySelection extends StatelessWidget {
  final String selectionKey;
  final bool singleSelection;
  final bool rootCategorySelection;
  const CategorySelection({
    super.key,
    required this.selectionKey,
    required this.singleSelection,
    required this.rootCategorySelection,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategorySelectingCubit, CategorySelectingState>(
      builder: (context, state) {
        if (state is CategorySelectingSuccess) {
          List<Category> selecteds = state.selectedMap[selectionKey] ?? [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Категория"),
              Box(h: 6),
              InkWell(
                onTap: () {
                  Go.to(
                    Routes.categoriesSelectingPage,
                    argument: {
                      'selectionKey': selectionKey,
                      "singleSelection": singleSelection,
                      'rootCategorySelection': rootCategorySelection,
                    },
                  );
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Color(0xFF474747)),
                  ),
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          selecteds.isEmpty
                              ? 'Выбери Категорию'
                              : selecteds.map((e) => e.name?.tk).join(', '),
                          style: TextStyle(color: Color(0xFF969696)),
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_right_outlined, size: 18),
                      Box(w: 5),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
