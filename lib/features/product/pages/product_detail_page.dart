import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/colors.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/home/widgets/reels_list.dart';
import 'package:meninki/features/product/bloc/get_product_by_id/get_product_by_id_cubit.dart';
import 'package:meninki/features/reels/blocs/reel_create_cubit/reel_create_cubit.dart';
import 'package:meninki/features/reels/model/query.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../global/widgets/meninki_network_image.dart';
import '../../home/widgets/product_reels_list.dart';
import '../../reels/blocs/file_upl_cover_image_bloc/file_upl_cover_image_bloc.dart';
import '../../reels/blocs/get_reels_bloc/get_reels_bloc.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  const ProductDetailPage(this.productId, {super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  PageController productImagesController = PageController();

  @override
  void initState() {
    context.read<GetProductByIdCubit>().getProduct(widget.productId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FileUplCoverImageBloc, FileUplCoverImageState>(
          listener: (context, state) {
            if (state is FileUploadCoverImageSuccess) {
              var laterReel = context.read<ReelCreateCubit>().laterCreateReel;
              if (laterReel?['product_id'] == widget.productId) {
                context.read<ReelCreateCubit>().sendLaterReel(state.file.id);
              }
            }
          },
        ),
        BlocListener<GetProductByIdCubit, GetProductByIdState>(
          listener: (context, state) {
            if (state is GetProductByIdSuccess) {
              context.read<GetProductReelsBloc>().add(
                GetReel(Query(product_ids: [state.product.id])),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text("Товар"), actions: [Svvg.asset('share')]),
        body: Padd(
          pad: 10,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<GetProductByIdCubit, GetProductByIdState>(
                  builder: (context, state) {
                    if (state is GetProductByIdLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is GetProductByIdFailed) {
                      return Center(child: Text(state.failure.message ?? 'error'));
                    }
                    if (state is GetProductByIdSuccess) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.product.product_files?.isNotEmpty ?? false)
                            SizedBox(
                              height: 250,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: PageView(
                                      controller: productImagesController,
                                      children:
                                          state.product.product_files!
                                              .map(
                                                (e) => SizedBox(
                                                  height: 250,
                                                  width: MediaQuery.sizeOf(context).width,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(14),
                                                    child: MeninkiNetworkImage(
                                                      file: e,
                                                      networkImageType: NetworkImageType.large,
                                                      fit: BoxFit.cover,
                                                      otherFiles: state.product.product_files,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                    ),
                                  ),
                                  Box(h: 10),
                                  SmoothPageIndicator(
                                    controller: productImagesController,
                                    count: state.product.product_files?.length ?? 0,
                                    effect: WormEffect(
                                      dotHeight: 8,
                                      dotWidth: 8,
                                      activeDotColor: Col.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Box(h: 20),
                          Text(
                            state.product.name.tk ?? '',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          Box(h: 20),
                          //market
                          Container(
                            height: 66,
                            decoration: BoxDecoration(
                              color: Color(0xFFF3F3F3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            child: Row(
                              children: [
                                if (state.product.market?.cover_image != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Container(
                                      height: 36,
                                      width: 36,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.black, width: 2),
                                      ),
                                      child: MeninkiNetworkImage(
                                        file: state.product.market!.cover_image!,
                                        networkImageType: NetworkImageType.small,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                Box(w: 10),
                                Expanded(
                                  child: Text(
                                    state.product.market?.name ?? '',
                                    maxLines: 2,
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Box(w: 10),
                                Container(
                                  height: 46,
                                  width: 46,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Center(child: Svvg.asset("message")),
                                ),
                              ],
                            ),
                          ),
                          BlocBuilder<ReelCreateCubit, ReelCreateState>(
                            builder: (context, reelCreateState) {
                              if (reelCreateState is LaterCreateReel) {}
                              if (reelCreateState is LaterCreateReel &&
                                  reelCreateState.map['link_id'] == state.product.id) {
                                return Container(
                                  height: 66,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF3F3F3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: EdgeInsets.only(top: 8),
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                  child: BlocBuilder<FileUplCoverImageBloc, FileUplCoverImageState>(
                                    builder: (context, fileState) {
                                      if (fileState is FileUploadCoverImageFailure) {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Reel uploading error',
                                                maxLines: 2,
                                                style: TextStyle(fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                            Box(w: 10),
                                            GestureDetector(
                                              onTap: () {
                                                Go.to(
                                                  Routes.reelCreatePage,
                                                  argument: {
                                                    'laterCreateReel': reelCreateState.map,
                                                    'product': state.product,
                                                  },
                                                );
                                              },
                                              child: Container(
                                                height: 46,
                                                width: 46,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(14),
                                                ),
                                                child: Center(
                                                  child: Icon(Icons.refresh, color: Col.black),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      return Row(
                                        children: [
                                          Text(
                                            'Reel is uploading',
                                            maxLines: 2,
                                            style: TextStyle(fontWeight: FontWeight.w500),
                                          ),
                                          Box(w: 10),
                                          Expanded(
                                            child: LinearProgressIndicator(
                                              value:
                                                  fileState is FileUploadingCoverImage
                                                      ? fileState.progress
                                                      : null,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                          Box(h: 20),
                          Text(state.product.description?.tk ?? '', style: TextStyle(fontSize: 16)),
                          Box(h: 20),
                          GestureDetector(
                            onTap: () {
                              Go.to(Routes.reelCreatePage, argument: {"product": state.product});
                            },
                            child: Container(
                              height: 46,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Col.primary,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Text(
                                  "Создать обзор на товар",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Box(h: 20),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF3F3F3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Опубликовано:",
                                      style: TextStyle(color: Color(0xFF969696)),
                                    ),
                                    Expanded(
                                      child: Text(
                                        state.product.created_at ?? '-',
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Просмотры:", style: TextStyle(color: Color(0xFF969696))),
                                    Expanded(
                                      child: Text(
                                        //Todo need to change to viewCount
                                        state.product.rate_count.toString() ?? '-',
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Категория:", style: TextStyle(color: Color(0xFF969696))),
                                    Expanded(
                                      child: Text(
                                        state.product.categories
                                                ?.map((e) => e.name)
                                                .toList()
                                                .join('/') ??
                                            '-',
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Box(h: 20),
                          ProductReelsList(query: Query(product_ids: [state.product.id])),
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
      ),
    );
  }
}
