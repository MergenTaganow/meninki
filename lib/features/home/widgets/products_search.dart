import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/colors.dart';
import '../../../core/helpers.dart';
import '../../product/bloc/get_products_bloc/get_products_bloc.dart';
import '../../product/widgets/product_card.dart';

class ProductsSearch extends StatefulWidget {
  const ProductsSearch({super.key});

  @override
  State<ProductsSearch> createState() => _ProductsSearchState();
}

class _ProductsSearchState extends State<ProductsSearch> {
  TextEditingController search = TextEditingController();
  List<String> categoryTypes = ['Обзоры', 'Товары', 'Объявления', 'Магазины'];
  String selectedType = 'Обзоры';

  @override
  void initState() {
    search.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padd(
      hor: 10,
      ver: 20,
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<GetProductsBloc>().add(GetProduct());
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              ///search
              SizedBox(
                height: 55,
                child: TextField(
                  controller: search,
                  decoration: InputDecoration(
                    fillColor: Color(0xFFF3F3F3),
                    filled: true,
                    prefixIcon: Icon(Icons.search, color: Color(0xFF969696)),
                    suffixIcon:
                        search.text.isNotEmpty
                            ? GestureDetector(
                              onTap: () {
                                search.clear();
                              },
                              child: Icon(Icons.highlight_remove_rounded, color: Color(0xFF474747)),
                            )
                            : null,
                    hintText: "Поиск",
                    hintStyle: TextStyle(color: Color(0xFF969696)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.white, width: 0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.white, width: 0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Color(0xFF0A0A0A), width: 1),
                    ),
                  ),
                ),
              ),
              Box(h: 10),

              ///categories
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        selectedType = categoryTypes[index];
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              selectedType == categoryTypes[index]
                                  ? Col.primary
                                  : Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        child: Text(
                          categoryTypes[index],
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color:
                                selectedType == categoryTypes[index]
                                    ? Col.white
                                    : Color(0xFF474747),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Box(w: 6),
                  itemCount: categoryTypes.length,
                ),
              ),
              Box(h: 20),

              ///body
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
                        Row(
                          children: [
                            Svvg.asset('sort', size: 20),
                            Box(w: 4),
                            Text("Фильтр и сортировка", style: TextStyle(color: Color(0xFF474747))),
                          ],
                        ),
                        Box(h: 20),
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
            ],
          ),
        ),
      ),
    );
  }
}
