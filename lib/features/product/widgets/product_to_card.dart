import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/features/basket/bloc/my_basket_cubit/my_basket_cubit.dart';
import 'package:meninki/features/global/widgets/custom_snack_bar.dart';
import 'package:meninki/features/product/bloc/product_compositions_cubit/product_compositions_cubit.dart';

import '../../../core/colors.dart';
import '../../../core/helpers.dart';
import '../bloc/get_product_by_id/get_product_by_id_cubit.dart';

class ProductToCard extends StatelessWidget {
  const ProductToCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyBasketCubit, MyBasketState>(
      listener: (context, state) {
        if (state is ProductAdded) {
          CustomSnackBar.showSnackBar(context: context, title: "Товар добавлен в корзину");
        }
        if (state is ProductRemoved) {
          CustomSnackBar.showSnackBar(context: context, title: "Товар удален из корзины");
        }
      },
      child: BlocBuilder<GetProductByIdCubit, GetProductByIdState>(
        builder: (context, state) {
          if (state is GetProductByIdSuccess) {
            return BlocBuilder<MyBasketCubit, MyBasketState>(
              builder: (context, basketState) {
                bool alreadyInBasket = false;
                var selectedComposition =
                    context.watch<ProductCompositionsCubit>().selectedComposition;
                if (basketState is MyBasketSuccess && selectedComposition != null) {
                  var index = basketState.compositionIds.indexOf(selectedComposition.id ?? 0);
                  alreadyInBasket = index != -1;
                }
                return Container(
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    border: Border.all(color: Color(0xFFEAEAEA), width: 2),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  margin: EdgeInsets.only(left: 35, right: 35, bottom: 20),
                  child: Row(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${state.product.price} TMT",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "${state.product.discount} TMT",
                            style: TextStyle(color: Color(0xFF969696), fontSize: 12),
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Container(
                            height: 46,
                            width: 46,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Color(0xFFF3F3F3), width: 1.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(child: Icon(Icons.bookmark_border_outlined)),
                          ),
                          Box(w: 10),
                          GestureDetector(
                            onTap: () {
                              if (alreadyInBasket) return;
                              final composition =
                                  context.read<ProductCompositionsCubit>().selectedComposition;

                              if (composition == null) {
                                CustomSnackBar.showYellowSnackBar(
                                  context: context,
                                  title: "select all atributes",
                                );
                                return;
                              }
                              context.read<MyBasketCubit>().addProduct(
                                state.product.id,
                                composition.id!,
                              );
                            },
                            child: Container(
                              height: 46,
                              width: 46,
                              decoration: BoxDecoration(
                                color: alreadyInBasket ? Col.primary : Colors.white,
                                border: Border.all(color: Color(0xFFF3F3F3), width: 1.2),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child:
                                    basketState is MyBasketLoading
                                        ? Padd(pad: 12, child: CircularProgressIndicator())
                                        : Svvg.asset(
                                          'cart',
                                          color: alreadyInBasket ? Colors.white : Colors.black,
                                        ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
