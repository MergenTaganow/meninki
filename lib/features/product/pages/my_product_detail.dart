import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meninki/core/colors.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/global/widgets/custom_snack_bar.dart';
import 'package:meninki/features/product/bloc/get_product_by_id/get_product_by_id_cubit.dart';
import 'package:meninki/features/product/bloc/product_compositions_cubit/product_compositions_cubit.dart';
import 'package:meninki/features/product/models/product.dart';
import 'package:meninki/features/reels/blocs/reel_create_cubit/reel_create_cubit.dart';
import 'package:meninki/features/reels/model/query.dart';
import 'package:meninki/features/store/widgets/store_sheet.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../global/widgets/meninki_network_image.dart';
import '../../home/widgets/product_reels_list.dart';
import '../../reels/blocs/file_upl_cover_image_bloc/file_upl_cover_image_bloc.dart';
import '../../reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import '../widgets/compositions_list.dart';
import '../widgets/later_uploading_reel.dart';
import '../widgets/product_to_card.dart';

class MyProductDetailPage extends StatefulWidget {
  final int productId;

  const MyProductDetailPage(this.productId, {super.key});

  @override
  State<MyProductDetailPage> createState() => _MyProductDetailPageState();
}

class _MyProductDetailPageState extends State<MyProductDetailPage> {
  Product? product;

  @override
  void initState() {
    context.read<GetProductByIdCubit>().getProduct(widget.productId);
    context.read<GetProductReelsBloc>().add(ClearReels());
    super.initState();
  }

  @override
  void deactivate() {
    context.read<GetProductByIdCubit>().clear();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GetProductByIdCubit, GetProductByIdState>(
          listener: (context, state) {
            if (state is GetProductByIdSuccess) {
              context.read<ProductCompositionsCubit>().setProduct(state.product);
            }
          },
        ),
        BlocListener<ReelCreateCubit, ReelCreateState>(
          listener: (context, state) {
            if (state is ReelCreateSuccess) {
              CustomSnackBar.showSnackBar(
                context: context,
                title: AppLocalizations.of(context)!.successfullyCreated,
                isError: false,
              );
            }
          },
        ),
        BlocListener<FileUplCoverImageBloc, FileUplCoverImageState>(
          listener: (context, state) {
            if (state is FileUploadCoverImageSuccess) {
              var laterReel = context.read<ReelCreateCubit>().laterCreateReel;
              if (laterReel?['link_id'] == widget.productId) {
                context.read<ReelCreateCubit>().sendLaterReel(state.file.id);
              }
            }
          },
        ),
        BlocListener<GetProductByIdCubit, GetProductByIdState>(
          listener: (context, state) {
            if (state is GetProductByIdSuccess) {
              context.read<GetProductReelsBloc>().add(GetReel(Query(product_id: state.product.id)));
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.product),
          actions: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return ProductSheet(product!);
                  },
                );
              },
              child: Padd(right: 16, child: Icon(Icons.more_vert_outlined)),
            ),
          ],
          scrolledUnderElevation: 0,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ProductToCard(),
        body: BlocBuilder<GetProductByIdCubit, GetProductByIdState>(
          builder: (context, state) {
            if (state is GetProductByIdLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is GetProductByIdFailed) {
              return Center(
                child: Text(state.failure.message ?? AppLocalizations.of(context)!.error),
              );
            }
            if (state is GetProductByIdSuccess) {
              product = state.product;
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<GetProductByIdCubit>().getProduct(state.product.id);
                },
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.product.product_files?.isNotEmpty ?? false)
                        SizedBox(
                          height: 250,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padd(
                                left: index == 0 ? 10 : 0,
                                child: SizedBox(
                                  height: 250,
                                  width: MediaQuery.sizeOf(context).width * 0.5,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: MeninkiNetworkImage(
                                      file: state.product.product_files![index],
                                      networkImageType: NetworkImageType.large,
                                      fit: BoxFit.cover,
                                      otherFiles: state.product.product_files,
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => Box(w: 10),
                            itemCount: state.product.product_files?.length ?? 0,
                          ),
                        ),
                      Padd(
                        hor: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Box(h: 20),
                            Text(
                              state.product.name.tk ?? '',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            Box(h: 10),
                            CompositionsList(state.product),
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
                            LaterUploadingReel(product: state.product),
                            Box(h: 20),
                            Text(
                              state.product.description?.tk ?? '',
                              style: TextStyle(fontSize: 16),
                            ),
                            Box(h: 20),
                            Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                splashColor: Colors.white.withOpacity(0.25),
                                highlightColor: Colors.white.withOpacity(0.15),
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Go.to(
                                    Routes.reelCreatePage,
                                    argument: {"product": state.product},
                                  );
                                },
                                child: Ink(
                                  height: 46,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Col.primary,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.createProductReview,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
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
                                  if (state.product.created_at != null)
                                    singleLine(
                                      "${AppLocalizations.of(context)!.published}:",
                                      DateFormat('dd.MM.yyyy').format(state.product.created_at!),
                                    ),
                                  singleLine(
                                    "${AppLocalizations.of(context)!.views}:",
                                    state.product.rate_count.toString() ?? '-',
                                  ),
                                  singleLine(
                                    "${AppLocalizations.of(context)!.brand}:",
                                    state.product.brand?.name ?? '-',
                                  ),
                                  singleLine(
                                    "${AppLocalizations.of(context)!.category}:",
                                    state.product.categories
                                            ?.map((e) => e.name?.trans(context))
                                            .toList()
                                            .join('/') ??
                                        '-',
                                  ),
                                ],
                              ),
                            ),
                            Box(h: 20),
                            ProductReelsList(query: Query(product_ids: [state.product.id])),
                            Box(h: 100),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Row singleLine(String title, String value) {
    return Row(
      children: [
        Text(title, style: TextStyle(color: Color(0xFF969696))),
        Expanded(child: Text(value, textAlign: TextAlign.right)),
      ],
    );
  }
}
