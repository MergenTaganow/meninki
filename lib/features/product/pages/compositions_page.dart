import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/features/product/bloc/compositions_send_cubit/compositions_send_cubit.dart';
import 'package:meninki/features/product/models/product.dart';
import '../../../core/colors.dart';
import '../../../core/go.dart';
import '../../../core/routes.dart';
import '../../global/widgets/custom_snack_bar.dart';
import '../../store/widgets/store_sheet.dart';
import '../bloc/compositions_creating_cubit/compositions_creat_cubit.dart';
import '../bloc/get_products_bloc/get_products_bloc.dart';
import '../models/product_atribute.dart';
import '../models/product_parameters.dart';

class CompositionsPage extends StatefulWidget {
  final Product product;

  const CompositionsPage(this.product, {super.key});

  @override
  State<CompositionsPage> createState() => _CompositionsPageState();
}

class _CompositionsPageState extends State<CompositionsPage> {
  List<List<ProductAttribute>> compositions = [];
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    compositions = generateProductCombinations(
      context.read<CompositionsCreatCubit>().selectedParameters,
    );
    for (var i in compositions) {
      controllers.add(TextEditingController());
    }
    super.initState();
  }

  @override
  void dispose() {
    for (var i in controllers) {
      i.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CompositionsSendCubit, CompositionsSendState>(
      listener: (context, state) {
        if (state is CompositionsSendSuccess) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Go.to(Routes.publicProductDetailPage, argument: {'productId': widget.product.id});
          CustomSnackBar.showSnackBar(
            context: context,
            title: AppLocalizations.of(context)!.success,
            isError: false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.compositions)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: BlocBuilder<CompositionsSendCubit, CompositionsSendState>(
          builder: (context, state) {
            return InkWell(
              onTap: () {
                if (widget.product.compositions?.isNotEmpty ?? false) {
                  context.read<CompositionsSendCubit>().edit(
                    product: widget.product,
                    compositions: compositions,
                    counts: getCountsFromControllers(controllers),
                  );
                } else {
                  context.read<CompositionsSendCubit>().send(
                    productId: widget.product.id,
                    compositions: compositions,
                    counts: getCountsFromControllers(controllers),
                  );
                }
              },
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Col.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                margin: EdgeInsets.symmetric(horizontal: 14),
                child: Center(
                  child:
                      state is CompositionsSendLoading
                          ? CircularProgressIndicator(color: Col.white)
                          : Text(
                            AppLocalizations.of(context)!.save,
                            style: TextStyle(color: Colors.white),
                          ),
                ),
              ),
            );
          },
        ),
        body: Padd(
          hor: 10,
          ver: 20,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.specifyPricesBeforeDiscount,
                  textAlign: TextAlign.center,
                ),
                Box(h: 20),
                Text(
                  "${AppLocalizations.of(context)!.productVariations}  -  ${compositions.length}",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Box(h: 10),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, compositionIndex) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFEAEAEA)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(
                        bottom: compositionIndex == compositions.length - 1 ? 80 : 0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: List.generate(compositions[compositionIndex].length, (
                                    index,
                                  ) {
                                    var list = compositions[compositionIndex];
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF3F3F3),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                                      child: Text(
                                        list[index].name.trans(context),
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return AreYouSureSheet(
                                        title: "Хотите удалить етот композитион?",
                                        onYes: () {
                                          setState(() {
                                            compositions.removeAt(compositionIndex);
                                            controllers.removeAt(compositionIndex);
                                          });
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Svvg.asset('delete', size: 25),
                              ),
                            ],
                          ),
                          Box(h: 10),
                          SizedBox(
                            height: 45,
                            child: TexField(
                              ctx: context,
                              cont: controllers[compositionIndex],
                              border: true,
                              borderColor: Color(0xFF474747),
                              borderRadius: 14,
                              textAlign: TextAlign.center,
                              hint: AppLocalizations.of(context)!.howManyItems,
                              keyboard: TextInputType.numberWithOptions(decimal: true),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: compositions.length,
                  separatorBuilder: (BuildContext context, int index) => Box(h: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Generates all possible combinations of selected attributes
  /// selectedParameters: Map<ProductParameter, List<ProductAttribute>>
  /// Returns List<List<ProductAttribute>> where each inner list is one combination
  List<List<ProductAttribute>> generateProductCombinations(
    Map<ProductParameter, List<ProductAttribute>> selectedParameters,
  ) {
    if (selectedParameters.isEmpty) return [];

    // Convert Map values to a List of Lists
    List<List<ProductAttribute>> lists = selectedParameters.values.toList();

    // Recursive function to generate Cartesian product
    List<List<ProductAttribute>> cartesianProduct(List<List<ProductAttribute>> lists, int depth) {
      if (depth == lists.length) return [[]];

      List<List<ProductAttribute>> result = [];
      for (var attr in lists[depth]) {
        for (var combination in cartesianProduct(lists, depth + 1)) {
          result.add([attr, ...combination]);
        }
      }
      return result;
    }

    return cartesianProduct(lists, 0);
  }

  List<num> getCountsFromControllers(List<TextEditingController> controllers) {
    return controllers.map((controller) {
      final text = controller.text.trim();
      if (text.isEmpty) return 0;

      // Try parsing as integer first
      final intValue = int.tryParse(text);
      if (intValue != null) return intValue;

      // Try parsing as double
      final doubleValue = double.tryParse(text);
      if (doubleValue != null) return doubleValue;

      // Fallback if parsing fails
      return 0;
    }).toList();
  }
}
