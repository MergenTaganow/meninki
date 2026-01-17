import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/features/product/models/product_atribute.dart';
import 'package:meninki/features/product/models/product_parameters.dart';
import 'package:meninki/features/reels/model/query.dart';
import '../../../core/helpers.dart';
import '../bloc/compositions_creating_cubit/compositions_creat_cubit.dart';
import '../bloc/get_attributes_bloc/get_product_attributes_bloc.dart';

class AttributesSheet extends StatefulWidget {
  final ScrollController controller;
  final ProductParameter parameter;

  const AttributesSheet(this.controller, this.parameter, {super.key});

  @override
  State<AttributesSheet> createState() => _AttributesSheetState();
}

class _AttributesSheetState extends State<AttributesSheet> {
  @override
  void initState() {
    context.read<GetProductAttributesBloc>().add(
      GetProductAttribute(Query(parameter_id: widget.parameter.id)),
    );
    widget.controller.addListener(() {
      if (widget.controller.position.pixels == widget.controller.position.maxScrollExtent) {
        context.read<GetProductAttributesBloc>().add(
          ProductAttributePag(query: Query(parameter_id: widget.parameter.id)),
        );
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xFFF3F3F3), borderRadius: BorderRadius.circular(14)),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: double.infinity),
          Text("Новый аттрибуте", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text("Выберите тип"),
          Box(h: 20),
          Expanded(
            child: BlocBuilder<GetProductAttributesBloc, GetProductAttributesState>(
              builder: (context, state) {
                if (state is GetProductAttributeLoading) {
                  return Center(
                    child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator()),
                  );
                }
                if (state is GetProductAttributeFailed) {
                  return Text(state.message ?? "error");
                }

                List<ProductAttribute> list =
                    state is GetProductAttributeSuccess
                        ? state.productAttributes
                        : state is ProductAttributePagLoading
                        ? state.productAttributes
                        : [];

                return ListView.separated(
                  controller: widget.controller,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        context.read<CompositionsCreatCubit>().selectAttribute(
                          widget.parameter,
                          list[index],
                        );
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: EdgeInsets.all(14),
                        child: Text(
                          list[index].name,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Box(h: 8),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
