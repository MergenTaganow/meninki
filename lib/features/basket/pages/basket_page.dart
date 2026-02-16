import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/features/basket/bloc/get_basket_cubit/get_basket_cubit.dart';
import 'package:meninki/features/basket/bloc/my_basket_cubit/my_basket_cubit.dart';
import 'package:meninki/features/basket/models/basket_product.dart';
import 'package:meninki/features/global/widgets/meninki_network_image.dart';

import '../../../core/colors.dart';
import '../../../core/helpers.dart';
import '../../global/widgets/custom_snack_bar.dart';

class BasketPage extends StatelessWidget {
  const BasketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BasketWidget());
  }
}

class BasketWidget extends StatefulWidget {
  const BasketWidget({super.key});

  @override
  State<BasketWidget> createState() => _BasketWidgetState();
}

class _BasketWidgetState extends State<BasketWidget> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    context.read<GetBasketCubit>().getMyBasket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;
    super.build(context);
    return BlocListener<MyBasketCubit, MyBasketState>(
      listener: (context, state) {
        if (state is ProductAdded) {
          CustomSnackBar.showSnackBar(context: context, title: lg.productUpdated);
        }
        if (state is ProductRemoved) {
          CustomSnackBar.showSnackBar(context: context, title: lg.productRemoved);
        }
        if (state is MyBasketFailed) {
          CustomSnackBar.showSnackBar(
            isError: true,
            context: context,
            title: state.failure.message ?? lg.smthWentWrong,
          );
        }
      },
      child: Column(
        children: [
          Material(
            color: Colors.transparent, // keeps background transparent
            borderRadius: BorderRadius.circular(12), // optional, for rounded ripple
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              splashColor: Colors.black.withOpacity(0.15), // ripple effect
              highlightColor: Colors.black.withOpacity(0.05), // pressed effect
              onTap: () {
                // Your tap action here
                print("Мои заказы tapped!");
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    Text(lg.myOrders, style: TextStyle(fontWeight: FontWeight.w500)),
                    Spacer(),
                    Svvg.asset("order_history"),
                  ],
                ),
              ),
            ),
          ),
          Divider(color: Color(0xFFF3F3F3), height: 1),
          Expanded(
            child: BlocBuilder<GetBasketCubit, GetBasketState>(
              builder: (context, state) {
                if (state is GetBasketSuccess) {
                  if (state.products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            lg.basketEmpty,
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                          ),
                          Box(h: 20),
                          Text(lg.addMoreProducts, style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    );
                  }
                  num sum = 0;
                  for (var i in state.products) {
                    sum += i.composition?.product?.price ?? 0;
                  }
                  return SafeArea(
                    child: Column(
                      children: [
                        Padd(
                          left: 14,
                          right: 14,
                          top: 8,
                          bot: 10,
                          child: Row(
                            children: [
                              Text(
                                '${state.products.length} ${lg.productsCount}',
                                style: TextStyle(color: Color(0xFF474747)),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  clearAll(context);
                                },
                                child: Svvg.asset('clear_card'),
                              ),
                            ],
                          ),
                        ),
                        Divider(color: Color(0xFFF3F3F3), height: 1),

                        Padd(
                          hor: 10,
                          ver: 10,
                          child: Row(
                            children: [
                              Text(
                                "$sum TMT",
                                style: TextStyle(
                                  color: Col.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                borderRadius: BorderRadius.circular(14),
                                splashColor: Colors.white.withOpacity(0.25),
                                highlightColor: Colors.white.withOpacity(0.15),
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                },
                                child: Ink(
                                  height: 46,
                                  padding: EdgeInsets.symmetric(horizontal: 14),
                                  decoration: BoxDecoration(
                                    color: Col.primary,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Продолжить",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: Padd(
                            hor: 14,
                            child: ListView.separated(
                              itemBuilder: (BuildContext context, int index) {
                                var product = state.products[index];
                                return Padd(
                                  bot: index == state.products.length - 1 ? 150 : 0,
                                  child: IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: Container(
                                            height: 170,
                                            width: 120,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child:
                                                product.composition?.product?.cover_image != null
                                                    ? MeninkiNetworkImage(
                                                      file:
                                                          product
                                                              .composition!
                                                              .product!
                                                              .cover_image!,
                                                      networkImageType: NetworkImageType.medium,
                                                      fit: BoxFit.cover,
                                                    )
                                                    : null,
                                          ),
                                        ),
                                        Box(w: 10),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.composition?.title?.trans(context) ?? '',
                                                style: TextStyle(fontWeight: FontWeight.w500),
                                              ),
                                              Box(h: 10),
                                              Text(
                                                '${product.composition?.product?.price} TMT',
                                                style: TextStyle(fontWeight: FontWeight.w600),
                                              ),
                                              Text(
                                                '${product.composition?.product?.discount} TMT',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF969696),
                                                ),
                                              ),
                                              Spacer(),
                                              actionButtons(product),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) => Box(h: 10),
                              itemCount: state.products.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Row actionButtons(BasketProduct product) {
    return Row(
      children: [
        BlocBuilder<MyBasketCubit, MyBasketState>(
          builder: (context, state) {
            return Material(
              color: Colors.transparent, // keeps your Container color intact
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                splashColor: Colors.black.withOpacity(0.15), // ripple color
                highlightColor: Colors.black.withOpacity(0.05), // pressed color
                onTap: () {
                  if (state is! MyBasketLoading) {
                    HapticFeedback.selectionClick();
                    if (product.quantity == 1) {
                      context.read<MyBasketCubit>().removeProduct(
                        product.id ?? 0,
                        product.composition?.id ?? 0,
                      );
                    } else {
                      context.read<MyBasketCubit>().updateProduct(
                        product: product,
                        isAdding: false,
                      );
                    }
                  }
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child:
                        (state is MyBasketLoading &&
                                state.loadingId == product.composition?.id &&
                                state.loadingAction == 'remove')
                            ? Padd(pad: 8, child: CircularProgressIndicator(strokeWidth: 2))
                            : product.quantity == 1
                            ? Svvg.asset('delete', size: 25)
                            : Text('-', style: TextStyle(fontSize: 22)),
                  ),
                ),
              ),
            );
          },
        ),
        Padd(hor: 10, child: Text(product.quantity.toString(), style: TextStyle(fontSize: 16))),
        BlocBuilder<MyBasketCubit, MyBasketState>(
          builder: (context, state) {
            return Material(
              color: Colors.transparent, // keeps your Container color intact
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                splashColor: Colors.black.withOpacity(0.15), // ripple color
                highlightColor: Colors.black.withOpacity(0.05), // pressed color
                onTap: () {
                  if ((product.quantity ?? 0) + 1 <= (product.composition?.quantity ?? 0)) {
                    if (state is! MyBasketLoading) {
                      HapticFeedback.selectionClick();
                      context.read<MyBasketCubit>().updateProduct(product: product, isAdding: true);
                    }
                  }
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child:
                        (state is MyBasketLoading &&
                                state.loadingId == product.composition?.id &&
                                state.loadingAction == 'add')
                            ? Padd(pad: 8, child: CircularProgressIndicator(strokeWidth: 2))
                            : Text(
                              '+',
                              style: TextStyle(
                                fontSize: 22,
                                color:
                                    ((product.quantity ?? 0) + 1 <=
                                            (product.composition?.quantity ?? 0))
                                        ? Colors.black
                                        : Color(0xFF969696).withOpacity(0.8),
                              ),
                            ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Future<dynamic> clearAll(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;
    return showModalBottomSheet(
      backgroundColor: Color(0xFFF3F3F3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) {
        return Padd(
          hor: 16,
          ver: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(lg.deleteQuestion, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Box(h: 6),
              Text(lg.deleteConfirmation),
              Box(h: 20),
              Material(
                color: Colors.white, // 👈 MOVE background HERE
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  splashColor: Colors.black.withOpacity(0.15),
                  highlightColor: Colors.black.withOpacity(0.05),
                  onTap: () {
                    context.read<MyBasketCubit>().clearBasket();
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 46,
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(lg.yes, style: TextStyle(fontWeight: FontWeight.w500)),
                        Svvg.asset('clear_sure'),
                      ],
                    ),
                  ),
                ),
              ),
              Box(h: 8),
              Material(
                color: Colors.white, // 👈 MOVE background HERE
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  splashColor: Colors.black.withOpacity(0.15),
                  highlightColor: Colors.black.withOpacity(0.05),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 46,
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(lg.no, style: TextStyle(fontWeight: FontWeight.w500)),
                        Svvg.asset('save'),
                      ],
                    ),
                  ),
                ),
              ),
              Box(h: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => false;
}
