import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/colors.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/features/categories/bloc/category_selecting_cubit/category_selecting_cubit.dart';
import 'package:meninki/features/categories/models/category.dart';

import '../../../core/helpers.dart';

class SubCategorySelectingPage extends StatelessWidget {
  final List<Category> categories;

  const SubCategorySelectingPage(this.categories, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Категория", style: TextStyle(fontWeight: FontWeight.w500))),
      body: Padd(
        pad: 10,
        child: BlocBuilder<CategorySelectingCubit, CategorySelectingState>(
          builder: (context, state) {
            List<Category>? selecteds;
            if (state is CategorySelectingSuccess) {
              selecteds = state.selectedMap[CategorySelectingCubit.product_creating_category];
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      var selectedIndex = selecteds?.indexWhere(
                        (e) => e.id == categories[index].id,
                      );
                      return InkWell(
                        onTap: () {
                          context.read<CategorySelectingCubit>().selectCategory(
                            CategorySelectingCubit.product_creating_category,
                            categories[index],
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                categories[index].name,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Box(w: 14),
                              if (selectedIndex != -1) Icon(Icons.check, color: Color(0xFF969696)),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Box(h: 6),
                    itemCount: categories.length,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Go.pop();
                    Go.pop();
                  },
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Col.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(child: Text('Сохранить', style: TextStyle(color: Colors.white))),
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
