import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/features/store/bloc/get_store_products/get_store_products_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/helpers.dart';
import '../../global/widgets/meninki_network_image.dart';
import '../../product/bloc/get_products_bloc/get_products_bloc.dart';
import '../../product/widgets/product_card.dart';
import '../../store/bloc/get_stores_bloc/get_stores_bloc.dart';
import '../../store/models/market.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  List<Market> stores = [];
  List<Market> storesProducts = [];
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    context.read<GetStoreProductsBloc>().add(GetProductStores());
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        context.read<GetStoreProductsBloc>().add(PaginateProductStores());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Colors.white,
      onRefresh: () async {
        context.read<GetStoresBloc>().add(GetStores());
        context.read<GetProductsBloc>().add(GetProduct());
        context.read<GetStoreProductsBloc>().add(GetProductStores());
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Box(h: 20),

            ///markets
            BlocBuilder<GetStoresBloc, GetStoresState>(
              builder: (context, state) {
                if (state is GetStoresSuccess) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    if (mounted) {
                      setState(() {
                        stores = state.stores;
                      });
                    }
                  });
                }

                final isLoading = state is GetStoresLoading;
                final itemCount = isLoading ? 5 : stores.length;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 120,
                      child: Skeletonizer(
                        enabled: isLoading,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            // Use dummy store when loading to avoid index errors
                            final store = isLoading ? null : stores[index];
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 120,
                                    width: 90,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: MeninkiNetworkImage(
                                      file: store!.cover_image!,
                                      networkImageType: NetworkImageType.small,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // image
                                  if (store.cover_image != null)
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      // alignment: Alignment.topRight,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(40),
                                          color: Colors.white,
                                        ),
                                        margin: EdgeInsets.only(right: 6, top: 6),
                                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        child: Text(
                                          (store.user_rate_count ?? 0).toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => Box(w: 8),
                          itemCount: itemCount,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Box(h: 20),

            ///reklama
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color(0xFFEAEAEA),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  );
                },
                separatorBuilder: (context, index) => Box(w: 10),
                itemCount: 5,
              ),
            ),
            Box(h: 20),

            ///products
            BlocBuilder<GetProductsBloc, GetProductsState>(
              builder: (context, state) {
                if (state is GetProductLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is GetProductFailed) {
                  return Text(state.message ?? 'error');
                }
                if (state is GetProductSuccess) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Скитки", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      Box(h: 10),
                      SizedBox(
                        height: 240,
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            return ProductCard(product: state.products[index]);
                          },
                          itemCount: state.products.length,
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (BuildContext context, int index) => Box(w: 8),
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),

            ///marketProducts
            BlocBuilder<GetStoreProductsBloc, GetStoreProductsState>(
              builder: (context, state) {
                if (state is GetProductStoresSuccess) {
                  storesProducts = state.stores;
                }
                return ListView.separated(
                  itemCount: storesProducts.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      height: 270,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0xFFF3F3F3), width: 1),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF562846),
                                ),
                              ),
                              Box(w: 10),
                              Text(
                                storesProducts[index].name,
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                            ],
                          ),
                          Box(h: 10),
                          SizedBox(
                            height: 210,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: storesProducts[index].products?.length ?? 0,
                              itemBuilder: (context, productIndex) {
                                return ProductCard(
                                  height: 210,
                                  product: storesProducts[index].products![productIndex],
                                );
                              },
                              separatorBuilder: (context, index) => Box(w: 2),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Box(h: 20),
                );
              },
            ),
            Box(h: 80),
          ],
        ),
      ),
    );
  }
}
