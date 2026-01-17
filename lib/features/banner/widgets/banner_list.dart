import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/routes.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:meninki/features/banner/models/banner.dart' as banner;
import '../../../core/helpers.dart';
import '../../global/widgets/meninki_network_image.dart';
import '../../store/bloc/get_market_by_id/get_market_by_id_cubit.dart';
import '../bloc/get_banners_bloc/get_banners_bloc.dart';

class BannersList extends StatelessWidget {
  final int priority;

  const BannersList({required this.priority, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetBannersBloc, GetBannersState>(
      builder: (context, state) {
        final isLoading = state is GetBannerLoading;
        final isSuccess = state is GetBannerSuccess;

        final list = isSuccess ? (state.banners[priority] ?? []) : <banner.Banner>[];

        return AnimatedCrossFade(
          duration: const Duration(milliseconds: 380),
          firstCurve: Curves.easeOut,
          secondCurve: Curves.easeIn,
          sizeCurve: Curves.easeInOut,
          crossFadeState: isLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: const BannerSkeleton(),
          secondChild: BannerListWidget(list: list, priority: priority),
        );
      },
    );
    // return BlocBuilder<GetBannersBloc, GetBannersState>(
    //   buildWhen: (prev, curr) => curr is GetBannerSuccess,
    //   builder: (context, state) {
    //     if (state is! GetBannerSuccess) return const SizedBox.shrink();
    //
    //     final list = state.banners[priority] ?? [];
    //
    //     if (list.isEmpty) return const SizedBox.shrink();
    //
    //     final type = list.first.size_type;
    //
    //     double height;
    //     NetworkImageType imageType;
    //
    //     switch (type) {
    //       case 'medium':
    //         height = 220;
    //         imageType = NetworkImageType.medium;
    //         break;
    //       case 'large':
    //         height = 290;
    //         imageType = NetworkImageType.large;
    //         break;
    //       default:
    //         height = 150;
    //         imageType = NetworkImageType.small;
    //     }
    //
    //     return SizedBox(
    //       height: height,
    //       child: ListView.separated(
    //         scrollDirection: Axis.horizontal,
    //         itemCount: list.length,
    //         separatorBuilder: (_, __) => const Box(w: 10),
    //         itemBuilder: (context, index) {
    //           return Padd(
    //             left: index == 0 ? 10 : 0,
    //             child: Ink(
    //               width:
    //                   MediaQuery.of(context).size.width * (list.length > 1 ? 0.9 : 1) -
    //                   (list.length > 1 ? 0 : 20),
    //               child: ClipRRect(
    //                 borderRadius: BorderRadius.circular(14),
    //                 child: Container(
    //                   width:
    //                       MediaQuery.of(context).size.width * (list.length > 1 ? 0.9 : 1) -
    //                       (list.length > 1 ? 0 : 20),
    //                   height: height,
    //                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
    //                   child: Stack(
    //                     alignment: Alignment.center,
    //                     children: [
    //                       if (list[index].file != null)
    //                         IgnorePointer(
    //                           ignoring: true,
    //                           child: MeninkiNetworkImage(
    //                             file: list[index].file!,
    //                             networkImageType: imageType,
    //                             fit: BoxFit.contain,
    //                           ),
    //                         ),
    //                       Material(
    //                         color: Colors.transparent,
    //                         borderRadius: BorderRadius.circular(14),
    //                         child: InkWell(
    //                           borderRadius: BorderRadius.circular(14),
    //                           splashColor: Colors.black.withOpacity(0.15),
    //                           highlightColor: Colors.black.withOpacity(0.08),
    //                           onTap: () async {
    //                             await Future.delayed(const Duration(milliseconds: 120));
    //                             if (list[index].type == "web_page") {
    //                               final uri = Uri.parse(list[index].link_id ?? '');
    //
    //                               if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    //                                 throw 'Could not launch $uri';
    //                               }
    //                             } else if (list[index].type == "product") {
    //                               Go.to(
    //                                 Routes.productDetailPage,
    //                                 argument: {'productId': int.parse(list[index].link_id ?? '')},
    //                               );
    //                             } else if (list[index].type == "store") {
    //                               context.read<GetMarketByIdCubit>().getStoreById(
    //                                 int.parse(list[index].link_id ?? ''),
    //                               );
    //                               Go.to(Routes.publicStoreDetail);
    //                             }
    //                           },
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           );
    //         },
    //       ),
    //     );
    //   },
    // );
  }
}

class BannerListWidget extends StatelessWidget {
  final List<banner.Banner> list;
  final int priority;

  const BannerListWidget({super.key, required this.list, required this.priority});

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const SizedBox(height: 220); // keeps animation smooth
    }

    final type = list.first.size_type;

    double height;
    NetworkImageType imageType;

    switch (type) {
      case 'medium':
        height = 220;
        imageType = NetworkImageType.medium;
        break;
      case 'large':
        height = 290;
        imageType = NetworkImageType.large;
        break;
      default:
        height = 150;
        imageType = NetworkImageType.small;
    }

    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        separatorBuilder: (_, __) => const Box(w: 10),
        itemBuilder: (context, index) {
          return Padd(
            left: index == 0 ? 10 : 0,
            child: Ink(
              width:
                  MediaQuery.of(context).size.width * (list.length > 1 ? 0.9 : 1) -
                  (list.length > 1 ? 0 : 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (list[index].file != null)
                      IgnorePointer(
                        ignoring: true,
                        child: MeninkiNetworkImage(
                          file: list[index].file!,
                          networkImageType: imageType,
                          fit: BoxFit.contain,
                        ),
                      ),
                    Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        splashColor: Colors.black.withOpacity(0.15),
                        highlightColor: Colors.black.withOpacity(0.08),
                        onTap: () async {
                          if (list[index].type == "web_page") {
                            final uri = Uri.parse(list[index].link_id ?? '');
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          } else if (list[index].type == "product") {
                            Go.to(
                              Routes.productDetailPage,
                              argument: {'productId': int.parse(list[index].link_id ?? '')},
                            );
                          } else if (list[index].type == "store") {
                            context.read<GetMarketByIdCubit>().getStoreById(
                              int.parse(list[index].link_id ?? ''),
                            );
                            Go.to(Routes.publicStoreDetail);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class BannerSkeleton extends StatelessWidget {
  const BannerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: const Color(0xFFEAEAEA),
        highlightColor: const Color(0xFFF5F5F5),
      ),
      child: SizedBox(
        height: 220,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return Padd(
              left: 10,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.5),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => Box(w: 4),
          itemCount: 4,
        ),
      ),
    );
  }
}
