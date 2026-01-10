import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:meninki/features/product/bloc/get_products_bloc/get_products_bloc.dart';
import 'package:meninki/features/product/models/product.dart';
import 'package:meninki/features/product/widgets/product_card.dart';
import 'package:meninki/features/reels/model/query.dart';
import '../../../core/colors.dart';
import '../../../core/helpers.dart';

class StoreProductsList extends StatefulWidget {
  final Query query;
  const StoreProductsList({required this.query, super.key});

  @override
  State<StoreProductsList> createState() => _StoreProductsListState();
}

class _StoreProductsListState extends State<StoreProductsList> {
  List<Product> products = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetOneStoresProducts, GetProductsState>(
      builder: (context, state) {
        if (state is GetProductLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is GetProductSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            setState(() {
              products = state.products;
            });
          });
        }

        if (state is GetProductFailed) {
          // return ErrorPage(
          //   fl: state.fl,
          //   onRefresh: () {
          //     context.read<GetOrdersBloc>().add(RefreshLastOrders());
          //   },
          // );
          return Text("error");
        }

        if (products.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Svvg.asset('_emptyy'),
              const Box(h: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Col.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                onPressed: () {
                  context.read<GetOneStoresProducts>().add(GetProduct(widget.query));
                },
                child: SizedBox(
                  height: 45,
                  child: Center(
                    child: Padd(
                      hor: 10,
                      child: Text(
                        "lg.tryAgain",
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return MasonryGridView.count(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 8,
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ProductCard(product: products[index]);
          },
        );
        // if (state is ReelPagLoading) const CircularProgressIndicator(),
      },
    );
  }
}
