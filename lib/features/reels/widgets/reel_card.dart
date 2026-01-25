import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/global/widgets/meninki_network_image.dart';
import 'package:meninki/features/reels/widgets/reel_sheet.dart';
import 'package:meninki/features/store/pages/store_create_page.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../core/api.dart';
import '../../../core/helpers.dart';
import '../../file_download/bloc/file_download_bloc/file_download_bloc.dart';
import '../blocs/like_reels_cubit/liked_reels_cubit.dart';
import '../blocs/reel_playin_queue_cubit/reel_playing_queue_cubit.dart';
import '../model/reels.dart';

class ReelCard extends StatelessWidget {
  const ReelCard({super.key, required this.reel, required this.allReels, this.primaryText});

  final Reel reel;
  final List<Reel> allReels;
  final Color? primaryText;

  @override
  Widget build(BuildContext context) {
    final visibilityKey = Key('reel_visibility_${reel.id}');
    return BlocBuilder<ReelPlayingQueueCubit, ReelPlayingQueueState>(
      builder: (context, state) {
        if (state is ReelPlaying) {
          final controller = state.controllers[reel.id];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Ink(
                height: 240,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: VisibilityDetector(
                        onVisibilityChanged: (VisibilityInfo info) {
                          if (controller?.isPlaying() ?? false) {
                            final visiblePercent = info.visibleFraction * 100;
                            if (visiblePercent < 15) {
                              context.read<ReelPlayingQueueCubit>().playNext();
                            }
                          }
                        },
                        key: visibilityKey,
                        child: Container(
                          height: 240,
                          width: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color:
                                (controller?.isVideoInitialized() ?? false)
                                    ? Colors.black
                                    : Colors.grey.withOpacity(0.5),
                          ),
                          child:
                              (controller != null &&
                                      (controller.isVideoInitialized() ?? false) &&
                                      (controller.isPlaying() ?? false))
                                  ? Center(child: BetterPlayer(controller: controller))
                                  : IgnorePointer(
                                    ignoring: true,
                                    child: MeninkiNetworkImage(
                                      file: reel.file,
                                      networkImageType: NetworkImageType.small,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        splashColor: Colors.black.withOpacity(0.15),
                        highlightColor: Colors.black.withOpacity(0.08),
                        onLongPress: () {
                          context.read<FileDownloadBloc>().add(DownloadFile(reel.file));
                        },
                        onTap: () async {
                          await Future.delayed(const Duration(milliseconds: 120));
                          Go.to(Routes.reelScreen, argument: {"reel": reel, "reels": allReels});
                        },
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Go.to(Routes.reelScreen, argument: {"reel": reel, "reels": allReels});
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        reel.title ?? '',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w500, color: primaryText),
                      ),
                    ),
                    Box(w: 10),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Color(0xFFF3F3F3),
                          context: context,
                          builder: (context) {
                            return ReelsSheet(reel);
                          },
                        );
                      },
                      child: Icon(Icons.more_horiz, color: primaryText ?? Color(0xFF969696)),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
