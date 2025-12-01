import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:meninki/core/api.dart';
import 'package:meninki/core/colors.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/global/widgets/meninki_network_image.dart';
import 'package:meninki/features/store/bloc/get_market_by_id/get_market_by_id_cubit.dart';

import '../../home/widgets/reels_list.dart';

class MyStoreDetail extends StatefulWidget {
  const MyStoreDetail({super.key});

  @override
  State<MyStoreDetail> createState() => _MyStoreDetailState();
}

class _MyStoreDetailState extends State<MyStoreDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBFBFB),
      body: BlocBuilder<GetMarketByIdCubit, GetMarketByIdState>(
        builder: (context, state) {
          if (state is GetMarketByIdLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is GetMarketByIdFailed) {
            return Center(child: Text(state.failure.message ?? 'error'));
          }
          if (state is GetMarketByIdSuccess) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.market.cover_image != null)
                    Stack(
                      children: [
                        SizedBox(
                          height: 360,
                          child: MeninkiNetworkImage(
                            file: state.market.cover_image!,
                            networkImageType: NetworkImageType.large,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padd(
                            left: 30,
                            top: 60,
                            child: GestureDetector(
                              onTap: () {
                                Go.pop();
                              },
                              child: Icon(Icons.navigate_before, color: Colors.white, size: 25),
                            ),
                          ),
                        ),
                      ],
                    ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(14),
                    child: Row(
                      children: [
                        if (state.market.cover_image != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: SizedBox(
                              height: 45,
                              width: 45,
                              child: MeninkiNetworkImage(
                                file: state.market.cover_image!,
                                networkImageType: NetworkImageType.small,
                              ),
                            ),
                          ),
                        Box(w: 14),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.market.name,
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Go.to(Routes.productCreate, argument: {'storeId': state.market.id});
                          },
                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Col.primary,
                            ),
                            child: Center(child: Icon(Icons.add_circle, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Box(h: 10),
                  Padd(
                    hor: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        singleRow(title: "Телефон", value: "+993 62 66 66 66 "),
                        singleRow(title: "Описание", value: state.market.description ?? ''),
                        singleRow(title: "Юзернейм", value: state.market.username ?? ''),
                        Row(
                          children: [
                            Expanded(
                              child: card(
                                child: Padd(
                                  ver: 10,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Подписчики"),
                                      Text(
                                        state.market.user_favorite_count.toString(),
                                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Box(w: 10),
                            Expanded(
                              child: card(
                                child: Padd(
                                  ver: 10,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Место в рейтинге"),
                                      Text(
                                        state.market.rate_count.toString(),
                                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        ReelsList(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Column singleRow({required String title, required String value}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 12, color: Color(0xFF969696))),
        Text(value),
        Box(h: 12),
      ],
    );
  }

  Widget card({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFFF3F3F3)),
      ),
      child: child,
    );
  }
}
