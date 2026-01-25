import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helpers.dart';
import '../bloc/compositions_creating_cubit/compositions_creat_cubit.dart';
import '../bloc/get_parameters_bloc/get_product_parameters_bloc.dart';
import '../models/product_parameters.dart';

class ParametersSheet extends StatefulWidget {
  final ScrollController controller;

  const ParametersSheet(this.controller, {super.key});

  @override
  State<ParametersSheet> createState() => _ParametersSheetState();
}

class _ParametersSheetState extends State<ParametersSheet> {
  @override
  void initState() {
    context.read<GetProductParametersBloc>().add(GetProductParameter());
    widget.controller.addListener(() {
      if (widget.controller.position.pixels == widget.controller.position.maxScrollExtent) {
        context.read<GetProductParametersBloc>().add(ProductParameterPag());
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
          Container(width: double.infinity),
          Text(AppLocalizations.of(context)!.newCharacteristic, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text(AppLocalizations.of(context)!.selectType),
          Box(h: 20),
          Expanded(
            child: BlocBuilder<GetProductParametersBloc, GetProductParametersState>(
              builder: (context, state) {
                if (state is GetProductParameterLoading) {
                  return Center(
                    child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator()),
                  );
                }
                if (state is GetProductParameterFailed) {
                  return Text(state.message ?? AppLocalizations.of(context)!.error);
                }

                List<ProductParameter> list =
                    state is GetProductParameterSuccess
                        ? state.productParameters
                        : state is ProductParameterPagLoading
                        ? state.productParameters
                        : [];

                return ListView.separated(
                  controller: widget.controller,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        context.read<CompositionsCreatCubit>().selectParameter(list[index]);
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
                          list[index].name.trans(context),
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
