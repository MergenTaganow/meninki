import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/colors.dart';
import '../../../core/helpers.dart';
import '../bloc/product_compositions_cubit/product_compositions_cubit.dart';
import '../models/product.dart';

class CompositionsList extends StatelessWidget {
  final Product product;
  const CompositionsList(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Характеристика', style: TextStyle(fontWeight: FontWeight.w500)),
        Box(h: 10),
        BlocBuilder<ProductCompositionsCubit, ProductCompositionsState>(
          builder: (context, state) {
            if (state is ProductCompositionsSuccess) {
              var keys = state.allAttributes.keys.toList();
              return ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int verticalIndex) {
                  var parameter = keys[verticalIndex];

                  return SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int horizontalIndex) {
                        var atribute = state.allAttributes[parameter]![horizontalIndex];
                        bool isSelected = state.selected[parameter]?.id == atribute.id;

                        return GestureDetector(
                          onTap: () {
                            context.read<ProductCompositionsCubit>().selectAttribute(
                              product,
                              parameter,
                              atribute,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Color(0xFFF3F3F3)),
                              color: isSelected ? Col.primary : Color(0xFFF3F3F3),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                            child: Text(
                              atribute.name.trans(context),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int horizontalIndex) => Box(w: 10),
                      itemCount: state.allAttributes[parameter]?.length ?? 0,
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int verticalIndex) => Box(h: 10),
                itemCount: state.allAttributes.length,
              );
            }
            return Container();
          },
        ),
      ],
    );
  }
}
