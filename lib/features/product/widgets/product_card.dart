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
    return GestureDetector(
      onTap: () {
        Go.to(Routes.productDetailPage, argument: {"productId": product.id});
      },
      child: SizedBox(
        height: height ?? 240,
        width: 130,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: (height ?? 240) - 70,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child:
                    (product.cover_image != null)
                        ? MeninkiNetworkImage(
                          file: product.cover_image!,
                          networkImageType: NetworkImageType.small,
                          fit: BoxFit.cover,
                        )
                        : null,
              ),
            ),
            Box(h: 4),
            Text(product.name.tk ?? ''),
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
                    "-${(100 - (product.price! * 100) / product.discount!).toStringAsFixed(0)}%",
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
    );
  }
}
