import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/routes.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../core/helpers.dart';
import '../blocs/reel_playin_queue_cubit/reel_playing_queue_cubit.dart';
import '../model/reels.dart';

class ReelCard extends StatelessWidget {
  const ReelCard({super.key, required this.reel});

  final Reel reel;

  @override
  Widget build(BuildContext context) {
    final visibilityKey = Key('reel_visibility_${reel.id}');
    return BlocBuilder<ReelPlayingQueueCubit, ReelPlayingQueueState>(
      builder: (context, state) {
        if (state is ReelPlaying) {
          final controller = state.controllers[reel.id];
          return InkWell(
            onTap: () {
              Go.to(Routes.reelScreen, argument: {"reel": reel});
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: VisibilityDetector(
                    onVisibilityChanged: (VisibilityInfo info) {
                      if (controller?.value.isPlaying ?? false) {
                        final visiblePercent = info.visibleFraction * 100;
                        if (visiblePercent < 15) {
                          context.read<ReelPlayingQueueCubit>().playNext();
                        }
                      }
                    },
                    key: visibilityKey,
                    child: Container(
                      height: 240,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color:
                            (controller?.value.isInitialized ?? false)
                                ? Colors.black
                                : Colors.grey.withOpacity(0.5),
                      ),
                      child:
                          (controller?.value.isInitialized ?? false)
                              ? Center(
                                child: AspectRatio(
                                  aspectRatio: controller!.value.aspectRatio,
                                  child: VideoPlayer(controller),
                                ),
                              )
                              : Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        reel.title ?? '',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Box(w: 10),
                    Icon(Icons.more_horiz, color: Color(0xFF969696)),
                  ],
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
