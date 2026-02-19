import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/features/reels/blocs/get_reel_markets/get_reel_markets_bloc.dart';

import '../../../core/go.dart';
import '../../../core/routes.dart';
import '../../global/widgets/meninki_network_image.dart';
import '../bloc/get_market_by_id/get_market_by_id_cubit.dart';

class ReelMarketCard extends StatelessWidget {
  const ReelMarketCard({super.key, required this.store});

  final ReelMarket? store;

  @override
  Widget build(BuildContext context) {
    const radius = 14.0;
    return Ink(
      width: 90,
      height: 120,
      decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(radius)),
      child: Stack(
        children: [
          /// Image
          if (store?.market?.cover_image != null)
            Ink(
              width: 90,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: IgnorePointer(
                  ignoring: true,
                  child: MeninkiNetworkImage(
                    file: store!.market!.cover_image!,
                    networkImageType: NetworkImageType.small,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(radius),
            child: InkWell(
              borderRadius: BorderRadius.circular(radius),
              splashColor: Colors.black.withOpacity(0.15),
              highlightColor: Colors.black.withOpacity(0.08),
              onTap: () async {
                if (store?.market?.id != null) {
                  await Future.delayed(const Duration(milliseconds: 120));
                  context.read<GetMarketByIdCubit>().getStoreById(store!.market!.id);
                  Go.to(Routes.publicStoreDetail);
                }
              },
            ),
          ),

          /// Counter badge
          if (store?.market?.cover_image != null)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.black.withOpacity(0.3), width: 0.5),
                ),
                child: Text(
                  (store?.reel_count ?? store?.product_count ?? 0).toString(),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
