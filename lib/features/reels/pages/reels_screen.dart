import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/features/auth/models/user.dart';
import 'package:meninki/features/comments/pages/comments_page.dart';
import 'package:meninki/features/global/widgets/images_back_button.dart';
import 'package:meninki/features/global/widgets/meninki_network_image.dart';
import 'package:meninki/features/reels/blocs/current_reel_cubit/current_reel_cubit.dart';
import 'package:meninki/features/reels/blocs/like_reels_cubit/liked_reels_cubit.dart';
import 'package:meninki/features/reels/model/reels.dart';
import '../../../core/api.dart';
import '../widgets/custom_video_progress.dart';
import '../widgets/reel_sheet.dart';
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
      // context.read<CurrentReelCubit>().set(widget.reel);
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
        // onPageChanged: (index) {
        //   context.read<CurrentReelCubit>().set(widget.reels[index]);
        // },
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

  bool x2 = false;

  @override
  void initState() {
    var masterIndex = (widget.reel.file.playlists ?? []).indexWhere((e) => e.contains('master'));
    var url =
        masterIndex != -1
            ? widget.reel.file.playlists![masterIndex]
            : widget.reel.file.original_file;
    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      "$baseUrl/public/$url",
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
      fit: BoxFit.cover,
      looping: true,
      allowedScreenSleep: false,
      controlsConfiguration: BetterPlayerControlsConfiguration(
        showControls: false, // must be true for progress to appear
      ),
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
    controller.play();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    (controller.isVideoInitialized() ?? false)
                        ? BetterPlayer(controller: controller)
                        : IgnorePointer(
                          ignoring: true,
                          child: MeninkiNetworkImage(
                            file: widget.reel.file,
                            networkImageType: NetworkImageType.large,
                          ),
                        ),
                    if (!x2)
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
                                  fontSize: 16,
                                ),
                              ),
                              ExpandableText(text: widget.reel.description ?? ''),
                            ],
                          ),
                        ),
                      ),
                    Positioned.fill(
                      child: Row(
                        children: [
                          // LEFT — 2x
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onLongPressStart: (_) {
                                controller.setSpeed(2.0);
                                x2 = true;
                                setState(() {});
                              },
                              onLongPressEnd: (_) {
                                controller.setSpeed(1.0);
                                x2 = false;
                                setState(() {});
                              },
                              child: const SizedBox.expand(),
                            ),
                          ),

                          // CENTER — pause
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onLongPressStart: (_) {
                                controller.pause();
                              },
                              onLongPressEnd: (_) {
                                controller.play();
                              },
                              child: const SizedBox.expand(),
                            ),
                          ),

                          // RIGHT — 2x
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onLongPressStart: (_) {
                                controller.setSpeed(2.0);
                                x2 = true;
                                setState(() {});
                              },
                              onLongPressEnd: (_) {
                                controller.setSpeed(1.0);
                                x2 = false;
                                setState(() {});
                              },
                              child: const SizedBox.expand(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padd(
                hor: 10,
                child: Column(
                  children: [
                    if (x2)
                      Text(
                        AppLocalizations.of(context)!.speed2x,
                        style: TextStyle(color: Colors.white, fontSize: 14, height: 1),
                      ),
                    InstaProgressBar(controller: controller),
                  ],
                ),
              ),
              if (!x2)
                Padd(
                  hor: 10,
                  ver: 14,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child:
                              widget.reel.product?.cover_image != null
                                  ? MeninkiNetworkImage(
                                    file: widget.reel.product!.cover_image!,
                                    networkImageType: NetworkImageType.small,
                                    fit: BoxFit.cover,
                                  )
                                  : null,
                        ),
                      ),
                      Box(w: 10),
                      Expanded(
                        child: Text(
                          widget.reel.product?.name.trans(context) ?? '',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          showModalBottomSheet(
                            backgroundColor: Color(0xFFF3F3F3),
                            context: context,
                            builder: (context) {
                              return ReelsSheet(widget.reel);
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 4, bottom: 4, right: 4, left: 8),
                          child: Icon(Icons.more_horiz, color: Color(0xFF969696)),
                        ),
                      ),
                    ],
                  ),
                ),
              if (x2) Container(height: 60),
            ],
          ),
        ),
        if (!x2)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5 - 30,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                UsersProfile(widget.reel.user ?? User()),
                BlocBuilder<LikedReelsCubit, LikedReelsState>(
                  builder: (context, state) {
                    if (state is LikedReelsSuccess) {
                      return InkWell(
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
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      isScrollControlled: true,
                      builder: (context) {
                        return DraggableScrollableSheet(
                          expand: false,
                          initialChildSize: 0.5,
                          minChildSize: 0.5,
                          maxChildSize: 0.8,
                          builder: (context, scrollController) {
                            return CommentsPage(
                              reel: widget.reel,
                              scrollController: scrollController,
                            );
                          },
                        );
                      },
                    );
                  },
                  child: iconCount(
                    icon: "comment",
                    count: (widget.reel.comment_count ?? 0).toString(),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: Color(0xFFF3F3F3),
                      context: context,
                      builder: (context) {
                        return ReelsSheet(widget.reel);
                      },
                    );
                  },
                  child: iconCount(
                    icon: "repost",
                    count: (widget.reel.repost_count ?? 0).toString(),
                  ),
                ),
              ],
            ),
          ),
        if (!x2) ImagesBackButton(),
      ],
    );
    // return BlocConsumer<CurrentReelCubit, CurrentReelState>(
    //   listener: (context, state) {
    //     if (state is CurrentReelSuccess &&
    //         state.reel?.id == widget.reel.id &&
    //         // (controller.isVideoInitialized() ?? false) &&
    //         !(controller.isPlaying() ?? true)) {
    //       controller.play();
    //       firstPlaying = false;
    //     }
    //     if (state is CurrentReelSuccess &&
    //         (controller.isPlaying() ?? false) &&
    //         state.reel?.id != widget.reel.id) {
    //       controller.pause();
    //     }
    //   },
    //   builder: (context, state) {
    //     if (firstPlaying &&
    //         state is CurrentReelSuccess &&
    //         state.reel?.id == widget.reel.id &&
    //         (controller.isVideoInitialized() ?? false) &&
    //         !(controller.isPlaying() ?? true)) {
    //       controller.play();
    //       firstPlaying = false;
    //     }
    //     return Stack(
    //       children: [
    //         Container(
    //           height: MediaQuery.of(context).size.height,
    //           width: MediaQuery.of(context).size.width,
    //           color: Colors.black,
    //           child: Column(
    //             children: [
    //               Expanded(
    //                 child: Stack(
    //                   alignment: Alignment.center,
    //                   children: [
    //                     (controller.isVideoInitialized() ?? false)
    //                         ? BetterPlayer(controller: controller)
    //                         : IgnorePointer(
    //                           ignoring: true,
    //                           child: MeninkiNetworkImage(
    //                             file: widget.reel.file,
    //                             networkImageType: NetworkImageType.large,
    //                           ),
    //                         ),
    //                     Align(
    //                       alignment: Alignment.bottomLeft,
    //                       child: Padd(
    //                         pad: 10,
    //                         child: Column(
    //                           mainAxisSize: MainAxisSize.min,
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             Text(
    //                               '@${widget.reel.user_id}',
    //                               style: TextStyle(
    //                                 color: Colors.white,
    //                                 fontWeight: FontWeight.w500,
    //                                 fontSize: 16,
    //                               ),
    //                             ),
    //                             ExpandableText(text: widget.reel.description ?? ''),
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //                     Positioned.fill(
    //                       child: Row(
    //                         children: [
    //                           // LEFT — 2x
    //                           Expanded(
    //                             flex: 1,
    //                             child: GestureDetector(
    //                               behavior: HitTestBehavior.translucent,
    //                               onLongPressStart: (_) {
    //                                 controller.setSpeed(2.0);
    //                               },
    //                               onLongPressEnd: (_) {
    //                                 controller.setSpeed(1.0);
    //                               },
    //                               child: const SizedBox.expand(),
    //                             ),
    //                           ),
    //
    //                           // CENTER — pause
    //                           Expanded(
    //                             flex: 2,
    //                             child: GestureDetector(
    //                               behavior: HitTestBehavior.translucent,
    //                               onLongPressStart: (_) {
    //                                 controller.pause();
    //                               },
    //                               onLongPressEnd: (_) {
    //                                 controller.play();
    //                               },
    //                               child: const SizedBox.expand(),
    //                             ),
    //                           ),
    //
    //                           // RIGHT — 2x
    //                           Expanded(
    //                             flex: 1,
    //                             child: GestureDetector(
    //                               behavior: HitTestBehavior.translucent,
    //                               onLongPressStart: (_) {
    //                                 controller.setSpeed(2.0);
    //                               },
    //                               onLongPressEnd: (_) {
    //                                 controller.setSpeed(1.0);
    //                               },
    //                               child: const SizedBox.expand(),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               Padd(hor: 10, child: InstaProgressBar(controller: controller)),
    //               Padd(
    //                 hor: 10,
    //                 ver: 14,
    //                 child: Row(
    //                   children: [
    //                     ClipRRect(
    //                       borderRadius: BorderRadius.circular(4),
    //                       child: Container(
    //                         height: 30,
    //                         width: 30,
    //                         decoration: BoxDecoration(
    //                           color: Colors.grey,
    //                           borderRadius: BorderRadius.circular(4),
    //                         ),
    //                         child:
    //                             widget.reel.product?.cover_image != null
    //                                 ? MeninkiNetworkImage(
    //                                   file: widget.reel.product!.cover_image!,
    //                                   networkImageType: NetworkImageType.small,
    //                                   fit: BoxFit.cover,
    //                                 )
    //                                 : null,
    //                       ),
    //                     ),
    //                     Box(w: 10),
    //                     Expanded(
    //                       child: Text(
    //                         widget.reel.product?.name.trans(context) ?? '',
    //                         style: TextStyle(fontSize: 16, color: Colors.white),
    //                         maxLines: 1,
    //                         overflow: TextOverflow.ellipsis,
    //                       ),
    //                     ),
    //                     GestureDetector(
    //                       behavior: HitTestBehavior.translucent,
    //                       onTap: () {
    //                         showModalBottomSheet(
    //                           backgroundColor: Color(0xFFF3F3F3),
    //                           context: context,
    //                           builder: (context) {
    //                             return ReelsSheet(widget.reel);
    //                           },
    //                         );
    //                       },
    //                       child: Container(
    //                         padding: EdgeInsets.only(top: 4, bottom: 4, right: 4, left: 8),
    //                         child: Icon(Icons.more_horiz, color: Color(0xFF969696)),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         Positioned(
    //           top: MediaQuery.of(context).size.height * 0.5 - 30,
    //           right: 20,
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               UsersProfile(),
    //               BlocBuilder<LikedReelsCubit, LikedReelsState>(
    //                 builder: (context, state) {
    //                   if (state is LikedReelsSuccess) {
    //                     return InkWell(
    //                       onTap: () {
    //                         var count =
    //                             (widget.reel.user_favorite_count ?? 0) +
    //                             (state.reelIds.contains(widget.reel.id) ? -1 : 1);
    //                         widget.reel = widget.reel.copyWith(user_favorite_count: count);
    //                         setState(() {});
    //                         context.read<LikedReelsCubit>().likeTapped(widget.reel.id);
    //                       },
    //                       child: iconCount(
    //                         icon: state.reelIds.contains(widget.reel.id) ? "liked" : 'notLiked',
    //                         count: (widget.reel.user_favorite_count ?? 0).toString(),
    //                       ),
    //                     );
    //                   }
    //                   return Container();
    //                 },
    //               ),
    //               InkWell(
    //                 onTap: () {
    //                   showModalBottomSheet(
    //                     context: context,
    //                     backgroundColor: Colors.white,
    //                     isScrollControlled: true,
    //                     builder: (context) {
    //                       return DraggableScrollableSheet(
    //                         expand: false,
    //                         initialChildSize: 0.5,
    //                         minChildSize: 0.5,
    //                         maxChildSize: 0.8,
    //                         builder: (context, scrollController) {
    //                           return CommentsPage(
    //                             reel: widget.reel,
    //                             scrollController: scrollController,
    //                           );
    //                         },
    //                       );
    //                     },
    //                   );
    //                 },
    //                 child: iconCount(
    //                   icon: "comment",
    //                   count: (widget.reel.comment_count ?? 0).toString(),
    //                 ),
    //               ),
    //               iconCount(icon: "repost", count: (widget.reel.repost_count ?? 0).toString()),
    //             ],
    //           ),
    //         ),
    //         ImagesBackButton(),
    //       ],
    //     );
    //   },
    // );
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
