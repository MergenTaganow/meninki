import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/colors.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/features/categories/bloc/brand_selecting_cubit/brand_selecting_cubit.dart';
import 'package:meninki/features/categories/bloc/get_brands_bloc/get_brands_bloc.dart';

import '../../../core/helpers.dart';

class BrandSelectingPage extends StatefulWidget {
  const BrandSelectingPage({super.key});

  @override
  State<BrandSelectingPage> createState() => _BrandSelectingPageState();
}

class _BrandSelectingPageState extends State<BrandSelectingPage> {
  @override
  void initState() {
    context.read<GetBrandsBloc>().add(GetBrand());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Бренды", style: TextStyle(fontWeight: FontWeight.w500))),
      body: Padd(
        pad: 10,
        child: BlocBuilder<GetBrandsBloc, GetBrandsState>(
          builder: (context, state) {
            if (state is GetBrandLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is GetBrandFailed) {
              return Center(child: Text(state.message ?? "error"));
            }
            var brands =
                state is GetBrandSuccess
                    ? state.brands
                    : state is BrandPagLoading
                    ? state.brands
                    : [];
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return BlocBuilder<BrandSelectingCubit, BrandSelectingState>(
                        builder: (context, state) {
                          var selectedIndex =
                              state is BrandSelectingSuccess
                                  ? (state.selectedMap[BrandSelectingCubit
                                              .product_creating_brand] ??
                                          [])
                                      .indexWhere((e) => e.id == brands[index].id)
                                  : -1;
                          return InkWell(
                            onTap: () {
                              context.read<BrandSelectingCubit>().selectBrand(
                                BrandSelectingCubit.product_creating_brand,
                                brands[index],
                                true,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(14),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    brands[index].name,
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  Box(w: 14),
                                  if (selectedIndex != -1)
                                    Icon(Icons.check, color: Color(0xFF969696)),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) => Box(h: 6),
                    itemCount: brands.length,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Go.pop();
                  },
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Col.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(child: Text('Сохранить', style: TextStyle(color: Colors.white))),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
