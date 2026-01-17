import 'package:flutter/material.dart';

import '../../../core/go.dart';
import '../../../core/helpers.dart';
import '../../../core/routes.dart';
import '../../global/widgets/meninki_network_image.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, this.height});

  final Product product;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 240,
      width: 130,
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
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child:
                          (product.cover_image != null)
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
                      Go.to(Routes.productDetailPage, argument: {"productId": product.id});
                    },
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Go.to(Routes.productDetailPage, argument: {"productId": product.id});
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Box(h: 4),

                Text(
                  product.name.tk ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(height: 1.2),
                ),
                Box(h: 4),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${product.price?.toStringAsFixed(product.price is int ? 0 : 2) ?? '-'} TMT",
                      style: TextStyle(fontSize: 12),
                    ),
                    if (product.discount != null)
                      Text(
                        "-${(product.discount!).toStringAsFixed(0)}%",
                        style: TextStyle(fontSize: 12),
                      ),
                  ],
                ),
                if (product.discount != null)
                  Text(
                    "${product.discount?.toStringAsFixed(product.discount is int ? 0 : 2) ?? '-'} TMT",
                    style: TextStyle(fontSize: 12, color: Color(0xFF969696)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
