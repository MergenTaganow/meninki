import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/product/models/product_atribute.dart';
import 'package:meninki/features/product/models/product_parameters.dart';
import '../../../core/colors.dart';
import '../bloc/compositions_creating_cubit/compositions_creat_cubit.dart';
import '../models/product.dart';
import '../widgets/parameter_card.dart';
import '../widgets/parameter_sheet.dart';

class ProductParametresPage extends StatefulWidget {
  final Product product;

  const ProductParametresPage(this.product, {super.key});

  @override
  State<ProductParametresPage> createState() => _ProductParametresPageState();
}

class _ProductParametresPageState extends State<ProductParametresPage> {
  Map<ProductParameter, List<ProductAttribute>> selectedParameters = {};
  List<ProductParameter> parameters = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Характеристики")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          Go.to(Routes.compositionsPage, argument: {"product": widget.product});
        },
        child: Container(
          height: 45,
          decoration: BoxDecoration(color: Col.primary, borderRadius: BorderRadius.circular(14)),
          margin: EdgeInsets.symmetric(horizontal: 14),
          child: Center(child: Text("See compositions", style: TextStyle(color: Colors.white))),
        ),
      ),
      body: Padd(
        pad: 10,
        child: BlocBuilder<CompositionsCreatCubit, CompositionsCreatState>(
          builder: (context, state) {
            if (state is CompositionsCreating) {
              selectedParameters = state.selectedParameters;
              parameters = state.selectedParameters.keys.toList();
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Здесь вы сможете добавить характеристики к вашему товару и создать вариации к каждой характеристике товара.",
                    textAlign: TextAlign.center,
                  ),
                  Box(h: 20),
                  ...List.generate(parameters.length, (index) {
                    var attributes = selectedParameters[parameters[index]] ?? [];
                    return ParameterCard(parameter: parameters[index], attributes: attributes);
                  }),
                  Box(h: 10),

                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return DraggableScrollableSheet(
                            expand: false,
                            maxChildSize: 0.85,
                            builder: (context, scrollController) {
                              return ParametersSheet(scrollController);
                            },
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 55,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: EdgeInsets.all(14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Новая характеристикa",
                            style: TextStyle(color: Color(0xFF474747), fontWeight: FontWeight.w500),
                          ),
                          Icon(Icons.add_circle_outline),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
