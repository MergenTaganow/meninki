import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/features/global/widgets/meninki_network_image.dart';
import 'package:meninki/features/reels/blocs/current_reel_cubit/current_reel_cubit.dart';
import 'package:meninki/features/reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import 'package:meninki/features/reels/blocs/like_reels_cubit/liked_reels_cubit.dart';
import 'package:meninki/features/reels/model/reels.dart';
import '../../../core/api.dart';
import '../widgets/users_profile.dart';

class ReelPage extends StatefulWidget {
  final Reel reel;
  const ReelPage({required this.reel, super.key});

  @override
  State<ReelPage> createState() => _ReelPageState();
}

class _ReelPageState extends State<ReelPage> {
  // late PreloadPageController controller;
  late PageController controller;

  @override
  void initState() {
    var position = context.read<GetReelsBloc>().reels.indexWhere((e) => e.id == widget.reel.id);
    print("position-____$position");
    print("position-____$position");
    print("position-____$position");
    print("position-____$position");
    // controller = PreloadPageController(initialPage: position);
    controller = PageController(initialPage: position);
    context.read<CurrentReelCubit>().set(widget.reel);
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
      body: BlocBuilder<GetReelsBloc, GetReelsState>(
        builder: (context, state) {
          if (state is GetReelSuccess) {
            // var urls =
            //     state.reels.map((e) => "$baseUrl/public/${e.file.video_master_playlist}").toList();
            // ListView.builder(
            //   itemCount: urls.length,
            //   itemBuilder: (context, index) {
            //     return SizedBox(
            //       height: MediaQuery.of(context).size.height,
            //       child: BetterPlayerListVideoPlayer(
            //         BetterPlayerDataSource(
            //           BetterPlayerDataSourceType.network,
            //           urls[index],
            //           videoFormat: BetterPlayerVideoFormat.hls,
            //           bufferingConfiguration: BetterPlayerBufferingConfiguration(
            //             minBufferMs: 500, // lower → faster start
            //             maxBufferMs: 3000, // enough for stability
            //             bufferForPlaybackMs: 300, // super fast start
            //             bufferForPlaybackAfterRebufferMs: 1000,
            //           ),
            //         ),
            //         configuration: BetterPlayerConfiguration(
            //           autoPlay: true,
            //           looping: true,
            //           fit: BoxFit.contain,
            //           controlsConfiguration: BetterPlayerControlsConfiguration(showControls: false),
            //           placeholder: Center(child: CircularProgressIndicator()),
            //         ),
            //       ),
            //     );
            //   },
            // );
            return PageView.builder(
              controller: controller,
              scrollDirection: Axis.vertical,
              // preloadPagesCount: 3,
              itemCount: state.reels.length,
              onPageChanged: (index) {
                context.read<CurrentReelCubit>().set(state.reels[index]);
              },
              itemBuilder: (context, index) {
                return ReelWidget(reel: state.reels[index]);
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}

class ReelWidget extends StatefulWidget {
  final Reel reel;
  const ReelWidget({super.key, required this.reel});

  @override
  State<ReelWidget> createState() => _ReelWidgetState();
}

class _ReelWidgetState extends State<ReelWidget> {
  late BetterPlayerController controller;

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
    return BlocBuilder<CurrentReelCubit, CurrentReelState>(
      builder: (context, state) {
        if (state is CurrentReelSuccess &&
            state.reel?.id == widget.reel.id &&
            (controller.isVideoInitialized() ?? false) &&
            !(controller.isPlaying() ?? true)) {
          controller.play();
        }
        if (state is CurrentReelSuccess &&
            (controller.isPlaying() ?? false) &&
            state.reel?.id != widget.reel.id) {
          controller.pause();
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
                            : MeninkiNetworkImage(
                              file: widget.reel.file,
                              networkImageType: NetworkImageType.large,
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
                                  '@reviewer2023',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                ExpandableText(
                                  text:
                                      'Купила очки как у моего братюни! Совсем недорого, горбатая бабка продавала на ВДНХ. Качество хорошее, цвет точно такой жеnad osi asxn rxak',
                                ),
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
                  iconCount(icon: "comment", count: (widget.reel.comment_count ?? 0).toString()),
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
