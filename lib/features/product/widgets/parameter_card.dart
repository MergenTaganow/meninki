import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/features/product/widgets/attributes_sheet.dart';
import '../../../core/helpers.dart';
import '../bloc/compositions_creating_cubit/compositions_creat_cubit.dart';
import '../models/product_atribute.dart';
import '../models/product_parameters.dart';

class ParameterCard extends StatelessWidget {
  const ParameterCard({super.key, required this.parameter, required this.attributes});

  final ProductParameter parameter;
  final List<ProductAttribute> attributes;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFEAEAEA)),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  child: Text(parameter.name.trans(context), style: TextStyle(fontWeight: FontWeight.w500)),
                ),
              ),
              Box(w: 8),
              GestureDetector(
                onTap: () {
                  context.read<CompositionsCreatCubit>().selectParameter(parameter);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.delete_outline, color: Colors.red),
                ),
              ),
            ],
          ),
          Box(h: 10),
          SizedBox(
            height: 40,
            child: ListView.separated(
              itemBuilder: (context, index) {
                if (index == attributes.length) {
                  return InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return DraggableScrollableSheet(
                            expand: false,
                            maxChildSize: 0.85,
                            builder: (context, scrollController) {
                              return AttributesSheet(scrollController, parameter);
                            },
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: Color(0xFFEAEAEA),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.addVariant,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Box(w: 6),
                          Icon(Icons.add_circle, color: Colors.black),
                        ],
                      ),
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () {
                      context.read<CompositionsCreatCubit>().selectAttribute(
                        parameter,
                        attributes[index],
                      );
                    },
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: Color(0xFFEAEAEA),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            attributes[index].name.trans(context),
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Box(w: 6),
                          Icon(Icons.clear, color: Colors.red),
                        ],
                      ),
                    ),
                  );
                }
              },
              itemCount: attributes.length + 1,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (BuildContext context, int index) => Box(w: 8),
            ),
          ),
        ],
      ),
    );
  }
}
