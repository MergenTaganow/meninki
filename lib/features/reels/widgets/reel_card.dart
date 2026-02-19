import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/global/widgets/meninki_network_image.dart';
import 'package:meninki/features/reels/widgets/reel_sheet.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../core/helpers.dart';
import '../blocs/reels_controllers_bloc/reels_controllers_bloc.dart';
import '../model/reels.dart';

class ReelCard extends StatefulWidget {
  const ReelCard({
    super.key,
    required this.reel,
    required this.allReels,
    this.primaryText,
    this.playingReels = false,
  });

  final Reel reel;
  final List<Reel> allReels;
  final Color? primaryText;
  final bool playingReels;

  @override
  State<ReelCard> createState() => _ReelCardState();
}

class _ReelCardState extends State<ReelCard> {
  bool playing = true;
  late Key visibilityKey;

  @override
  void initState() {
    visibilityKey = Key('reel_visibility_${widget.reel.id}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    final controller = context.select<ReelsControllersBloc, BetterPlayerController?>(
      (bloc) => bloc.controllersMap[widget.reel.id],
    );

    if (!widget.playingReels && playing && controller != null) {
      controller.pause();
      playing = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }

    if (controller == null && playing) {
      playing = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Ink(
          height: 240,
          width: MediaQuery.of(context).size.width / 2,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: VisibilityDetector(
                  onVisibilityChanged: (VisibilityInfo info) async {
                    if (controller == null) return;

                    if (!mounted) return;

                    if (info.visibleFraction * 100 < 80) {
                      if (controller.isPlaying() ?? false) {
                        await controller.pause();
                        playing = false;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {});
                        });
                      }
                    }
                    if (info.visibleFraction * 100 > 80) {
                      if (!(controller.isPlaying() ?? true)) {
                        await controller.play();
                        playing = true;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {});
                        });
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
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (controller != null)
                          SizedBox(
                            height: 240,
                            width: MediaQuery.of(context).size.width / 2,
                            child: BetterPlayer(
                              key: ValueKey(widget.reel.id),
                              controller: controller,
                            ),
                          ),
                        if (!playing)
                          SizedBox(
                            height: 240,
                            width: MediaQuery.of(context).size.width / 2,
                            child: IgnorePointer(
                              ignoring: true,
                              child: MeninkiNetworkImage(
                                file: widget.reel.file,
                                networkImageType: NetworkImageType.small,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                      ],
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
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 120));
                    Go.to(
                      Routes.reelScreen,
                      argument: {"reel": widget.reel, "reels": widget.allReels},
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                right: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    iconText("notLiked", widget.reel.user_favorite_count),
                    iconText("watchers_count", widget.reel.reel_watchers_count),
                  ],
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Go.to(Routes.reelScreen, argument: {"reel": widget.reel, "reels": widget.allReels});
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.reel.title ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w500, color: widget.primaryText),
                ),
              ),
              Box(w: 10),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: Color(0xFFF3F3F3),
                    context: context,
                    builder: (context) {
                      return ReelsSheet(widget.reel);
                    },
                  );
                },
                child: Icon(Icons.more_horiz, color: widget.primaryText ?? Color(0xFF969696)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget iconText(String icon, int? count) {
    final int safeCount = count ?? 0;

    String formattedCount;
    if (safeCount >= 1000) {
      formattedCount = '${(safeCount / 1000).floor()}K';
    } else {
      formattedCount = safeCount.toString();
    }
    return Row(
      children: [
        Svvg.asset(icon, size: 16),
        Box(w: 4),
        Text(formattedCount, style: TextStyle(color: Colors.white)),
      ],
    );
  }

  // @override
  // bool get wantKeepAlive => true;
}
