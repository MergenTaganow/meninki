import 'package:flutter/material.dart';

import '../../../core/go.dart';
import '../../../core/helpers.dart';
import '../../../core/routes.dart';
import '../../global/widgets/meninki_network_image.dart';
import '../../store/widgets/store_background_color_selection.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.height,
    this.width,
    this.scheme,
    this.isPublic = true,
  });

  final Product product;
  final double? height;
  final double? width;
  final MarketColorScheme? scheme;
  final bool isPublic;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 240,
      width: width ?? 130,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Ink(
            height: (height ?? 240) - 85,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    height: (height ?? 240) - 85,
                    width: width ?? 130,
                    color: product.cover_image == null ? Color(0xFFEAEAEA) : null,
                    child:
                        product.cover_image != null
                            ? IgnorePointer(
                              ignoring: true,
                              child: MeninkiNetworkImage(
                                file: product.cover_image!,
                                networkImageType: NetworkImageType.small,
                                fit: BoxFit.cover,
                              ),
                            )
                            : null,
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
                      await Future.delayed(const Duration(milliseconds: 120));
                      if (isPublic) {
                        Go.to(Routes.publicProductDetailPage, argument: {"productId": product.id});
                      } else {
                        Go.to(Routes.myProductDetailPage, argument: {"productId": product.id});
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              print(product.discount);
              print(product.discount != null);
              print(product.discount != null ? scheme?.textSecondary : scheme?.textPrimary);
              // Go.to(Routes.productDetailPage, argument: {"productId": product.id});
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Box(h: 4),

                Text(
                  product.name.trans(context) ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(height: 1.2, color: scheme?.textPrimary),
                ),
                Box(h: 4),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${product.price?.toStringAsFixed(product.price is int ? 0 : 2) ?? '-'} TMT",
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            ((product.discount ?? 0) > 0)
                                ? (scheme?.textSecondary ?? Color(0xFF969696))
                                : scheme?.textPrimary,
                      ),
                    ),
                    if ((product.discount ?? 0) > 0)
                      Text(
                        "-${(100 - ((product.discount! * 100) / product.price!)).toStringAsFixed(0)}%",
                        style: TextStyle(fontSize: 12, color: scheme?.textPrimary),
                      ),
                  ],
                ),
                if ((product.discount ?? 0) > 0)
                  Text(
                    "${product.discount?.toStringAsFixed(product.discount is int ? 0 : 2) ?? '-'} TMT",
                    style: TextStyle(fontSize: 12, color: scheme?.textPrimary),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
