import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/go.dart';
import '../../../core/routes.dart';
import '../../global/widgets/meninki_network_image.dart';
import '../bloc/get_market_by_id/get_market_by_id_cubit.dart';
import '../models/market.dart';

class StoreCard extends StatelessWidget {
  const StoreCard({super.key, required this.store});

  final Market? store;

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
          if (store?.cover_image != null)
            Ink(
              width: 90,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: IgnorePointer(
                  ignoring: true,
                  child: MeninkiNetworkImage(
                    file: store!.cover_image!,
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
                if (store?.id != null) {
                  await Future.delayed(const Duration(milliseconds: 120));
                  context.read<GetMarketByIdCubit>().getStoreById(store!.id);
                  Go.to(Routes.publicStoreDetail);
                }
              },
            ),
          ),

          /// Counter badge
          if (store?.cover_image != null)
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
                  (store?.reel_verified_count ?? 0).toString(),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
