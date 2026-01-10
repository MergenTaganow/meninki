import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/features/comments/pages/comments_page.dart';
import 'package:meninki/features/global/widgets/meninki_network_image.dart';
import 'package:meninki/features/reels/blocs/current_reel_cubit/current_reel_cubit.dart';
// import 'package:meninki/features/reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import 'package:meninki/features/reels/blocs/like_reels_cubit/liked_reels_cubit.dart';
import 'package:meninki/features/reels/model/reels.dart';
import '../../../core/api.dart';
import '../../../core/go.dart';
import '../../../core/routes.dart';
import '../widgets/users_profile.dart';

class ReelPage extends StatefulWidget {
  final Reel reel;
  final List<Reel> reels;
  const ReelPage({required this.reel, required this.reels, super.key});

  @override
  State<ReelPage> createState() => _ReelPageState();
}

class _ReelPageState extends State<ReelPage> {
  // late PreloadPageController controller;
  late PageController controller;

  @override
  void initState() {
    var position = widget.reels.indexWhere((e) => e.id == widget.reel.id);
    // controller = PreloadPageController(initialPage: position);
    controller = PageController(initialPage: position);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CurrentReelCubit>().set(widget.reel);
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: controller,
        scrollDirection: Axis.vertical,
        // preloadPagesCount: 3,
        itemCount: widget.reels.length,
        onPageChanged: (index) {
          context.read<CurrentReelCubit>().set(widget.reels[index]);
        },
        itemBuilder: (context, index) {
          return ReelWidget(reel: widget.reels[index]);
        },
      ),
    );
  }
}

class ReelWidget extends StatefulWidget {
  Reel reel;
  ReelWidget({super.key, required this.reel});

  @override
  State<ReelWidget> createState() => _ReelWidgetState();
}

class _ReelWidgetState extends State<ReelWidget> {
  late BetterPlayerController controller;

  bool firstPlaying = true;

  @override
  void initState() {
    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      "$baseUrl/public/${widget.reel.file.video_master_playlist}",
      useAsmsAudioTracks: false,
      useAsmsSubtitles: false,
      useAsmsTracks: false,
      videoFormat: BetterPlayerVideoFormat.hls,
      bufferingConfiguration: BetterPlayerBufferingConfiguration(
        minBufferMs: 2000, // lower → faster start
        maxBufferMs: 10000, // enough for stability
        bufferForPlaybackMs: 300, // super fast start
        bufferForPlaybackAfterRebufferMs: 1000,
      ),
      cacheConfiguration: BetterPlayerCacheConfiguration(
        useCache: true,
        maxCacheSize: 500 * 1024 * 1024, // 50 MB
        maxCacheFileSize: 50 * 1024 * 1024, // 10 MB per file
      ),
    );

    final betterPlayerConfiguration = BetterPlayerConfiguration(
      looping: true,
      allowedScreenSleep: false,
      controlsConfiguration: BetterPlayerControlsConfiguration(showControls: false),
    );

    controller = BetterPlayerController(
      betterPlayerConfiguration,
      betterPlayerDataSource: dataSource,
    );
    controller.addEventsListener((event) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
          controller.setOverriddenAspectRatio(controller.videoPlayerController!.value.aspectRatio);
          setState(() {});
        }
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CurrentReelCubit, CurrentReelState>(
      listener: (context, state) {
        if (state is CurrentReelSuccess &&
            state.reel?.id == widget.reel.id &&
            // (controller.isVideoInitialized() ?? false) &&
            !(controller.isPlaying() ?? true)) {
          print("##########play will be called############");
          controller.play();
          firstPlaying = false;
        }
        if (state is CurrentReelSuccess &&
            (controller.isPlaying() ?? false) &&
            state.reel?.id != widget.reel.id) {
          controller.pause();
        }
      },
      builder: (context, state) {
        print(firstPlaying);
        if (firstPlaying &&
            state is CurrentReelSuccess &&
            state.reel?.id == widget.reel.id &&
            (controller.isVideoInitialized() ?? false) &&
            !(controller.isPlaying() ?? true)) {
          print("will play reel from builder");
          controller.play();
          firstPlaying = false;
        }
        return Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        (controller.isVideoInitialized() ?? false) &&
                                (controller.isPlaying() ?? false)
                            ? BetterPlayer(controller: controller)
                            : IgnorePointer(
                              ignoring: true,
                              child: MeninkiNetworkImage(
                                file: widget.reel.file,
                                networkImageType: NetworkImageType.large,
                              ),
                            ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padd(
                            pad: 10,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '@${widget.reel.user_id}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                ExpandableText(text: widget.reel.description ?? ''),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padd(
                    hor: 10,
                    ver: 14,
                    child: Row(
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Box(w: 10),
                        Expanded(
                          child: Text(
                            widget.reel.title ?? '',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                        Icon(Icons.more_horiz, color: Color(0xFF969696)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.5 - 30,
              right: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UsersProfile(),
                  BlocBuilder<LikedReelsCubit, LikedReelsState>(
                    builder: (context, state) {
                      if (state is LikedReelsSuccess) {
                        return GestureDetector(
                          onTap: () {
                            var count =
                                (widget.reel.user_favorite_count ?? 0) +
                                (state.reelIds.contains(widget.reel.id) ? -1 : 1);
                            widget.reel = widget.reel.copyWith(user_favorite_count: count);
                            setState(() {});
                            context.read<LikedReelsCubit>().likeTapped(widget.reel.id);
                          },
                          child: iconCount(
                            icon: state.reelIds.contains(widget.reel.id) ? "liked" : 'notLiked',
                            count: (widget.reel.user_favorite_count ?? 0).toString(),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                  GestureDetector(
                    onTap: () async {
                      await controller.videoPlayerController?.pause();
                      // var position = await controller.videoPlayerController?.position;
                      // controller.setVolume(0);

                      // await Go.to(Routes.commentsPage, argument: {"reel": widget.reel})?
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CommentsPage(reel: widget.reel)),
                      );

                      // print(controller.isVideoInitialized());
                      // controller.seekTo(position ?? Duration(seconds: 0));
                      // controller.setVolume(100);

                      // print("set reel colled again");
                      // firstPlaying = true;
                    },
                    child: iconCount(
                      icon: "comment",
                      count: (widget.reel.comment_count ?? 0).toString(),
                    ),
                  ),
                  iconCount(icon: "repost", count: (widget.reel.repost_count ?? 0).toString()),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Column iconCount({required String icon, required String count}) {
    return Column(
      children: [
        Box(h: 20),
        Svvg.asset(icon),
        Text(count, style: TextStyle(fontSize: 12, color: Colors.white)),
      ],
    );
  }
}
