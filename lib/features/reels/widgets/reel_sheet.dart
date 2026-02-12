import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/features/reels/blocs/reel_create_cubit/reel_create_cubit.dart';

import '../../../core/go.dart';
import '../../../core/helpers.dart';
import '../../../core/routes.dart';
import '../../file_download/bloc/file_download_bloc/file_download_bloc.dart';
import '../blocs/like_reels_cubit/liked_reels_cubit.dart';
import '../model/reels.dart';

class ReelsSheet extends StatelessWidget {
  final Reel reel;
  const ReelsSheet(this.reel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padd(
      hor: 16,
      ver: 30,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<LikedReelsCubit, LikedReelsState>(
            builder: (context, state) {
              if (state is LikedReelsSuccess) {
                return singleLine(
                  context: context,
                  title: AppLocalizations.of(context)!.like,
                  value: Row(
                    children: [
                      Text(
                        (reel.user_favorite_count ?? 0).toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: state.reelIds.contains(reel.id) ? Colors.black : Color(0xFF969696),
                        ),
                      ),
                      Box(w: 6),
                      Svvg.asset(
                        state.reelIds.contains(reel.id) ? "liked" : 'notLiked',
                        color: state.reelIds.contains(reel.id) ? null : Colors.black,
                        size: 20,
                      ),
                    ],
                  ),
                  onTap: () {
                    var count =
                        (reel.user_favorite_count ?? 0) +
                        (state.reelIds.contains(reel.id) ? -1 : 1);
                    context.read<LikedReelsCubit>().likeTapped(reel.id);
                  },
                );
              }
              return Container();
            },
          ),
          singleLine(
            context: context,
            title: "repost",
            value: Svvg.asset("share"),
            onTap: () {
              context.read<ReelCreateCubit>().repostReel(reel);
            },
          ),
          singleLine(
            context: context,
            title: AppLocalizations.of(context)!.download,
            value: Svvg.asset("download"),
            onTap: () {
              context.read<FileDownloadBloc>().add(DownloadFile(reel.file));
            },
          ),
          if (reel.product?.id != null)
            singleLine(
              context: context,
              title: AppLocalizations.of(context)!.goToProduct,
              value: Svvg.asset("go_to_product"),
              onTap: () {
                print('object');
                print(reel.product!.id);

                Go.to(Routes.publicProductDetailPage, argument: {"productId": reel.product!.id});
                print('object');
              },
            ),
          singleLine(
            context: context,
            title: AppLocalizations.of(context)!.share,
            value: Svvg.asset("share"),
          ),
          singleLine(
            context: context,
            title: AppLocalizations.of(context)!.complaint,
            value: Svvg.asset("danger_light"),
          ),
        ],
      ),
    );
  }

  Widget singleLine({
    required BuildContext context,
    required String title,
    required Widget value,
    void Function()? onTap,
  }) {
    return Padd(
      bot: 10,
      child: Material(
        color: Colors.white, // 👈 MOVE background HERE
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          splashColor: Colors.black.withOpacity(0.15),
          highlightColor: Colors.black.withOpacity(0.05),
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.pop(context);
            if (onTap != null) {
              onTap();
            }
          },
          child: Container(
            height: 46,
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(title, style: TextStyle(fontWeight: FontWeight.w500)), value],
            ),
          ),
        ),
      ),
    );
  }
}
